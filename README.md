# Bookfields Flutter

<p align="center">
  <img src="assets/logo.png" alt="Bookfields Logo" width="200"/>
</p>

## 📖 Giới thiệu

Bookfields là ứng dụng di động được phát triển bằng Flutter, giúp người dùng quản lý sách, khám phá tác phẩm mới và theo dõi quá trình đọc sách. Ứng dụng cung cấp trải nghiệm đọc sách liền mạch trên cả nền tảng Android và iOS.

## ✨ Tính năng

- **Quản lý thư viện sách**: Thêm, sắp xếp, và quản lý bộ sưu tập sách của bạn
- **Theo dõi tiến độ đọc**: Cập nhật tiến độ đọc và đặt mục tiêu
- **Khám phá sách mới**: Tìm kiếm và duyệt qua các đề xuất theo thể loại, tác giả
- **Đánh giá và ghi chú**: Thêm đánh giá và ghi chú cá nhân cho mỗi quyển sách
- **Đồng bộ đa thiết bị**: Đồng bộ hóa dữ liệu giữa các thiết bị
- **Chế độ ngoại tuyến**: Truy cập thông tin sách đã lưu ngay cả khi không có kết nối mạng

## 📱 Ảnh chụp màn hình

<p align="center">
  <img src="screenshots/home_screen.png" width="200" alt="Màn hình chính"/>
  <img src="screenshots/library_screen.png" width="200" alt="Thư viện"/>
  <img src="screenshots/book_details.png" width="200" alt="Chi tiết sách"/>
  <img src="screenshots/reading_progress.png" width="200" alt="Tiến độ đọc"/>
</p>

## 🚀 Bắt đầu

### Yêu cầu

- Flutter (phiên bản 3.0.0 trở lên)
- Dart (phiên bản 2.17.0 trở lên)
- Android Studio hoặc VS Code
- iOS Simulator hoặc thiết bị iOS thật (nếu phát triển cho iOS)
- Android Emulator hoặc thiết bị Android thật (nếu phát triển cho Android)

### Cài đặt

1. Clone repository này:
```bash
git clone https://github.com/quangzeros/bookfields-flutter.git
```

2. Di chuyển vào thư mục dự án:
```bash
cd bookfields-flutter
```

3. Cài đặt các dependencies:
```bash
flutter pub get
```

4. Chạy ứng dụng:
```bash
flutter run
```

## 🔧 Công nghệ sử dụng

- **Flutter**: Framework UI đa nền tảng
- **Dart**: Ngôn ngữ lập trình chính
- **Provider**: Quản lý trạng thái
- **Firebase**: Xác thực, cơ sở dữ liệu và lưu trữ
- **Hive**: Cơ sở dữ liệu cục bộ cho chế độ ngoại tuyến
- **Dio**: HTTP client cho việc gọi API

## 📂 Cấu trúc dự án

```
lib/
├── api/                  # Lớp dịch vụ API và các hàm gọi mạng
├── models/               # Các lớp đối tượng dữ liệu
├── providers/            # State management
├── screens/              # Các màn hình ứng dụng
├── utils/                # Tiện ích và hàm trợ giúp
├── widgets/              # Widget tái sử dụng
├── theme/                # Chủ đề và styles
├── routes.dart           # Định nghĩa điều hướng
└── main.dart             # Điểm khởi chạy ứng dụng
```

## 👥 Đóng góp

Các đóng góp luôn được hoan nghênh! Hãy theo các bước sau:

1. Fork dự án
2. Tạo nhánh cho tính năng mới (`git checkout -b feature/amazing-feature`)
3. Commit các thay đổi (`git commit -m 'Add some amazing feature'`)
4. Push lên nhánh của bạn (`git push origin feature/amazing-feature`)
5. Mở Pull Request

## 📄 Giấy phép

Dự án này được phân phối dưới Giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## 📞 Liên hệ

Quang Zero - [GitHub](https://github.com/quangzeros)

Link dự án: [https://github.com/quangzeros/bookfields-flutter](https://github.com/quangzeros/bookfields-flutter)
