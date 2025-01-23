import 'package:flutter/material.dart';

import '../../../domain/entity/land_certificate_entity.dart';
import '../../../resource/index.dart';
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
                Text('${pCertificates.certificates?.length ?? 0} ${LKey.certificates.tr()}'),
              ],
            ),
            Gap(8.0),
            Column(
              children: [
                ...?pCertificates.certificates?.map(
                  (certificate) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: LandCertificateCard(certificate),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
