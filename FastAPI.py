import base64
import json
import os
import re
from io import BytesIO
from pathlib import Path
from typing import Any, Dict, List

from dotenv import load_dotenv
from fastapi import APIRouter, FastAPI, File, HTTPException, UploadFile
from fastapi.concurrency import run_in_threadpool
from fastapi.middleware.cors import CORSMiddleware
from groq import Groq
from PIL import Image

load_dotenv(dotenv_path=Path(__file__).resolve().parent / ".env")

app = FastAPI(
    title="Vision Learning API",
    version="1.0.0",
    description="Nhận ảnh và trả về JSON phục vụ học từ vựng tiếng Anh",
)

# Đã cập nhật CORS thành ["*"] để fix lỗi "Failed to fetch" trên Flutter Web/Mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

health_router = APIRouter(prefix="/health", tags=["health"])
vision_router = APIRouter(prefix="/ai", tags=["vision"])

VISION_PROMPT = """
Bạn là trợ lý hỗ trợ học từ vựng tiếng Anh. Hãy nhận diện đối tượng chính trong ảnh và trả về DUY NHẤT một JSON với các trường bắt buộc:
{
  "word": string,
  "phonetic": string,
  "vietnamese_meaning": string,
  "example_sentence": string,
  "pronunciation_guide": string,
  "word_type": string
}
Không được trả thêm bất cứ ký tự hay chú thích nào ngoài JSON hợp lệ.
""".strip()

def get_groq_client() -> Groq:
    api_key = os.getenv("GROQ_API_KEY", "").strip()
    if not api_key:
        raise HTTPException(status_code=500, detail="Chưa cấu hình GROQ_API_KEY trong môi trường.")
    return Groq(api_key=api_key)

def encode_image(image_bytes: bytes) -> str:
    return base64.b64encode(image_bytes).decode("utf-8")

def preprocess_image(image_bytes: bytes) -> str:
    try:
        img = Image.open(BytesIO(image_bytes))
        img = img.convert("RGB")
        img.thumbnail((640, 640), Image.Resampling.LANCZOS)
        buffer = BytesIO()
        img.save(buffer, format="JPEG", quality=85)
        return encode_image(buffer.getvalue())
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Ảnh không hợp lệ: {exc}")

def build_messages(base64_image: str) -> List[Dict[str, Any]]:
    return [
        {"role": "system", "content": VISION_PROMPT},
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": (
                        "Phân tích ảnh người dùng gửi, xác định từ vựng tiếng Anh phù hợp và trả kết quả theo format đã mô tả."
                    ),
                },
                {
                    "type": "image_url",
                    "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"},
                },
            ],
        },
    ]

# Đã fix lỗi 502 (Bỏ response_format và dùng Regex)
async def call_groq_vision(base64_image: str) -> Dict[str, Any]:
    client = get_groq_client()

    def _request() -> Dict[str, Any]:
        completion = client.chat.completions.create(
            model="meta-llama/llama-4-scout-17b-16e-instruct",
            messages=build_messages(base64_image),
            temperature=0.4,
            max_tokens=512,
            top_p=1,
            stream=False,
        )
        
        raw_content = completion.choices[0].message.content.strip()
        match = re.search(r'\{.*\}', raw_content, re.DOTALL)
        if match:
            raw_content = match.group(0)
            
        return json.loads(raw_content)

    try:
        return await run_in_threadpool(_request)
    except json.JSONDecodeError as exc:
        raise HTTPException(status_code=502, detail=f"Groq trả về kết quả không phải JSON hợp lệ: {exc}")
    except Exception as exc:
        print(f"Lỗi gọi Groq API: {exc}")
        raise HTTPException(status_code=502, detail=f"Groq lỗi: {exc}")

# Hàm này bị thiếu trong code của bạn gây ra lỗi NameError
async def process_image_upload(file: UploadFile) -> Dict[str, Any]:
    contents = await file.read()
    if not contents:
        raise HTTPException(status_code=400, detail="File ảnh rỗng.")
    base64_image = preprocess_image(contents)
    analysis = await call_groq_vision(base64_image)
    return {
        "status": "success",
        "data": analysis,
        "message": "Image analysis completed successfully",
    }

@health_router.get("")
async def health_check():
    return {"status": "ok"}

@vision_router.post("/analyze-image")
async def analyze_image(file: UploadFile = File(...)):
    return await process_image_upload(file)

@app.post("/analyze-image", include_in_schema=False)
async def analyze_image_legacy(file: UploadFile = File(...)):
    return await process_image_upload(file)

app.include_router(health_router)
app.include_router(vision_router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)