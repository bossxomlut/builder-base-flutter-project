import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Hàm lấy đường dẫn đến thư mục lưu trữ tài liệu của ứng dụng.
Future<String> getFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  //print
  print('${directory.path}/$fileName');
  return '${directory.path}/$fileName';
}

/// Kiểm tra tồn tại file
Future<bool> checkFileExists(String fileName) async {
  final filePath = await getFilePath(fileName);
  final file = File(filePath);
  return await file.exists();
}

/// Tạo file
Future<File> createFile(String fileName) async {
  final filePath = await getFilePath(fileName);
  final file = File(filePath);
  return file.create();
}

/// 📌 Chuyển đổi ảnh thành chuỗi Base64
Future<String> convertImageToBase64(String imagePath) async {
  File imageFile = File(imagePath);

  if (!await imageFile.exists()) {
    throw Exception("⚠️ File không tồn tại!");
  }

  List<int> imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}

/// 📌 Chuyển đổi chuỗi Base64 thành file ảnh
Future<void> convertBase64ToImage(String base64String, String outputPath) async {
  List<int> imageBytes = base64Decode(base64String);
  File outputFile = File(outputPath);
  await outputFile.writeAsBytes(imageBytes);
}
