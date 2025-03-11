import 'package:collection/collection.dart';

import '../../core/utils/string_utils.dart';
import '../../data/repository/isar_repository.dart';
import '../index.dart';

part 'land_certificate_entity.freezed.dart';

@freezed
class LandCertificateEntity with _$LandCertificateEntity implements GetId<int> {
  factory LandCertificateEntity({
    @Default(-1) int id,
    String? cerId,
    String? name,
    List<String>? files,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    String? detailAddress,
    DateTime? purchaseDate,
    double? purchasePrice,
    DateTime? saleDate,
    double? salePrice,
    int? number,
    int? mapNumber,
    double? area,
    String? useType,
    String? purpose,
    DateTime? useTime,
    double? residentialArea,
    double? perennialTreeArea,
    DateTime? taxDeadlineTime,
    DateTime? taxRenewalTime,
    String? note,
    List<AreaEntity>? otherAreas,
  }) = _LandCertificateEntity;

  const LandCertificateEntity._();

  @override
  int? get getId => id;

  LandCertificateEntity copyWith2({
    String? name,
    double? area,
    int? mapNumber,
    int? number,
    String? useType,
    String? purpose,
    double? residentialArea,
    double? perennialTreeArea,
    double? purchasePrice,
    DateTime? purchaseDate,
    double? salePrice,
    DateTime? saleDate,
    DateTime? useTime,
    DateTime? taxRenewalTime,
    DateTime? taxDeadlineTime,
    String? note,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    String? detailAddress,
    List<String>? files,
    List<AreaEntity>? otherAreas,
  }) {
    return LandCertificateEntity(
      id: id,
      cerId: cerId,
      name: name ?? this.name,
      files: files ?? this.files,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      detailAddress: detailAddress ?? this.detailAddress,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      saleDate: saleDate ?? this.saleDate,
      salePrice: salePrice ?? this.salePrice,
      number: number ?? this.number,
      mapNumber: mapNumber ?? this.mapNumber,
      area: area ?? this.area,
      useType: useType ?? this.useType,
      purpose: purpose ?? this.purpose,
      useTime: useTime ?? this.useTime,
      residentialArea: residentialArea ?? this.residentialArea,
      perennialTreeArea: perennialTreeArea ?? this.perennialTreeArea,
      taxDeadlineTime: taxDeadlineTime ?? this.taxDeadlineTime,
      taxRenewalTime: taxRenewalTime ?? this.taxRenewalTime,
      note: note ?? this.note,
      otherAreas: otherAreas ?? this.otherAreas,
    );
  }

  String get displayAddress {
    return detailAddress ?? ProvinceUtil.fullName(province?.name ?? '', district?.name ?? '', ward?.name ?? '');
  }

  double get totalArea {
    return (residentialArea ?? 0) + (perennialTreeArea ?? 0);
  }

  double get totalAllArea {
    return totalArea + (otherAreas?.map((e) => e.total).sum ?? 0);
  }
}

extension LandCertificateEntityX on LandCertificateEntity {
  bool get isInValid =>
      name == null || (province == null && detailAddress == null) || taxDeadlineTime == null || taxRenewalTime == null;
}

@freezed
class AreaEntity with _$AreaEntity {
  factory AreaEntity({
    String? typeName,
    double? area,
  }) = _AreaEntity;

  static AreaEntity? fromString(String value) {
    final values = value.split('_');
    try {
      return AreaEntity(
        typeName: values[0].isNotNullOrEmpty ? values[0] : null,
        area: double.tryParse(values[1]),
      );
    } catch (e) {
      return null;
    }
  }
}

extension AreaEntityX on AreaEntity {
  double get total => area ?? 0;

  String storageFormat() {
    return '${typeName ?? ''}_${area ?? 0}';
  }
}

class AddressEntity {
  AddressEntity({
    required this.province,
    required this.district,
    required this.ward,
    required this.detail,
  });

  factory AddressEntity.empty() {
    return AddressEntity(
      province: null,
      district: null,
      ward: null,
      detail: '',
    );
  }

  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;
  final String? detail;

  String get combineProvinceName => ProvinceUtil.fullName(province?.name ?? '', district?.name ?? '', ward?.name ?? '');

  String get combineId => ProvinceUtil.combineId(province?.id ?? -1, district?.id ?? -1, ward?.id ?? -1);

  String get displayAddress => (detail.isNotNullOrEmpty) ? detail! : combineProvinceName;

  AddressEntity copyWith({
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    String? detail,
  }) {
    return AddressEntity(
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      detail: detail ?? this.detail,
    );
  }
}

extension AddressEntityX on AddressEntity {
  bool get isInValid => province == null && detail == null;
}

class ProvinceLandCertificateEntity {
  ProvinceLandCertificateEntity({
    required this.id,
    required this.name,
    required this.certificates,
  });

  final int? id;
  final String? name;
  final List<LandCertificateEntity>? certificates;
}

class DistrictLandCertificateEntity {
  DistrictLandCertificateEntity({
    required this.id,
    required this.name,
    required this.certificates,
  });

  final int? id;
  final String? name;
  final List<LandCertificateEntity>? certificates;
}

class WardLandCertificateEntity {
  WardLandCertificateEntity({
    required this.id,
    required this.name,
    required this.certificates,
  });

  final int? id;
  final String? name;
  final List<LandCertificateEntity>? certificates;
}
