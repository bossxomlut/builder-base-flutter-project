import 'package:flutter/material.dart';

import '../../../domain/index.dart';

class LandCertificateCard extends StatelessWidget {
  const LandCertificateCard({super.key, required this.landCertificate});

  final LandCertificateEntity landCertificate;

  @override
  Widget build(BuildContext context) {
    return Card();
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
