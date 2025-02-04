import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/utils/list_utils.dart';
import '../../../domain/entity/index.dart';

// class PreviewLandCertificateWidget extends StatefulWidget with ShowDialog {
//   const PreviewLandCertificateWidget({super.key, required this.landCertificate});
//
//   final LandCertificateEntity landCertificate;
//
//   @override
//   State<PreviewLandCertificateWidget> createState() => _PreviewLandCertificateWidgetState();
// }
//
// class _PreviewLandCertificateWidgetState extends State<PreviewLandCertificateWidget> {
//   LandCertificateEntity get landCertificate => widget.landCertificate;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {});
//   }
//
//   late Uint8List _imageFile;
//
//   //Create an instance of ScreenshotController
//   ScreenshotController screenshotController = ScreenshotController();
//
//   final GlobalKey key = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Chi tiết đất đai'),
//         backgroundColor: Colors.redAccent.withOpacity(0.8),
//       ),
//       extendBody: true,
//       body: FutureBuilder<LandCertificatePainter>(future: Future.sync(
//         () async {
//           final a = LandCertificatePainter(
//             filePaths: landCertificate.files
//                     ?.map(
//                       (AppFile e) => e.path,
//                     )
//                     .toList() ??
//                 [],
//           );
//           await a.loadImages();
//
//           return a;
//         },
//       ), builder: (
//         context,
//         s,
//       ) {
//         if (s.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         return RepaintBoundary(
//           key: key,
//           child: CustomPaint(
//             size: Size(500, double.infinity),
//             painter: s.data!,
//           ),
//         );
//       }),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: ColoredBox(
//           color: Colors.white,
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: 800,
//               minWidth: 500,
//             ),
//             child: Screenshot(
//               controller: screenshotController,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 shrinkWrap: true,
//                 children: [
//                   _buildSectionTitle('0. Tên/mô tả:', value: '${landCertificate.name ?? ''}'),
//                   _buildSectionTitle('1. Thửa đất:'),
//                   Row(
//                     children: [
//                       _buildDetailRow('a) Thửa đất số:', landCertificate.number?.toString() ?? ''),
//                       const SizedBox(width: 80),
//                       _buildDetailRow('Tờ bản đồ số:', landCertificate.mapNumber?.toString() ?? ''),
//                     ],
//                   ),
//                   _buildDetailRow(
//                     'b) Địa chỉ:',
//                     landCertificate.address?.displayAddress ?? '---',
//                   ),
//                   _buildDetailRow(
//                     'c) Diện tích:',
//                     '${landCertificate.area?.toStringAsFixed(0) ?? ''} m² (bằng chữ: )',
//                   ),
//                   _buildDetailRow('   Trong đó: Diện tích được cấp:', ''),
//                   _buildDetailRow('   Không được cấp:', ''),
//                   _buildDetailRow('d) Hình thức sử dụng:', landCertificate.useType ?? ''),
//                   _buildDetailRow(
//                     'e) Mục đích sử dụng:',
//                     landCertificate.purpose ?? '',
//                   ),
//                   _buildSectionTitle('2. Nhà ở:', value: '${landCertificate.residentialArea ?? ''}'),
//                   _buildSectionTitle('3. Công trình xây dựng khác:'),
//                   _buildSectionTitle('4. Rừng sản xuất là rừng trồng:'),
//                   _buildSectionTitle('5. Cây lâu năm:', value: '${landCertificate.perennialTreeArea ?? ''}'),
//                   _buildSectionTitle('6. Ghi chú:', value: '${landCertificate.note ?? ''}'),
//                   _buildSectionTitle('7. Thuế:'),
//                   _buildDetailRow(
//                     'f) Thời điểm gia hạn thuế:',
//                     landCertificate.taxRenewalTime?.date ?? '',
//                   ),
//                   _buildDetailRow(
//                     'g) Thời hạn đóng thuế:',
//                     landCertificate.taxDeadlineTime?.date ?? '',
//                   ),
//                   _buildSectionTitle('8. Giá mua:'),
//                   _buildDetailRow(
//                     'h) Ngày mua:',
//                     landCertificate.purchaseDate?.date ?? '',
//                   ),
//                   _buildDetailRow(
//                     'i) Giá mua:',
//                     landCertificate.purchasePrice?.toStringAsFixed(0) ?? '',
//                   ),
//                   _buildSectionTitle('9. Giá bán:'),
//                   _buildDetailRow(
//                     'j) Ngày bán:',
//                     landCertificate.saleDate?.date ?? '',
//                   ),
//                   _buildDetailRow(
//                     'k) Giá bán:',
//                     landCertificate.salePrice?.toStringAsFixed(0) ?? '',
//                   ),
//                   if (landCertificate.files.isNotNullAndEmpty) _buildSectionTitle('7. Ảnh:'),
//                   if (landCertificate.files.isNotNullAndEmpty)
//                     ...landCertificate.files!.map((file) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: AppImage.file(url: file.path),
//                       );
//                     }).toList(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           _renderAndShareImage();
//           // shareee();
//         },
//         child: const Icon(Icons.share),
//       ),
//     );
//   }
//
//
//   Widget _buildSectionTitle(String title, {String value = ''}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: RichText(
//         text: TextSpan(
//           text: title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//           children: [
//             TextSpan(
//               text: ' $value',
//               style: const TextStyle(
//                 fontWeight: FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
//       child: RichText(
//         text: TextSpan(
//           text: label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//           children: [
//             TextSpan(
//               text: ' $value',
//               style: const TextStyle(
//                 fontWeight: FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void shareee() async {
//     // try {
//     //   // Get the RenderObject of the ListView
//     //   RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
//     //
//     //   // Capture the image as an Image
//     //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     //
//     //   // Convert the image to bytes
//     //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     //   Uint8List pngBytes = byteData!.buffer.asUint8List();
//     //
//     //   // Save the image to a temporary directory
//     //   final directory = await getTemporaryDirectory();
//     //   final imagePath = '${directory.path}/long_list_view.png';
//     //   File imageFile = File(imagePath);
//     //   await imageFile.writeAsBytes(pngBytes);
//     //
//     //   // Get the position of the button for sharing
//     //   final RenderBox box = context.findRenderObject() as RenderBox;
//     //
//     //   // Share the file
//     //   await Share.shareXFiles(
//     //     [XFile(imagePath)],
//     //     text: 'Long ListView Screenshot',
//     //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
//     //   );
//     // } catch (e) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(content: Text('Error capturing ListView: $e')),
//     //   );
//     // }
//     //
//     // return;
//
//     try {
//       // Capture the image
//       _imageFile = (await screenshotController.capture())!;
//       // _imageFile = (await screenshotController.capture())!;
//       // _imageFile = (await screenshotController.captureFromLongWidget(key.currentWidget!))!;
//
//       // Save the file temporarily
//       final directory = await getTemporaryDirectory();
//       final imagePath = '${directory.path}/land_certificate.jpg';
//       final imageFile = File(imagePath);
//       await imageFile.writeAsBytes(_imageFile);
//
//       // Get the RenderBox of the FloatingActionButton
//       final RenderBox box = context.findRenderObject() as RenderBox;
//
//       // Share the file with position
//       await Share.shareXFiles(
//         [XFile(imagePath)],
//         text: 'Land Certificate Details',
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error capturing or sharing image: $e')),
//       );
//     }
//   }
// }
//
// void shareUrl(String text, BuildContext context) {
//   try {
//     Size size = MediaQuery.of(context).size;
//     double screenWidth = size.width;
//     double screenHeight = size.height;
//     Share.share(text, sharePositionOrigin: Rect.fromLTWH(0, 0, screenWidth, screenHeight));
//   } catch (e) {}
// }

class LandCertificatePainter extends CustomPainter {
  final LandCertificateEntity landCertificate;
  final double padding = 16.0; // Padding chung
  final double topPadding = 50.0; // Padding ở đầu trang

  LandCertificatePainter({required this.landCertificate});

  List<String> get filePaths => [];
  // List<String> get filePaths => landCertificate.files?.map((AppFile e) => e.path).toList() ?? [];

  List<ui.Image> images = [];

  Future<void> loadImages() async {
    images.clear();
    for (String path in filePaths) {
      try {
        final data = await File(path).readAsBytes();
        final codec = await ui.instantiateImageCodec(data);
        final frame = await codec.getNextFrame();
        images.add(frame.image);
      } catch (e) {
        print("Failed to load image: $path, Error: $e");
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double width = 500; // Fixed width
    double offsetY = topPadding; // Bắt đầu với padding ở đầu trang
    // Vẽ nền trắng
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final textStyle = TextStyle(fontSize: 16, color: Colors.black);
    final titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    void drawText(String text, TextStyle style, double x, double y) {
      textPainter.text = TextSpan(text: text, style: style);
      textPainter.layout(maxWidth: width);
      textPainter.paint(canvas, Offset(x, y));
    }

    void drawSectionTitle(String title, {String? value, double customPadding = 0.0}) {
      drawText(title, titleStyle, padding, offsetY);
      offsetY += 24 + customPadding; // Thêm khoảng cách sau tiêu đề
      if (value != null && value.isNotEmpty) {
        drawText(value, textStyle, padding + 20, offsetY);
        offsetY += 24 + padding; // Thêm padding sau giá trị
      }
    }

    void drawDetailRow(String label, String value, {double customPadding = 0.0}) {
      drawText(label, textStyle, padding, offsetY);
      drawText(value, textStyle, padding + 200, offsetY);
      offsetY += 24 + customPadding; // Thêm khoảng cách sau mỗi dòng
    }

    // Sử dụng dữ liệu `landCertificate` để vẽ
    drawSectionTitle('0. Tên/mô tả:', value: landCertificate.name ?? '');
    drawSectionTitle('1. Thửa đất:');
    drawDetailRow('a) Thửa đất số:', landCertificate.number?.toString() ?? '');
    drawDetailRow('   Tờ bản đồ số:', landCertificate.mapNumber?.toString() ?? '');
    drawDetailRow('b) Địa chỉ:', landCertificate.displayAddress ?? '---');
    drawDetailRow('c) Diện tích:', landCertificate.area?.toString() ?? '');
    drawDetailRow('   Trong đó: Diện tích được cấp:', '');
    drawDetailRow('   Không được cấp:', '');
    drawDetailRow('d) Hình thức sử dụng:', landCertificate.useType ?? '');
    drawDetailRow('e) Mục đích sử dụng:', landCertificate.purpose ?? '');
    drawSectionTitle('2. Nhà ở:', value: landCertificate.residentialArea ?? '');
    drawSectionTitle('3. Công trình xây dựng khác:');
    drawSectionTitle('4. Rừng sản xuất là rừng trồng:');
    drawSectionTitle('5. Cây lâu năm:', value: landCertificate.perennialTreeArea ?? '');
    drawSectionTitle('6. Ghi chú:', value: landCertificate.note ?? '');
    drawSectionTitle('7. Thuế:');
    drawDetailRow('f) Thời điểm gia hạn thuế:', landCertificate.taxRenewalTime?.date ?? '');
    drawDetailRow('g) Thời hạn đóng thuế:', landCertificate.taxDeadlineTime?.date ?? '');
    drawSectionTitle('8. Giá mua:');
    drawDetailRow('h) Ngày mua:', landCertificate.purchaseDate?.date ?? '');
    drawDetailRow('i) Giá mua:', landCertificate.purchasePrice?.toString() ?? '');
    drawSectionTitle('9. Giá bán:');
    drawDetailRow('j) Ngày bán:', landCertificate.saleDate?.date ?? '');
    drawDetailRow('k) Giá bán:', landCertificate.salePrice?.toString() ?? '');
    // Vẽ ảnh ở cuối nếu có
    if (images.isNotEmpty) {
      drawSectionTitle('10. Ảnh:', customPadding: padding);
      for (var image in images) {
        final paint = Paint();
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(padding, offsetY, width, width / image.width * image.height),
          paint,
        );
        offsetY += width / image.width * image.height + padding;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> renderAndShareImage(LandCertificateEntity landCertificate) async {
  final files = landCertificate.files ?? [];

  //file to xFile
  int index = 0;
  final xFiles = await mapListAsync(
    files,
    (p0) {
      return convertBase64ToXFile(p0, fileName: '${landCertificate.name}_${index++}.png');
    },
  );

  await Share.shareXFiles(xFiles, text: 'Sổ đỏ: ${landCertificate.name}');

  return;
  try {
    // Create PictureRecorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Define the size of the content
    final size = Size(500, 1500); // Fixed width, assumed height
    final painter = LandCertificatePainter(landCertificate: landCertificate);

    // Load images
    await painter.loadImages();

    // Paint the content
    painter.paint(canvas, size);

    // Convert to an image
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());

    // Convert image to ByteData
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      // Save the image to a file
      final buffer = byteData.buffer;
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/land_certificate_with_images.png';

      File file = File(filePath);
      await file.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      print("Image saved to: $filePath");

      // Share the image
      await Share.shareXFiles([XFile(filePath)], text: 'Here is the land certificate.');
    }
  } catch (e) {
    print("Error rendering and sharing image: $e");
  }
}
