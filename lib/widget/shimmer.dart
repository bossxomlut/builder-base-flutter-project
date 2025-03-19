import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LandCertificateShimmer extends StatelessWidget {
  const LandCertificateShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.cardColor,
      highlightColor: theme.highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 200,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class ListLandCertificateShimmer extends StatelessWidget {
  const ListLandCertificateShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return const LandCertificateShimmer();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
