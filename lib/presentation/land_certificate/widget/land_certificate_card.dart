import 'package:flutter/material.dart';

import '../../../core/utils/date_time_utils.dart';
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
    return InkWell(
      onTap: () {
        appRouter.goToViewLandCertificate(certificate);
      },
      child: Card(
        margin: const EdgeInsets.all(0),
        borderOnForeground: false,
        elevation: 0,
        color: backgroundColor ?? theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      certificate.name ?? '---',
                      style: context.appTheme.textTheme.titleMedium,
                    ),
                  ),
                  DeadlineDateStatusWidget(deadlineDate: certificate.taxDeadlineTime),
                  IconButton(
                    onPressed: () {
                      // PreviewLandCertificateWidget(landCertificate: certificate).show(context);

                      renderAndShareImage(
                        certificate,
                      );
                    },
                    icon: Icon(
                      LineIcons.alternateShareSquare,
                      color: context.appTheme.colorScheme.tertiary,
                    ),
                  ),
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
                      value: (certificate.area ?? '---').toString(),
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
                      value: certificate.purchasePrice?.toString() ?? '---',
                    ),
                  ),
                  Expanded(
                    child: InfoWidget(
                      title: LKey.fieldsSpecificAddress.tr(),
                      value: certificate.address?.displayAddress ?? '---',
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          style: context.appTheme.textTheme.bodySmall,
        ),
        Text(
          value,
          style: context.appTheme.textTheme.bodyMedium,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.getWarningByCountDate(countDays),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        countDays == 0 ? "Hôm nay" : '${isFuture ? '' : "Trễ "}${countDays.abs()} ngày',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
