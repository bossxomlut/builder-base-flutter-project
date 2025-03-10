import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';
import '../../utils/cubit_utils.dart';

@injectable
class LandCertificateListCubit extends Cubit<LandCertificateListState> with SafeEmit<LandCertificateListState> {
  LandCertificateListCubit(
    this._searchUseCase,
    this._deleteUseCase,
    this._landCertificateObserverData,
  ) : super(LandCertificateListState.initial());

  final SearchLCByProvinceUseCase _searchUseCase;
  final DeleteLandCertificateUseCase _deleteUseCase;

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

  void init({
    String? keyword,
    FilterLandCertificateEntity? filter,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
  }) {
    emit(
      state.copyWith(
        keyword: keyword,
        filter: filter,
        province: province,
        district: district,
        ward: ward,
      ),
    );
  }

  void onSearch(String? keyword) {
    emit(state.copyWith(keyword: keyword));
    try {
      _searchUseCase
          .execute(ProvinceSearchInformationEntity(
            keyword: state.keyword,
            filter: state.filter,
            province: state.province,
            district: state.district,
            ward: state.ward,
          ))
          .then(_emitList);
    } catch (e) {
      log('error', error: e, stackTrace: StackTrace.current);
      _emitList([]);
    }
  }

  void _emitList(List<LandCertificateEntity> list) {
    emit(state.copyWith(list: list));
  }

  void remove(LandCertificateEntity item) {
    _deleteUseCase.execute(item);
  }
}

class LandCertificateListState extends Equatable {
  LandCertificateListState({
    required this.keyword,
    this.filter,
    required this.list,
    this.province,
    this.district,
    this.ward,
  });

  factory LandCertificateListState.initial() {
    return LandCertificateListState(
      keyword: '',
      list: [],
    );
  }

  final String keyword;
  final FilterLandCertificateEntity? filter;
  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;
  final List<LandCertificateEntity> list;

  @override
  List<Object?> get props => [
        keyword,
        filter,
        province,
        district,
        ward,
        list.hashCode,
      ];

  LandCertificateListState copyWith({
    String? keyword,
    FilterLandCertificateEntity? filter,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    List<LandCertificateEntity>? list,
  }) {
    return LandCertificateListState(
      keyword: keyword ?? this.keyword,
      filter: filter ?? this.filter,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      list: list ?? this.list,
    );
  }
}
