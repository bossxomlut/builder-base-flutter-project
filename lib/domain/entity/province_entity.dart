import 'package:equatable/equatable.dart';

import '../../core/utils/parse_utils.dart';
import '../../data/repository/isar_repository.dart';

abstract class ProvinceUtil {
  static String combineId(int provinceId, int districtId, int wardId) {
    return [provinceId, districtId, wardId].join('_');
  }

  static String fullName(String provinceName, String districtName, String wardName) {
    return [provinceName, districtName, wardName].join(', ');
  }

  //[].length = 3;
  static List<int> getIds(String combineId) {
    //check pattern
    if (combineId.split('_').length != 3) {
      return [-1, -1, -1];
    }

    return combineId.split('_').map((String e) => e.parseInt() ?? -1).toList();
  }

  static List<String> getNames(String fullName) {
    //check pattern
    if (fullName.split(', ').length != 3) {
      return ['', '', ''];
    }
    return fullName.split(', ');
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

class DistrictEntity extends Equatable implements GetId<int> {
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

  @override
  String toString() {
    return 'DistrictEntity(id: $id, provinceId: $provinceId, name: $name)';
  }

  @override
  List<Object?> get props => [
        id,
        provinceId,
        name,
      ];
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

  int get provinceId {
    switch (type) {
      case SearchFilterType.district:
      case SearchFilterType.ward:
        return -1;
      case SearchFilterType.province:
        return id.parseInt() ?? -1;
      case SearchFilterType.combine:
        return ProvinceUtil.getIds(id).first;
    }
  }

  int get districtId {
    switch (type) {
      case SearchFilterType.ward:
      case SearchFilterType.province:
        return -1;
      case SearchFilterType.district:
        return id.parseInt() ?? -1;

      case SearchFilterType.combine:
        return ProvinceUtil.getIds(id).elementAt(1);
    }
  }

  int get wardId {
    switch (type) {
      case SearchFilterType.district:
      case SearchFilterType.province:
        return -1;
      case SearchFilterType.ward:
        return id.parseInt() ?? -1;
      case SearchFilterType.combine:
        return ProvinceUtil.getIds(id).last;
    }
  }

  ProvinceEntity get province => ProvinceEntity(id: provinceId, name: name);

  DistrictEntity get district => DistrictEntity(id: districtId, provinceId: provinceId, name: name);

  WardEntity get ward => WardEntity(id: wardId, districtId: districtId, name: name);
}
