# Sổ đỏ

### Cách build mã nguồn

**Bước 1: Cài đặt môi trường Flutter 3.24.4**

```
https://flutter-ko.dev/development/tools/sdk/releases
```
**Bước 2: Tải các thư viện**

```
flutter pub get 
```
**Bước 3: Sinh các mã tự động**

```
dart run build_runner build --delete-conflicting-outputs
```
**Bước 3: Xuất file apk*

```
flutter build apk --release
```
*Build xong thì cmd sẽ thông báo vị trí file được tạo

### Tính năng:
1. Đăng nhập bằng tài khoảnGoogle
2. Đăng nhập bằng mã bảo mật
   2.1. Thiết lập câu hỏi bảo mật
   2.2. Tạo
   2.3. Đổi mật khẩu
   2.3. Quên mật khẩu
   2.4. Hổ trợ lấy lại mật khẩu nếu quên câu hỏi bảo mật
3. Tìm kiếm thông tin Thành phố/Quận/Huyện/Xã
4. Quản lý sổ đỏ (Thêm, xem, xoá, sửa)
5. Chia sẽ ảnh sổ đỏ
6. Xem danh sách sổ đỏ
7. Tìm kiếm sổ đỏ
8. Cài đặt
   8.1. Ngôn ngữ
   8.2. Theme
   8.3. Đăng xuất
9. Đồng bộ dữ liệu lưu trữ lên  drive


### Cấu hình sử dụng Google Drive
1. Tạo tài khoản https://console.cloud.google.com/
2. Tạo project
3. Enable Google Api Service
4. Thêm tài gmail vào danh sách tester
5. Muốn cho tất cả mọi người đều  xài được
   5.1. Cần public project
