import 'package:equatable/equatable.dart';

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
