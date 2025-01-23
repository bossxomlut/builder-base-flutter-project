class ProvinceCountEntity {
  ProvinceCountEntity({required this.id, required this.name, required this.total, required this.districts});

  final int id;
  final String name;
  final int total;
  final List<DistrictCountEntity> districts;
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
