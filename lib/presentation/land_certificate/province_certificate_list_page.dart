import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/index.dart';
import '../home/widget/land_certificate_card.dart';
import '../utils/base_state.dart';
import 'cubit/province_certificate_list_cubit.dart';
import 'widget/land_certificate_card.dart';

class CertificateListPage extends StatefulWidget {
  const CertificateListPage({super.key});

  @override
  State<CertificateListPage> createState() => _CertificateListPageState();
}

class _CertificateListPageState
    extends BaseState<CertificateListPage, ProvinceLandCertificateListCubit, CertificateListState> {
  @override
  bool get isScaffold => false;

  @override
  void initState() {
    super.initState();
    cubit.onSearch('');
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<ProvinceLandCertificateListCubit, CertificateListState>(
      builder: (context, state) {
        // if (state.isLoading) {
        //   return const ListLandCertificateShimmer();
        // }

        if (state.list.isEmpty) {
          return EmptyLandCertificateWidget();
        }

        return ListView.separated(
          itemCount: state.list.length,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final provinceLandCertificateEntity = state.list[index];
            return ProvinceLandCertificateCard(
              pCertificates: provinceLandCertificateEntity,
            );
          },
        );
      },
    );
  }
}
