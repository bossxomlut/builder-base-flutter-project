import 'package:equatable/equatable.dart';

import 'index.dart';

class SearchInformationEntity {
  SearchInformationEntity({
    required this.keyword,
    this.filter,
  });

  final String keyword;
  final FilterLandCertificateEntity? filter;
}

class ProvinceSearchInformationEntity extends SearchInformationEntity {
  ProvinceSearchInformationEntity({
    this.province,
    this.district,
    this.ward,
    required String keyword,
    FilterLandCertificateEntity? filter,
  }) : super(keyword: keyword, filter: filter);

  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;
}

class ProvinceCountEntity extends Equatable {
  ProvinceCountEntity({required this.id, required this.name, required this.total, required this.districts});

  final int id;
  final String name;
  final int total;
  final List<DistrictCountEntity> districts;

  @override
  List<Object?> get props => [
        id,
        name,
        total,
        districts.hashCode,
      ];
}

class DistrictCountEntity {
  DistrictCountEntity({required this.id, required this.name, required this.total});

  final int id;
  final String name;
  final int total;

  DistrictCountEntity copyWith({
    int? id,
    String? name,
    int? total,
  }) {
    return DistrictCountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
    );
  }
}
