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
