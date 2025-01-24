import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';

enum ProvinceLevel {
  province,
  district,
  ward,
  all,
}

@injectable
class LandCertificateListCubit extends Cubit<LandCertificateListState> {
  LandCertificateListCubit(
    this._landCertificateRepository,
    this._landCertificateObserverData,
  ) : super(LandCertificateListState.initial());

  final LandCertificateRepository _landCertificateRepository;

  final LandCertificateObserverData _landCertificateObserverData;

  void startListen() {
    _landCertificateObserverData.listener(
      (void value) {
        onSearch(state.keyword);
      },
    );
  }

  @override
  Future<void> close() {
    _landCertificateObserverData.cancelListen();
    return super.close();
  }

  void setLevel(
    ProvinceLevel level, {
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
  }) {
    emit(
      state.copyWith(
        level: level,
        province: province,
        district: district,
        ward: ward,
      ),
    );
  }

  void onSearch(String keyword) {
    emit(state.copyWith(keyword: keyword));
    try {
      switch (state.level) {
        case ProvinceLevel.province:
          _landCertificateRepository.searchByProvince(state.province!, keyword).then(_emitList);
        case ProvinceLevel.district:
          _landCertificateRepository.searchByDistrict(state.district!, keyword).then(_emitList);
        case ProvinceLevel.ward:
          _landCertificateRepository.searchByWard(state.ward!, keyword).then(_emitList);
        case ProvinceLevel.all:
          _landCertificateRepository.search(keyword).then(_emitList);
      }
    } catch (e) {
      log('error', error: e, stackTrace: StackTrace.current);
      _emitList([]);
    }
  }

  void _emitList(List<LandCertificateEntity> list) {
    emit(state.copyWith(list: list));
  }

  void remove(LandCertificateEntity item) {
    print('item: ${item}');

    _landCertificateRepository.delete(item);
  }
}

class LandCertificateListState extends Equatable {
  LandCertificateListState({
    required this.keyword,
    required this.level,
    required this.list,
    this.province,
    this.district,
    this.ward,
  });

  factory LandCertificateListState.initial() {
    return LandCertificateListState(
      keyword: '',
      level: ProvinceLevel.all,
      list: [],
    );
  }

  final String keyword;
  final ProvinceLevel level;
  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;
  final List<LandCertificateEntity> list;

  @override
  List<Object?> get props => [
        level,
        province,
        district,
        ward,
        list.hashCode,
      ];

  LandCertificateListState copyWith({
    String? keyword,
    ProvinceLevel? level,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    List<LandCertificateEntity>? list,
  }) {
    return LandCertificateListState(
      keyword: keyword ?? this.keyword,
      level: level ?? this.level,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      list: list ?? this.list,
    );
  }
}
