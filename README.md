<div align="center">
  
# 🌟 Cardify - AI English Learning App 🌟
**Ứng dụng học tiếng Anh thông minh tích hợp AI nhận diện vật thể qua Camera - Nhóm G3C3**


[![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase_Auth_&_Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Supabase](https://img.shields.io/badge/Supabase_PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
[![HuggingFace](https://img.shields.io/badge/AI_HuggingFace-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black)](https://huggingface.co/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

</div>

---

## 📖 1. Giới thiệu

**Vấn đề:** Việc học từ vựng tiếng Anh theo phương pháp ghi nhớ truyền thống  thường gây nhàm chán và khó áp dụng vào thực tế do thiếu đi ngữ cảnh trực quan xung quanh người học.

**Giải pháp - Cardify:** Luôn mang theo một gia sư AI bên mình. Cardify cho phép người dùng chỉ cần hướng Camera vào đồ vật thực tế xung quanh, AI sẽ tự động phân tích, định danh và tạo ra thẻ Flashcard 3D sinh động bao gồm: Từ vựng, Phiên âm IPA, Dịch nghĩa, Câu ví dụ và Phát âm bản xứ.

---

## ✨ 2. Các tính năng cốt lõi

- 📸 **Quét vật thể qua Camera**: Tự động bóc tách từ vựng tiếng Anh từ ảnh thực tế hoặc văn bản văn bản gốc.
- 🎙️ **Trợ lý AI**: Trợ lý ảo giao tiếp 1-1 bằng giọng nói thông qua sự hỗ trợ của STT (Speech-to-Text) và TTS (Text-to-Speech).
- 🎮 **Hệ thống Game hóa**: Tích lũy Điểm kinh nghiệm (XP), Chuỗi ngày học liên tục (Streak), và Danh hiệu cá nhân.
- 📚 **Tra cứu & Lưu trữ từ vựng**: Tìm từ vựng nhanh chóng và lưu trữ tức thời vào bộ sưu tập Flashcards cá nhân (Saved Cards).
- ⏰ **Nhắc nhở học tập**: Tự động nhắc nhở người dùng định kỳ theo thời gian đã đặt mà không cần Internet.

---

## 🛠 3. Công nghệ sử dụng

| Phân lớp | Công nghệ chính | Chi tiết chuyên môn |
| :--- | :--- | :--- |
| **Frontend** | 📱 **Flutter / Dart** | Sử dụng SDK `3.11.1+`, viết UI Cross-platform Material 3 cho Android và iOS. State Management dạng Native Stack logic. |
| **Backend & Auth**| 🔥 **Firebase** | Quản lý người dùng qua `firebase_auth` (Email, Google Sign-in). Xử lý dữ liệu thời gian thực. |
| **Database** | 🐘 **Supabase** | Sử dụng Relational Database (PostgreSQL) mạnh mẽ phục vụ kho Flashcards hàng triệu bản ghi và Storage lưu trữ ảnh. |
| **AI / Machine Learning**| 🤖 **HuggingFace API** | Tích hợp trực tiếp Endpoint Python/FastAPI trên HuggingFace Space để phân tích ảnh và trích xuất gợi ý từ vựng. | 

---

## 🗄️ 4. Mô hình Cơ sở Dữ liệu

Dự án áp dụng **Firebase và Supabase** nhằm tận dụng tối đa thế mạnh của từng nền tảng:

- **Firebase Firestore:**
  Lưu trữ dữ liệu truy xuất thời gian thực, có cấu trúc linh hoạt theo cấp bậc.
  - Phân quyền (Security Rules) bảo mật đa nền cho `users/{uid}`.
  - Ghi nhận nhanh các số liệu mượt mà (`xp`, `current_streak`, tiến trình thẻ `learning_state`).
- **Supabase:**
  Xử lý dữ liệu tra cứu phức tạp, cần Index và tốc độ xuất chuẩn dữ liệu bảng.
  - Bảng tập trung `saved_cards`: Chứa `[id, user_id, word, meaning, phonetic, part_of_speech...]`.
  - Có tính năng Realtime stream tương tự thông qua kết nối Websocket.

---

## 🏗️ 5. Kiến trúc Hệ thống

Hệ thống mã nguồn áp dụng chặt chẽ kiến trúc **Phân tầng logic**, giúp phần mềm dễ dàng mở rộng và bảo trì:

1. **UI Layer (`lib/screens`, `lib/widgets`):** Lớp hiển thị giao diện thuần (Widget Tree). Nhận và phản hồi sự kiện từ người dùng (Sử dụng `StatefulWidget`, `ValueNotifier`).
2. **Controller/Routing Layer (`main.dart`):** Điều phối và phân luồng trạng thái xác thực (`AuthGate`, kiểm tra xem người dùng tải dữ liệu đã Onboarding).
3. **Service & Repository Layer (`lib/services`):** Khối lượng công việc phức tạp nhất. Thực hiện đóng gói các quá trình đồng bộ đa luồng (`FirestoreSyncStatus`), đếm nhịp hẹn giờ thông báo (`ClassScheduleNotificationService`), gọi API AI (`VoiceChatService`).

---

## 🚀 6. Hướng dẫn Cài đặt

**Bước 1:** Clone repository về máy tính:
```bash
git clone https://github.com/your-repo/Cardify_AI_English_Learning.git
cd Cardify_AI_English_Learning
```

**Bước 2:** Cài đặt các gói thư viện phụ thuộc:
```bash
flutter pub get
```

**Bước 3:** Cấu hình Môi trường (Environment Setup):
1. Copy file `.env.example` thành `.env` nằm ở thư mục root dự án.
2. Cung cấp các Secret API Keys:
```env
HF_ANALYZE_ENDPOINT=https://your-analyze.hf.space/analyze-image
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_BUCKET=btl
SUPABASE_TABLE=saved_cards
```

**Bước 4:** Khởi chạy ứng dụng lên máy ảo hoặc thiết bị thực tế:
```bash
flutter run
```

---

## 📂 7. Cấu trúc Thư mục

```text
Cardify_AI_English_Learning/
├── android/                   # Native Android Build Gradle / Manifest
├── ios/                       # Native iOS Xcode workspace
├── assets/
│   ├── data/                  # File JSON/CSV mô phỏng kho từ vựng Offline
│   └── onboarding/            # Graphics, Hình ảnh giới thiệu App
├── lib/
│   ├── models/                # Khai báo Object Model cho Dữ liệu 
│   ├── screens/               # Màn hình chính (HomeScreen, DictionaryScreen,...)
│   ├── services/              # Lớp xử lý Logic / API (Supabase, Firebase, TTS, AI)
│   ├── widgets/               # Components dùng chung (BottomNav, Dialog AI, Avatar...)
│   ├── firebase_options.dart  # Config hệ thống Firebase
│   └── main.dart              # Entry Point: Chạy ứng dụng và định hướng Router
├── test/                      # Các tệp Unit Test và Widget Test
├── pubspec.yaml               # Trình quản lý Thư viện (Packages) & Versioning
└── README.md                  # Tài liệu Markdown dự án (File này)
```

---

## 👥 8. Thành viên

### Bảng Phân công nhiệm vụ
| Thành viên | Vai trò chính | Module / Màn hình phụ trách | Trạng thái |
| :--- | :--- | :--- | :---: |
| **Phạm Hoàng Thế Vinh**<br>*(Nhóm trưởng)* | Quản lý dự án, tổ chức tiến độ chung. | Màn hình Chính (Home Screen), Màn hình Thành tựu (Achievements Screen). | ✅ 100% |
| **Lê Tiến Minh** | Tích hợp Core AI, Voice Chatbot, Database (Supabase). | Màn hình Camera OCR, Dialog Trợ lý ảo (AI Chatbot), Màn hình Bộ sưu tập lưu thẻ (Saved Cards). | ✅ 100% |
| **Trần Quang Quân** | Thiết kế UI/UX toàn hệ thống (Figma), Tích hợp Firebase. | Luồng cấp phép & Màn hình Đăng nhập (Auth Screen), Tính năng Kết bạn. | ✅ 100% |
| **Đinh Phương Ly** | Phân tích và cấu trúc Dataset bộ từ vựng song ngữ. | Màn hình Ôn tập (Category), Không gian học qua Flashcards 3D. | ✅ 100% |
| **Phạm Ngọc Minh Nam** | Thiết kế bản thuyết trình (Slide presentation). | Màn hình Lịch học (Calendar), Màn hình Cài đặt (Settings) & Quản lý thông báo. | ✅ 100% |