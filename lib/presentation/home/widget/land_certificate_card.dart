import 'package:flutter/material.dart';

import '../../../domain/entity/land_certificate_entity.dart';
import '../../../widget/index.dart';

class ProvinceLandCertificateCard extends StatelessWidget {
  const ProvinceLandCertificateCard({super.key, required this.provinceLandCertificateEntity});

  final ProvinceLandCertificateEntity provinceLandCertificateEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(provinceLandCertificateEntity?.name ?? '---'),
        Gap(8.0),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return LandCertificateCard(certificate: provinceLandCertificateEntity.certificates![index]);
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
          itemCount: provinceLandCertificateEntity.certificates?.length ?? 0,
        ),
      ],
    );
  }
}

class LandCertificateCard extends StatelessWidget {
  const LandCertificateCard({super.key, required this.certificate});

  final LandCertificateEntity certificate;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
