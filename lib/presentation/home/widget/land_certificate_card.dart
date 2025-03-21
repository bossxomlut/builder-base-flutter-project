import 'package:flutter/material.dart';

import '../../../core/index.dart';
import '../../../domain/index.dart';
import '../../../resource/index.dart';
import '../../../route/app_router.dart';
import '../../../widget/index.dart';
import '../../land_certificate/widget/land_certificate_card.dart';

class ProvinceLandCertificateCard extends StatelessWidget {
  const ProvinceLandCertificateCard({super.key, required this.pCertificates});

  final ProvinceLandCertificateEntity pCertificates;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Color(0xFFCCCCCC),
          width: 1.0,
          strokeAlign: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pCertificates.name.displayFormat,
                    style: theme.provinceStyle,
                  ),
                ),
                Text(
                  '${pCertificates.certificates?.length?.displayFormat() ?? 0} ${LKey.certificates.tr()}',
                  style: theme.totalCerStyle,
                ),
              ],
            ),
            Gap(16.0),
            SeeMoreList<LandCertificateEntity>(
              items: pCertificates.certificates ?? [],
              itemBuilder: (certificate, _) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: LandCertificateCard(certificate),
              ),
              onSeeMore: () {
                appRouter.goToCertificateGroupByProvince(
                  ProvinceEntity(
                    id: pCertificates.id ?? -1,
                    name: pCertificates.name ?? '',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
