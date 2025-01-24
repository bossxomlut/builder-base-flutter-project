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
  LandCertificateListCubit(this._landCertificateRepository) : super(LandCertificateListState.initial()) {}

  final LandCertificateRepository _landCertificateRepository;

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

  void search(String keyword) {
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
    _landCertificateRepository.delete(item);
  }
}

class LandCertificateListState extends Equatable {
  LandCertificateListState({
    required this.level,
    required this.list,
    this.province,
    this.district,
    this.ward,
  });

  factory LandCertificateListState.initial() {
    return LandCertificateListState(
      level: ProvinceLevel.all,
      list: [],
    );
  }

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
    ProvinceLevel? level,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    List<LandCertificateEntity>? list,
  }) {
    return LandCertificateListState(
      level: level ?? this.level,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      list: list ?? this.list,
    );
  }
}
