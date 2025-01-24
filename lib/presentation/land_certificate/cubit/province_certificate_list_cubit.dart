import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';

/*
* Use for listing land certificates group by province
* */

@injectable
class ProvinceLandCertificateListCubit extends Cubit<CertificateListState> {
  ProvinceLandCertificateListCubit(
    this.certificateRepository,
    this._landCertificateObserverData,
  ) : super(CertificateListState.initial()) {
    startListen();
  }

  final ProvinceLandCertificateRepository certificateRepository;
  final LandCertificateObserverData _landCertificateObserverData;

  void startListen() {
    _landCertificateObserverData.listener(
      (void value) {
        onSearch('');
      },
    );
  }

  @override
  Future<void> close() {
    _landCertificateObserverData.cancelListen();
    return super.close();
  }

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
