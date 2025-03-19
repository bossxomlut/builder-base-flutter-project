import 'package:flutter/material.dart';

import '../../../core/index.dart';
import '../../../domain/index.dart';
import '../../../resource/index.dart';
import '../../../route/app_router.dart';
import '../../../widget/index.dart';
import 'preview_land_certificate_widget.dart';

class LandCertificateCard extends StatelessWidget {
  const LandCertificateCard(this.certificate, {super.key, this.backgroundColor});

  final LandCertificateEntity certificate;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return GestureDetector(
      onTap: () {
        appRouter.goToViewLandCertificate(certificate);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cerCardColor,
          border: Border.all(
            color: theme.cerCardBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          certificate.name ?? '---',
                          style: theme.cerNameStyle,
                        ),
                      ),
                      DeadlineDateStatusWidget(deadlineDate: certificate.taxDeadlineTime),
                    ],
                  ),
                  Gap(18.0),
                  Row(
                    children: [
                      Expanded(
                        child: InfoWidget(
                          title: LKey.fieldsPurchaseDate.tr(),
                          value: certificate.purchaseDate.date,
                        ),
                      ),
                      Expanded(
                        child: InfoWidget(
                          title: LKey.fieldsAreaSize.tr(),
                          value: (certificate.area?.displayFormat() ?? '---').toString(),
                        ),
                      ),
                    ],
                  ),
                  Gap(10.0),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InfoWidget(
                          title: LKey.fieldsPurchasePrice.tr(),
                          value: certificate.purchasePrice?.displayFormat() ?? '---',
                        ),
                      ),
                      Expanded(
                        child: InfoWidget(
                          title: LKey.fieldsSpecificAddress.tr(),
                          value: certificate?.displayAddress ?? '---',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (certificate.files.isNotNullAndEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6), // Bo góc tam giác
                  ),
                  child: GestureDetector(
                    onTap: () {
                      renderAndShareImage(
                        certificate,
                      );
                    },
                    child: CustomPaint(
                      size: Size(44, 44),
                      painter: TrianglePainter(color: theme.cerCardBorderColor),
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.topRight,
                        child: AppIcon(
                          IconPath.share,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // if (certificate.files.isNotNullAndEmpty)
            //   Positioned(
            //     right: 0,
            //     top: 0,
            //     child: GestureDetector(
            //       onTap: () {
            //         // PreviewLandCertificateWidget(landCertificate: certificate).show(context);
            //
            //         renderAndShareImage(
            //           certificate,
            //         );
            //       },
            //       child: Icon(
            //         LineIcons.alternateShare,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class GroupLandCertificateWidget extends StatefulWidget {
  const GroupLandCertificateWidget({super.key});

  @override
  State<GroupLandCertificateWidget> createState() => _GroupLandCertificateWidgetState();
}

class _GroupLandCertificateWidgetState extends State<GroupLandCertificateWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EmptyLandCertificateWidget extends StatelessWidget {
  const EmptyLandCertificateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(40.0),
          Icon(
            LineIcons.listUl,
            size: 100,
            color: theme.disabledColor,
          ),
          const Gap(10.0),
          LText(
            LKey.notFoundData,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.appTheme.cerTitleStyle,
        ),
        Text(
          value,
          style: context.appTheme.cerValueStyle,
        ),
      ],
    );
  }
}

class DeadlineDateStatusWidget extends StatelessWidget {
  const DeadlineDateStatusWidget({super.key, this.deadlineDate});

  final DateTime? deadlineDate;

  @override
  Widget build(BuildContext context) {
    if (deadlineDate == null) {
      return const SizedBox.shrink();
    }
    final theme = context.appTheme;
    final countDays = deadlineDate.countToNow;
    final isFuture = countDays > 0;

    if (countDays > 30) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.getWarningByCountDate(countDays),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AppIcon(IconPath.tax, width: 20, height: 20),
          Gap(4.0),
          Text(
            countDays == 0 ? "Hôm nay" : '${isFuture ? 'Còn' : "Trễ "}${countDays.abs()} ngày',
            style: theme.getWarningTextStyle(countDays),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0) // Góc trên bên phải
      ..lineTo(size.width, 0) // Góc trên cùng bên phải
      ..lineTo(size.width, size.height) // Góc dưới cùng bên phải
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
