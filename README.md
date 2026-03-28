# AI English Learning App - Object Detection

Ứng dụng Flutter học tiếng Anh thông qua nhận diện đồ vật bằng camera. Ứng dụng chụp ảnh, resize, gửi tới FastAPI server để phân tích, sau đó hiển thị:

- Từ tiếng Anh
- Phiên âm IPA
- Nghĩa tiếng Việt
- Câu ví dụ
- Hướng dẫn phát âm
- Tính năng phát âm (Text-to-Speech)

## Yêu cầu hệ thống

- Flutter SDK >= 3.11.1
- Android Studio / Xcode
- Python >= 3.8 (cho FastAPI server)
- FastAPI, Groq API key

## Cài đặt

### 1. Flutter Setup

```bash
# Cài đặt dependencies
flutter pub get

# Build APK
flutter build apk

# Hoặc chạy trực tiếp
flutter run
```

### 2. FastAPI Server Setup

```bash
# Cài đặt dependencies Python
pip install fastapi uvicorn groq pillow python-multipart

# Chạy server (Windows)
python FastAPI.py

# Hoặc sử dụng uvicorn trực tiếp
uvicorn FastAPI:app --host 0.0.0.0 --port 8000
```

### 3. Cấu hình API connection

**Trong `lib/main.dart` (dòng ~180):**

```dart
const String apiUrl = 'http://10.0.2.2:8000/analyze-image';  // Android Emulator
// hoặc
const String apiUrl = 'http://YOUR_COMPUTER_IP:8000/analyze-image';  // Physical device
```

**Ghi chú:**

- `10.0.2.2` là địa chỉ host khi chạy trên Android Emulator
- Với physical device, thay `YOUR_COMPUTER_IP` bằng IP của máy tính chạy FastAPI
- Ví dụ: `http://192.168.1.100:8000/analyze-image`

### 4. Groq API Key

Trong `FastAPI.py` (dòng ~11), thay API key của bạn:

```python
client = Groq(api_key="gsk_YOUR_API_KEY_HERE")
```

Lấy API key tại: https://console.groq.com

## Tính năng

### Chụp ảnh

- **Chụp ảnh**: Sử dụng camera thiết bị
- **Chọn từ thư viện**: Chọn ảnh từ gallery

### Xử lý ảnh

- Resize tự động về 640x640 pixel (hoặc 800x800)
- Nén chất lượng 85% để tối ưu tốc độ truyền tải
- Hỗ trợ định dạng JPEG

### Phân tích AI

- Sử dụng Llama 3.2 11B Vision từ Groq
- Nhượ diện đồ vật chính trong ảnh
- Trích xuất thông tin tương ứng

### Hiển thị kết quả

- Ảnh gốc đã được xử lý
- Từ tiếng Anh chính
- Phiên âm IPA
- Tính năng phát âm (TTS)
- Nghĩa tiếng Việt
- Loại từ (noun, verb, etc.)
- Câu ví dụ
- Hướng dẫn phát âm chi tiết

## Kiến trúc

```
┌─────────────────────┐
│   Flutter App       │
│  (main.dart)        │
└──────────┬──────────┘
           │ HTTP POST (MultipartForm)
           │ Image (640x640, JPEG)
           ▼
┌─────────────────────┐
│   FastAPI Server    │
│  (FastAPI.py)       │
│  - Image resize     │
│  - Groq API call    │
│  - JSON response    │
└──────────┬──────────┘
           │ JSON Response
           │ {word, phonetic, vietnamese_meaning, ...}
           ▼
┌─────────────────────┐
│   Groq LLM          │
│  (Llama 3.2 Vision) │
└─────────────────────┘
```

## API Endpoint

### POST `/analyze-image`

**Request:**

```
Content-Type: multipart/form-data
Body: file (image/jpeg)
```

**Response (200 OK):**

```json
{
  "status": "success",
  "data": {
    "word": "cat",
    "phonetic": "/kæt/",
    "vietnamese_meaning": "con mèo",
    "example_sentence": "I have a cute cat at home.",
    "pronunciation_guide": "Phát âm 'kæt' - độc âm 'k' + 'æ' (như trong 'bad') + 't'",
    "word_type": "noun"
  },
  "message": "Image analysis completed successfully"
}
```

## Permissions (Android)

Đã được cấu hình trong `android/app/src/main/AndroidManifest.xml`:

- `CAMERA`: Truy cập camera
- `READ_EXTERNAL_STORAGE`: Đọc gallery
- `WRITE_EXTERNAL_STORAGE`: Lưu ảnh tạm
- `INTERNET`: Kết nối API

## Troubleshooting

### Lỗi "Connection refused"

- Kiểm tra FastAPI server đang chạy
- Kiểm tra IP và port trong `main.dart`
- Đảm bảo device và máy tính trong cùng WiFi network

### Lỗi "Permission denied" (Camera)

- Cấp quyền camera trong settings Android
- Ứng dụng yêu cầu permission khi chạy lần đầu

### Lỗi "Invalid JSON response"

- Kiểm tra Groq API key có hiệu lực
- Kiểm tra internet connection

### Tốc độ chậm

- Giảm kích thước ảnh trong `main.dart`
- Tăng quality/speed của Groq model

## Cấu trúc dự án

```
app_btl/
├── lib/
│   └── main.dart          # Flutter UI & logic
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml
├── ios/                    # iOS platform
├── FastAPI.py              # Backend server
├── pubspec.yaml            # Flutter dependencies
└── README.md               # This file
```

## Dependencies

**Flutter:**

- `image_picker`: Chụp/chọn ảnh
- `image`: Resize ảnh
- `http`: HTTP requests
- `flutter_tts`: Text-to-Speech

**Python:**

- `fastapi`: Web framework
- `uvicorn`: ASGI server
- `groq`: Groq API client
- `pillow`: Image processing

## Phát triển tiếp theo

- [ ] Thêm history/bookmark từ vựng
- [ ] Lưu từ vựng vào local database
- [ ] Thêm quiz/practice mode
- [ ] Hỗ trợ nhiều ngôn ngữ khác
- [ ] Thêm pronunciation practice recorder
- [ ] Offline mode với cached data

## Liên hệ & Support

Nếu có vấn đề hoặc góp ý, vui lòng tạo issue hoặc liên hệ.

## License

MIT
