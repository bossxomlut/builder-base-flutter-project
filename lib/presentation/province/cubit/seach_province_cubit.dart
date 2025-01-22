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
        if (state.selectedDistrict != null) {
          _wardRepository.searchByDistrict(state.selectedDistrict!, keyword).then((results) {
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
        } else {
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
        }

      case SearchFilterType.ward:
        if (state.selectedDistrict != null) {
          _wardRepository.searchByDistrict(state.selectedDistrict!, keyword).then((results) {
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
        } else {
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
        }

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

  void onSetSelectedDistrict(DistrictEntity? selectedDistrict) {
    emit(state.copyWith(selectedDistrict: selectedDistrict));
  }

  void onSetSelectedProvince(ProvinceEntity? selectedProvince) {
    emit(state.copyWith(selectedProvince: selectedProvince));
  }
}

class SearchProvinceState extends Equatable {
  SearchProvinceState({
    required this.results,
    this.filterType = SearchFilterType.province,
    this.selectedProvince,
    this.selectedDistrict,
  });

  factory SearchProvinceState.initial() {
    return SearchProvinceState(results: []);
  }

  final List<ProvinceSearchEntity> results;
  final SearchFilterType filterType;
  final ProvinceEntity? selectedProvince;
  final DistrictEntity? selectedDistrict;

  @override
  List<Object?> get props => [
        results.hashCode,
        filterType,
        selectedProvince,
        selectedDistrict,
      ];

  SearchProvinceState copyWith({
    List<ProvinceSearchEntity>? results,
    SearchFilterType? filterType,
    ProvinceEntity? selectedProvince,
    DistrictEntity? selectedDistrict,
  }) {
    return SearchProvinceState(
      results: results ?? this.results,
      filterType: filterType ?? this.filterType,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
    );
  }
}
