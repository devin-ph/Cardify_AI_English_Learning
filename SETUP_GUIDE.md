# Hướng dẫn cấu hình chi tiết - AI English Learning App

## Bước 1: Chuẩn bị môi trường

### Yêu cầu

- Windows 10/11
- Flutter SDK (đã cài)
- Android Studio
- Python 3.8+
- Groq API account

### Cài đặt Python packages

```bash
# Mở Command Prompt / PowerShell
cd e:\PTUD\app_btl

# Tạo virtual environment (tùy chọn)
python -m venv venv
venv\Scripts\activate

# Cài đặt dependencies
pip install fastapi uvicorn groq pillow python-multipart
```

## Bước 2: Cấu hình FastAPI Server

### 2.1 Lấy Groq API Key

1. Đi đến https://console.groq.com
2. Đăng nhập hoặc tạo tài khoản
3. Vào "API Keys" section
4. Tạo key mới
5. Copy API key

### 2.2 Cập nhật FastAPI.py

Mở `FastAPI.py` và tìm dòng:

```python
```

Thay bằng API key của bạn:

```python
client = Groq(api_key="gsk_YOUR_API_KEY_HERE")

### 2.3 Chạy FastAPI Server

```bash
# Chạy từ thư mục project
python FastAPI.py

# Hoặc dùng uvicorn
uvicorn FastAPI:app --host 0.0.0.0 --port 8000
```

**Output kỳ vọng:**

```
INFO:     Uvicorn running on http://0.0.0.0:8000
Press CTRL+C to quit
```

## Bước 3: Cấu hình Flutter App

### 3.1 Cài đặt dependencies

```bash
# Trong thư mục project
flutter pub get
```

### 3.2 Tham chiếu IP Server

Bạn cần biết IP của máy tính chạy FastAPI:

**Trên Windows:**

```cmd
ipconfig
```

Tìm dòng "IPv4 Address" (thường là 192.168.x.x)

### 3.3 Cập nhật main.dart

**Nếu chạy trên Android Emulator:**

```dart
// Dòng ~180 trong lib/main.dart
const String apiUrl = 'http://10.0.2.2:8000/analyze-image';
```

**Nếu chạy trên Physical Device:**

```dart
// Thay YOUR_IP bằng IP từ bước 3.2
const String apiUrl = 'http://YOUR_IP:8000/analyze-image';

// Ví dụ:
// const String apiUrl = 'http://192.168.1.100:8000/analyze-image';
```

## Bước 4: Chạy ứng dụng

### 4.1 Kết nối Android Device / Emulator

**Với Android Emulator:**

```bash
# Liệt kê available devices
flutter devices

# Chạy trên emulator
flutter run
```

**Với Physical Device:**

1. Bật Developer Mode trên phone (Tap build number 7 lần)
2. Bật USB Debugging
3. Kết nối USB
4. Cho phép quyền truy cập
5. Chạy:

```bash
flutter run
```

### 4.2 Cấp quyền

Khi ứng dụng khởi động lần đầu, nó sẽ yêu cầu:

- Camera permission
- Storage permission

Cấp tất cả quyền cần thiết

## Bước 5: Sử dụng ứng dụng

1. **Chụp ảnh**: Nhấn nút "Chụp ảnh" hoặc "Chọn từ thư viện"
2. **Ứng dụng sẽ**:
   - Resize ảnh tự động về 640x640
   - Nén ảnh (quality 85%)
   - Gửi tới FastAPI server
3. **Xem kết quả**:
   - Từ tiếng Anh
   - Phiên âm
   - Phát âm (nút volume)
   - Nghĩa Việt
   - Câu ví dụ
   - Hướng dẫn phát âm

## Troubleshooting

### ❌ Lỗi: "Connection refused"

**Nguyên nhân**: Server không chạy hoặc IP sai

```
Giải pháp:
1. Kiểm tra FastAPI server đang running
2. Kiểm tra IP trong main.dart
3. Nếu dùng emulator: thử 10.0.2.2
4. Nếu dùng physical device: ipconfig để lấy IP
5. Đảm bảo device và PC cùng WiFi
```

### ❌ Lỗi: "Permission denied"

**Nguyên nhân**: Chưa cấp quyền

```
Giải pháp:
1. Vào Settings → Apps → app_btl
2. Permissions → Camera: Allow
3. Permissions → Storage: Allow
```

### ❌ Lỗi: "Invalid API key"

**Nguyên nhân**: Groq API key sai hoặc hết hạn

```
Giải pháp:
1. Vào https://console.groq.com
2. Kiểm tra API key còn active
3. Tạo key mới nếu cần
4. Cập nhật lại FastAPI.py
5. Restart FastAPI server
```

### ❌ Lỗi: "Invalid JSON response"

**Nguyên nhân**: Groq API trả về lỗi

```
Giải pháp:
1. Kiểm tra Groq API key
2. Kiểm tra internet connection
3. Thử chụp ảnh khác (không quá phức tạp)
4. Kiểm tra logs của FastAPI
```

### ⏱️ Tốc độ chậm

**Nguyên nhân**: Ảnh quá lớn hoặc API chậm

```
Giải pháp:
1. Giảm kích thước ảnh: 512x512 thay 640x640 trong main.dart
2. Giảm quality: 70 thay 85
3. Đặt network gần (WiFi, không Mobile data)
```

## Network Configuration

### Firewall Windows

Nếu bật Firewall, cần allow Python:

1. Settings → Privacy & Security → Windows Defender Firewall
2. "Allow an app through firewall"
3. Tìm Python & tick "Private" networks

**Hoặc từ Admin PowerShell:**

```powershell
netsh advfirewall firewall add rule name="FastAPI" dir=in action=allow program="C:\Path\To\python.exe" enable=yes
```

### Network Testing

Test kết nối từ Flutter side:

```bash
# Check FastAPI là available
ping YOUR_IP
# hoặc
curl http://YOUR_IP:8000/docs
```

## Performance Tips

### Tối ưu Server

- Reduce max_tokens: 512 thay 1024
- Cách xử lý ảnh cùng lúc (queue)

### Tối ưu Client

- Hạ chất lượng ảnh: quality=70
- Hạ kích thước: 512x512
- Timeout hợp lý: 60s thay 30s

### Tối ưu Network

- Dùng WiFi (không 3G/4G)
- Gần router
- Không chặn port 8000

## Kiểm tra thành công

Nếu mọi thứ đúng, bạn sẽ thấy:

1. ✅ App khởi động bình thường
2. ✅ Camera/Gallery có thể mở
3. ✅ Ảnh được chụp/chọn
4. ✅ Thấy loading circle
5. ✅ Kết quả hiển thị trong 5-10 giây
6. ✅ Nút "Phát âm" đọc được từ

---

**Một số mệnh đề hay gặp:**

- Emulator vs Physical device: Physical device thường nhanh hơn
- WiFi connection: Cần cùng network với PC
- Python version: 3.8+ recommended
- API quota: Groq có rate limit miễn phí

---

Chúc bạn may mắn! 🚀
