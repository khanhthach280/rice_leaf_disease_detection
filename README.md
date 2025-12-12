# Ứng dụng Nhận diện Bệnh trên Lá Lúa

Ứng dụng Flutter sử dụng mô hình ONNX (Swin Transformer) để nhận diện và phân loại các loại bệnh trên lá lúa.

## Tính năng

- 📸 Chọn ảnh từ thư viện thiết bị
- 🤖 Phân tích và nhận diện bệnh trên lá lúa bằng mô hình AI
- 🎯 Hỗ trợ 5 loại phân loại:
  - `bacterial_leaf_blight` - Bệnh bạc lá vi khuẩn
  - `brown_spot` - Đốm nâu
  - `healthy` - Khỏe mạnh
  - `leaf_blast` - Bệnh đạo ôn
  - `narrow_brown_spot` - Đốm nâu hẹp

## Yêu cầu hệ thống

- Flutter SDK >= 3.7.0
- Dart SDK >= 3.7.0
- Android Studio / Xcode (tùy theo nền tảng)
- Thiết bị Android/iOS hoặc máy ảo để chạy ứng dụng

## Cài đặt

### 1. Clone repository

```bash
git clone <url-repository>
cd flutter_application_onnx
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Kiểm tra mô hình ONNX

Đảm bảo file mô hình đã có trong thư mục:
```
assets/models/swin_transformer_rice_leafs.onnx
```

Nếu chưa có, bạn cần thêm file mô hình vào thư mục `assets/models/`.

### 4. Chạy ứng dụng

#### Trên Android:
```bash
flutter run
```

#### Trên iOS:
```bash
flutter run
```

**Lưu ý:** Đối với iOS, bạn có thể cần chạy:
```bash
cd ios
pod install
cd ..
flutter run
```

## Cấu trúc dự án

```
flutter_application_onnx/
├── lib/
│   ├── main.dart              # File chính của ứng dụng
│   ├── onnx_service.dart     # Service xử lý ONNX model
│   └── image_processor.dart  # Xử lý và chuẩn hóa ảnh đầu vào
├── assets/
│   └── models/
│       └── swin_transformer_rice_leafs.onnx  # Mô hình ONNX
├── android/                   # Cấu hình Android
├── ios/                       # Cấu hình iOS
└── pubspec.yaml              # Dependencies và cấu hình Flutter
```

## Hướng dẫn sử dụng

1. **Khởi động ứng dụng**: Chạy ứng dụng trên thiết bị hoặc máy ảo
2. **Chọn ảnh**: Nhấn nút "Chọn ảnh" để chọn ảnh lá lúa từ thư viện
3. **Dự đoán**: Nhấn nút "Dự đoán bệnh" để phân tích ảnh
4. **Xem kết quả**: Kết quả phân loại sẽ hiển thị trên màn hình

## Dependencies chính

- `onnxruntime: ^1.4.1` - Runtime để chạy mô hình ONNX
- `image_picker: ^1.0.4` - Chọn ảnh từ thư viện thiết bị
- `image: ^4.1.3` - Xử lý và resize ảnh

## Xử lý ảnh

Ứng dụng sẽ tự động:
- Resize ảnh về kích thước 224x224 pixels
- Chuẩn hóa giá trị pixel về khoảng [-1, 1]
- Chuyển đổi từ định dạng RGB sang tensor đầu vào cho mô hình (CHW format)

## Troubleshooting

### Lỗi không tìm thấy mô hình
- Kiểm tra file `swin_transformer_rice_leafs.onnx` có trong thư mục `assets/models/`
- Đảm bảo `pubspec.yaml` đã khai báo asset:
  ```yaml
  assets:
    - assets/models/swin_transformer_rice_leafs.onnx
  ```
- Chạy lại `flutter pub get` và rebuild ứng dụng

### Lỗi permissions trên Android
Thêm quyền truy cập ảnh vào `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

### Lỗi permissions trên iOS
Thêm vào `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Cần quyền truy cập thư viện ảnh để chọn ảnh lá lúa</string>
```

### Lỗi build iOS
Nếu gặp lỗi với CocoaPods:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

## Phát triển thêm

### Thêm loại bệnh mới
Chỉnh sửa danh sách labels trong `lib/onnx_service.dart`:
```dart
List<String> labels = [
  'bacterial_leaf_blight',
  'brown_spot',
  'healthy',
  'leaf_blast',
  'narrow_brown_spot',
  // Thêm label mới ở đây
];
```

### Thay đổi mô hình
1. Thay thế file mô hình trong `assets/models/`
2. Cập nhật tên file trong `lib/onnx_service.dart` (dòng 14)
3. Điều chỉnh kích thước đầu vào nếu cần (hiện tại: [1, 3, 224, 224])

## Tác giả

Dự án được phát triển để hỗ trợ nông dân nhận diện bệnh trên lá lúa một cách nhanh chóng và chính xác.

## License

[Thêm thông tin license nếu có]

# Config model trên project
Tải model tại link: https://drive.google.com/file/d/1dZ1Z-98Kp-528lzQ9fitN6ab2tqYwVX2/view?usp=sharing
Đặt model trong thư mục 'assets/models' và chạy project sau đó