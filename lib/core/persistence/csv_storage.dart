import 'dart:io';

import 'package:csv/csv.dart';

import '../utils/file_utils.dart';

/// Đọc dữ liệu từ file CSV và chuyển đổi thành List<List<dynamic>>
Future<List<List<dynamic>>> readCsvFile(String fileName) async {
  final path = await getFilePath(fileName);
  final file = File(path);

  // Nếu file không tồn tại, trả về danh sách chứa header (nếu có) hoặc danh sách rỗng
  if (!await file.exists()) {
    return [];
  }

  final contents = await file.readAsString();
  List<List<dynamic>> rows = const CsvToListConverter().convert(contents);
  return rows;
}

/// Ghi dữ liệu từ List<List<dynamic>> vào file CSV
Future<void> writeCsvFile(String fileName, List<List<dynamic>> rows) async {
  final path = await getFilePath(fileName);
  String csv = const ListToCsvConverter().convert(rows);
  final file = File(path);
  await file.writeAsString(csv);
}

/// Thêm một dòng dữ liệu mới vào cuối file CSV
Future<void> appendCsvRecord(String fileName, List<dynamic> newRecord, {required List<String> header}) async {
  // Đọc dữ liệu hiện có
  List<List<dynamic>> rows = await readCsvFile(fileName);

  // Nếu file không tồn tại hoặc rỗng, bạn có thể thêm header trước khi thêm dòng dữ liệu mới.
  // Ví dụ: nếu file chưa có header, ta có thể tạo header theo model của bạn
  if (rows.isEmpty) {
    rows.add(header);
  }

  // Thêm dòng dữ liệu mới vào cuối danh sách
  rows.add(newRecord);

  // Ghi lại toàn bộ dữ liệu vào file CSV
  await writeCsvFile(fileName, rows);
}
