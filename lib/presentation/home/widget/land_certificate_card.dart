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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pCertificates.name ?? '---',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                Text('${pCertificates.certificates?.length?.displayFormat() ?? 0} ${LKey.certificates.tr()}'),
              ],
            ),
            Gap(16.0),
            Column(
              children: [
                ...?SplitListUtils.splitList<LandCertificateEntity>(pCertificates.certificates ?? [])?.map(
                  (certificate) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: LandCertificateCard(certificate),
                  ),
                ),
              ],
            ),
            if ((pCertificates.certificates?.length ?? 0) > SplitListUtils.seeMoreCount)
              Align(
                alignment: Alignment.centerRight,
                child: SeeMoreWidget(
                  onTap: () {
                    appRouter.goToCertificateGroupByProvince(
                      ProvinceEntity(
                        id: pCertificates.id ?? -1,
                        name: pCertificates.name ?? '',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
