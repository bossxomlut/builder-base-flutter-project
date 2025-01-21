import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';

@injectable
class SearchProvinceCubit extends Cubit<SearchProvinceState> {
  SearchProvinceCubit(
    this._provinceRepository,
    this._districtRepository,
    this._wardRepository,
    this._flatProvinceRepository,
  ) : super(SearchProvinceState.initial());

  final ProvinceRepository _provinceRepository;
  final DistrictRepository _districtRepository;
  final WardRepository _wardRepository;
  final FlatProvinceRepository _flatProvinceRepository;

  void onSearch(String keyword) {
    switch (state.filterType) {
      case SearchFilterType.province:
        _provinceRepository.search(keyword).then((results) {
          emit(state.copyWith(
              results: results.map(
            (ProvinceEntity e) {
              return ProvinceSearchEntity(
                id: e.id.toString(),
                name: e.name,
                type: state.filterType,
              );
            },
          ).toList()));
        });
      case SearchFilterType.district:
        _districtRepository.search(keyword).then((results) {
          emit(state.copyWith(
              results: results.map(
            (DistrictEntity e) {
              return ProvinceSearchEntity(
                id: e.id.toString(),
                name: e.name,
                type: state.filterType,
              );
            },
          ).toList()));
        });
      case SearchFilterType.ward:
        _wardRepository.search(keyword).then((results) {
          emit(state.copyWith(
              results: results.map(
            (WardEntity e) {
              return ProvinceSearchEntity(
                id: e.id.toString(),
                name: e.name,
                type: state.filterType,
              );
            },
          ).toList()));
        });
      case SearchFilterType.combine:
        _flatProvinceRepository.search(keyword).then((results) {
          emit(state.copyWith(
              results: results.map(
            (FlatProvinceEntity e) {
              return ProvinceSearchEntity(
                id: e.id.toString(),
                name: e.fullName,
                type: state.filterType,
              );
            },
          ).toList()));
        });
    }
  }

  void onFilterChanged(SearchFilterType value) {
    emit(state.copyWith(filterType: value));
  }
}

class SearchProvinceState extends Equatable {
  SearchProvinceState({
    required this.results,
    this.filterType = SearchFilterType.province,
  });

  factory SearchProvinceState.initial() {
    return SearchProvinceState(results: []);
  }

  final List<ProvinceSearchEntity> results;
  final SearchFilterType filterType;

  @override
  List<Object?> get props => [
        results.hashCode,
        filterType,
      ];

  SearchProvinceState copyWith({
    List<ProvinceSearchEntity>? results,
    SearchFilterType? filterType,
  }) {
    return SearchProvinceState(
      results: results ?? this.results,
      filterType: filterType ?? this.filterType,
    );
  }
}
