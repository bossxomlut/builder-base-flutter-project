import '../../core/utils/parse_utils.dart';
import '../../data/repository/isar_repository.dart';

abstract class ProvinceUtil {
  static String combineId(int provinceId, int districtId, int wardId) {
    return [provinceId, districtId, wardId].join('_');
  }

  static String fullName(String provinceName, String districtName, String wardName) {
    return [provinceName, districtName, wardName].join(', ');
  }
}

class ProvinceEntity implements GetId<int> {
  ProvinceEntity({
    required this.id,
    required this.name,
  });

  factory ProvinceEntity.fromJson(Map<String, dynamic> json) {
    return ProvinceEntity(
      id: json.parseInt('id') ?? -1,
      name: json.parseString('name') ?? '',
    );
  }

  final int id;
  final String name;

  ProvinceEntity copyWith({
    int? id,
    String? name,
  }) {
    return ProvinceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  int? get getId => id;
}

class DistrictEntity implements GetId<int> {
  DistrictEntity({
    required this.id,
    required this.provinceId,
    required this.name,
  });

  factory DistrictEntity.fromJson(Map<String, dynamic> json) {
    return DistrictEntity(
      id: json.parseInt('id') ?? -1,
      provinceId: json.parseInt('province_id') ?? -1,
      name: json.parseString('name') ?? '',
    );
  }

  final int id;
  final int provinceId;
  final String name;

  DistrictEntity copyWith({
    int? id,
    int? provinceId,
    String? name,
  }) {
    return DistrictEntity(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      name: name ?? this.name,
    );
  }

  @override
  int? get getId => id;
}

class WardEntity implements GetId<int> {
  WardEntity({
    required this.id,
    required this.districtId,
    required this.name,
  });

  factory WardEntity.fromJson(Map<String, dynamic> json) {
    return WardEntity(
      id: json.parseInt('id') ?? -1,
      districtId: json.parseInt('district_id') ?? -1,
      name: json.parseString('name') ?? '',
    );
  }

  final int id;
  final int districtId;
  final String name;

  WardEntity copyWith({
    int? id,
    int? districtId,
    String? name,
  }) {
    return WardEntity(
      id: id ?? this.id,
      districtId: districtId ?? this.districtId,
      name: name ?? this.name,
    );
  }

  @override
  int? get getId => id;
}

class FlatProvinceEntity implements GetId<int> {
  FlatProvinceEntity({
    required this.id,
    required this.combineId,
    required this.fullName,
  });

  factory FlatProvinceEntity.combine(ProvinceEntity province, DistrictEntity district, WardEntity ward) {
    return FlatProvinceEntity(
      id: -1,
      combineId: ProvinceUtil.combineId(province.id, district.id, ward.id),
      fullName: ProvinceUtil.fullName(province.name, district.name, ward.name),
    );
  }

  final int id;
  final String combineId;
  final String fullName;

  @override
  int? get getId => id;
}

enum SearchFilterType {
  province,
  district,
  ward,
  combine,
}

class ProvinceSearchEntity {
  ProvinceSearchEntity({
    required this.name,
    required this.id,
    required this.type,
  });

  final String name;
  final String id;
  final SearchFilterType type;
}
