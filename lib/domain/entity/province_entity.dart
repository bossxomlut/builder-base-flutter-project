class ProvinceEntity {
  final int id;
  final String name;

  ProvinceEntity({
    required this.id,
    required this.name,
  });
}

class DistrictEntity {
  final int id;
  final int provinceId;
  final String name;

  DistrictEntity({
    required this.id,
    required this.provinceId,
    required this.name,
  });
}

class WardEntity {
  final int id;
  final int districtId;
  final String name;

  WardEntity({
    required this.id,
    required this.districtId,
    required this.name,
  });
}
