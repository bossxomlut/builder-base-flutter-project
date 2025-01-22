import '../../data/repository/isar_repository.dart';
import '../index.dart';

class LandCertificateEntity extends GetId<int> {
  LandCertificateEntity({
    required this.id,
    this.name,
    this.files,
    this.address,
    this.purchaseDate,
    this.purchasePrice,
    this.saleDate,
    this.salePrice,
    this.note,
    this.number,
    this.mapNumber,
    this.area,
    this.useType,
    this.purpose,
    this.useTime,
    this.residentialArea,
    this.perennialTreeArea,
    this.taxDeadlineTime,
    this.taxRenewalTime,
  });
  final int id;

  final String? name;
  final List? files;
  final AddressEntity? address;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final DateTime? saleDate;
  final double? salePrice;

  //Thửa đất số
  final int? number;

  //Bản đồ số
  final int? mapNumber;

  //Diện tích
  final double? area;

  //Hình thức sử dụng
  final String? useType;

  //Mục đích sử dụng
  final String? purpose;

  //Thời gian sử dụng
  final DateTime? useTime;

  //Đất ở
  final String? residentialArea;

  //Cây lâu năm
  final String? perennialTreeArea;

  //Thời điểm đóng thuế
  final DateTime? taxDeadlineTime;

  //Thời điểm gia hạn thuế
  final DateTime? taxRenewalTime;

  final String? note;

  @override
  int? get getId => id;
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
