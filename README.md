# Bookfields - Ứng Dụng Đặt Sân Bóng

<p align="center">
  <img src="assets/logo.png" alt="Bookfields Logo" width="200"/>
</p>

## 📖 Giới thiệu

Bookfields là ứng dụng đặt sân bóng được phát triển bằng Flutter, giúp người dùng dễ dàng tìm kiếm, đặt và quản lý lịch đặt sân bóng. Ứng dụng cung cấp trải nghiệm mượt mà trên cả nền tảng Android và iOS, kết nối người chơi và các cơ sở sân bóng một cách hiệu quả.

## ✨ Tính năng

- **Tìm kiếm sân bóng**: Tìm kiếm sân bóng gần vị trí hiện tại hoặc khu vực mong muốn
- **Đặt sân trực tuyến**: Đặt sân nhanh chóng với các khung giờ linh hoạt
- **Thanh toán đa dạng**: Hỗ trợ nhiều phương thức thanh toán an toàn
- **Quản lý lịch đặt**: Theo dõi, chỉnh sửa hoặc hủy lịch đặt sân
- **Đánh giá và nhận xét**: Đánh giá chất lượng sân sau khi sử dụng
- **Tìm đồng đội**: Kết nối với người chơi khác để tổ chức trận đấu
- **Thông báo**: Nhận thông báo về lịch đặt sân và khuyến mãi

## 📱 Ảnh chụp màn hình

<p align="center">
  <img src="screenshots/home_screen.png" width="200" alt="Màn hình chính"/>
  <img src="screenshots/field_search.png" width="200" alt="Tìm kiếm sân"/>
  <img src="screenshots/field_details.png" width="200" alt="Chi tiết sân"/>
  <img src="screenshots/booking_calendar.png" width="200" alt="Lịch đặt sân"/>
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
- **Provider/Bloc**: Quản lý trạng thái
- **Firebase**: Xác thực, cơ sở dữ liệu và thông báo đẩy
- **Google Maps API**: Hiển thị bản đồ và vị trí sân bóng
- **Stripe/PayPal**: Tích hợp thanh toán
- **Dio/HTTP**: Gọi API đến máy chủ

## 📂 Cấu trúc dự án

```
lib/
├── api/                  # Lớp dịch vụ API và các hàm gọi mạng
├── models/               # Các lớp đối tượng dữ liệu
├── blocs/                # State management (Bloc pattern)
├── screens/              # Các màn hình ứng dụng
├── utils/                # Tiện ích và hàm trợ giúp
├── widgets/              # Widget tái sử dụng
├── theme/                # Chủ đề và styles
├── navigation/           # Điều hướng và routes
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

*Cập nhật lần cuối: 2025-03-25*
