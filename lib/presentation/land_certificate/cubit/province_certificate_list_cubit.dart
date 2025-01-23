import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';

/*
* Use for listing land certificates group by province
* */

@injectable
class ProvinceLandCertificateListCubit extends Cubit<CertificateListState> {
  ProvinceLandCertificateListCubit({
    required this.certificateRepository,
  }) : super(CertificateListState.initial());

  final ProvinceLandCertificateRepository certificateRepository;

  void onSearch(String query) async {
    final list = await certificateRepository.search(query);
    emit(CertificateListState(list: list));
  }
}

class CertificateListState extends Equatable {
  CertificateListState({required this.list});

  factory CertificateListState.initial() {
    return CertificateListState(list: []);
  }

  final List<ProvinceLandCertificateEntity> list;

  @override
  List<Object?> get props => [list.hashCode];
}
