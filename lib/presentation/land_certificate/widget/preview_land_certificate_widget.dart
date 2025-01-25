import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_app/widget/dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/list_utils.dart';
import '../../../domain/entity/index.dart';
import '../../../widget/image/image.dart';

class PreviewLandCertificateWidget extends StatefulWidget with ShowDialog {
  const PreviewLandCertificateWidget({super.key, required this.landCertificate});

  final LandCertificateEntity landCertificate;

  @override
  State<PreviewLandCertificateWidget> createState() => _PreviewLandCertificateWidgetState();
}

class _PreviewLandCertificateWidgetState extends State<PreviewLandCertificateWidget> {
  LandCertificateEntity get landCertificate => widget.landCertificate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  late Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết đất đai'),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildSectionTitle('0. Tên/mô tả:', value: '${landCertificate.name ?? ''}'),
                _buildSectionTitle('1. Thửa đất:'),
                Row(
                  children: [
                    _buildDetailRow('a) Thửa đất số:', landCertificate.number?.toString() ?? ''),
                    const SizedBox(width: 80),
                    _buildDetailRow('Tờ bản đồ số:', landCertificate.mapNumber?.toString() ?? ''),
                  ],
                ),
                _buildDetailRow(
                  'b) Địa chỉ:',
                  landCertificate.address?.displayAddress ?? '---',
                ),
                _buildDetailRow(
                  'c) Diện tích:',
                  '${landCertificate.area?.toStringAsFixed(0) ?? ''} m² (bằng chữ: )',
                ),
                _buildDetailRow('   Trong đó: Diện tích được cấp:', ''),
                _buildDetailRow('   Không được cấp:', ''),
                _buildDetailRow('d) Hình thức sử dụng:', landCertificate.useType ?? ''),
                _buildDetailRow(
                  'e) Mục đích sử dụng:',
                  landCertificate.purpose ?? '',
                ),
                // _buildDetailRow(
                //   'f) Thời hạn sử dụng:',
                //   'Đất ở: Lâu dài;\nĐất trồng cây lâu năm: sử dụng đến ngày 30/06/2049.',
                // ),
                // _buildDetailRow(
                //   'g) Nguồn gốc sử dụng:',
                //   'Nhận chuyển nhượng đất được công nhận QSDĐ như giao đất có thu tiền sử dụng đất 200,0m².\n'
                //       'Nhận chuyển nhượng đất được Công nhận QSDĐ như giao đất không thu tiền sử dụng đất 9255,7m².',
                // ),
                _buildSectionTitle('2. Nhà ở:', value: '${landCertificate.residentialArea ?? ''}'),
                _buildSectionTitle('3. Công trình xây dựng khác:'),
                _buildSectionTitle('4. Rừng sản xuất là rừng trồng:'),
                _buildSectionTitle('5. Cây lâu năm:', value: '${landCertificate.perennialTreeArea ?? ''}'),
                _buildSectionTitle('6. Ghi chú:', value: '${landCertificate.note ?? ''}'),
                _buildSectionTitle('7. Thuế:'),
                _buildDetailRow(
                  'f) Thời điểm gia hạn thuế:',
                  landCertificate.taxRenewalTime?.date ?? '',
                ),
                _buildDetailRow(
                  'g) Thời hạn đóng thuế:',
                  landCertificate.taxDeadlineTime?.date ?? '',
                ),
                _buildSectionTitle('8. Giá mua:'),
                _buildDetailRow(
                  'h) Ngày mua:',
                  landCertificate.purchaseDate?.date ?? '',
                ),
                _buildDetailRow(
                  'i) Giá mua:',
                  landCertificate.purchasePrice?.toStringAsFixed(0) ?? '',
                ),
                _buildSectionTitle('9. Giá bán:'),
                _buildDetailRow(
                  'j) Ngày bán:',
                  landCertificate.saleDate?.date ?? '',
                ),
                _buildDetailRow(
                  'k) Giá bán:',
                  landCertificate.salePrice?.toStringAsFixed(0) ?? '',
                ),
                if (landCertificate.files.isNotNullAndEmpty) _buildSectionTitle('7. Ảnh:'),
                if (landCertificate.files.isNotNullAndEmpty)
                  ...landCertificate.files!.map((file) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppImage.file(url: file.path),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          shareee();
        },
        child: const Icon(Icons.share),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String value = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: ' $value',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: ' $value',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareee() async {
    // try {
    //   // Get the RenderObject of the ListView
    //   RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //
    //   // Capture the image as an Image
    //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    //
    //   // Convert the image to bytes
    //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //   Uint8List pngBytes = byteData!.buffer.asUint8List();
    //
    //   // Save the image to a temporary directory
    //   final directory = await getTemporaryDirectory();
    //   final imagePath = '${directory.path}/long_list_view.png';
    //   File imageFile = File(imagePath);
    //   await imageFile.writeAsBytes(pngBytes);
    //
    //   // Get the position of the button for sharing
    //   final RenderBox box = context.findRenderObject() as RenderBox;
    //
    //   // Share the file
    //   await Share.shareXFiles(
    //     [XFile(imagePath)],
    //     text: 'Long ListView Screenshot',
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error capturing ListView: $e')),
    //   );
    // }
    //
    // return;

    try {
      // Capture the image
      _imageFile = (await screenshotController.capture())!;
      // _imageFile = (await screenshotController.capture())!;
      // _imageFile = (await screenshotController.captureFromLongWidget(key.currentWidget!))!;

      // Save the file temporarily
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/land_certificate.jpg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(_imageFile);

      // Get the RenderBox of the FloatingActionButton
      final RenderBox box = context.findRenderObject() as RenderBox;

      // Share the file with position
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Land Certificate Details',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing or sharing image: $e')),
      );
    }
  }
}

void shareUrl(String text, BuildContext context) {
  try {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    Share.share(text, sharePositionOrigin: Rect.fromLTWH(0, 0, screenWidth, screenHeight));
  } catch (e) {}
}
