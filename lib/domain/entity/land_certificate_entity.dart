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
    String? residentialArea,
    String? perennialTreeArea,
    DateTime? taxDeadlineTime,
    DateTime? taxRenewalTime,
    String? note,
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
    String? residentialArea,
    String? perennialTreeArea,
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
    );
  }

  String get displayAddress {
    return detailAddress ?? ProvinceUtil.fullName(province?.name ?? '', district?.name ?? '', ward?.name ?? '');
  }
}

// class LandCertificateEntity implements GetId<int> {
//   LandCertificateEntity({
//     required this.id,
//     this.name,
//     this.files,
//     this.address,
//     this.purchaseDate,
//     this.purchasePrice,
//     this.saleDate,
//     this.salePrice,
//     this.note,
//     this.number,
//     this.mapNumber,
//     this.area,
//     this.useType,
//     this.purpose,
//     this.useTime,
//     this.residentialArea,
//     this.perennialTreeArea,
//     this.taxDeadlineTime,
//     this.taxRenewalTime,
//   });
//   final int id;
//
//   final String? name;
//   final List<AppFile>? files;
//   final AddressEntity? address;
//   final DateTime? purchaseDate;
//   final double? purchasePrice;
//   final DateTime? saleDate;
//   final double? salePrice;
//
//   //Thửa đất số
//   final int? number;
//
//   //Bản đồ số
//   final int? mapNumber;
//
//   //Diện tích
//   final double? area;
//
//   //Hình thức sử dụng
//   final String? useType;
//
//   //Mục đích sử dụng
//   final String? purpose;
//
//   //Thời gian sử dụng
//   final DateTime? useTime;
//
//   //Đất ở
//   final String? residentialArea;
//
//   //Cây lâu năm
//   final String? perennialTreeArea;
//
//   //Thời điểm đóng thuế
//   final DateTime? taxDeadlineTime;
//
//   //Thời điểm gia hạn thuế
//   final DateTime? taxRenewalTime;
//
//   final String? note;
//
//   @override
//   int? get getId => id;
//
//   // LandCertificateEntity copyWith({
//   //   int? id,
//   //   String? name,
//   //   List<AppFile>? files,
//   //   AddressEntity? address,
//   //   DateTime? purchaseDate,
//   //   double? purchasePrice,
//   //   DateTime? saleDate,
//   //   double? salePrice,
//   //   int? number,
//   //   int? mapNumber,
//   //   double? area,
//   //   String? useType,
//   //   String? purpose,
//   //   DateTime? useTime,
//   //   String? residentialArea,
//   //   String? perennialTreeArea,
//   //   DateTime? taxDeadlineTime,
//   //   DateTime? taxRenewalTime,
//   //   String? note,
//   // }) {
//   //   return LandCertificateEntity(
//   //     id: id ?? this.id,
//   //     name: name ?? this.name,
//   //     files: files ?? this.files,
//   //     address: address ?? this.address,
//   //     purchaseDate: purchaseDate ?? this.purchaseDate,
//   //     purchasePrice: purchasePrice ?? this.purchasePrice,
//   //     saleDate: saleDate ?? this.saleDate,
//   //     salePrice: salePrice ?? this.salePrice,
//   //     number: number ?? this.number,
//   //     mapNumber: mapNumber ?? this.mapNumber,
//   //     area: area ?? this.area,
//   //     useType: useType ?? this.useType,
//   //     purpose: purpose ?? this.purpose,
//   //     useTime: useTime ?? this.useTime,
//   //     residentialArea: residentialArea ?? this.residentialArea,
//   //     perennialTreeArea: perennialTreeArea ?? this.perennialTreeArea,
//   //     taxDeadlineTime: taxDeadlineTime ?? this.taxDeadlineTime,
//   //     taxRenewalTime: taxRenewalTime ?? this.taxRenewalTime,
//   //     note: note ?? this.note,
//   //   );
//   // }
//   //
//   // @override
//   // List<Object?> get props => [
//   //       id,
//   //       // name,
//   //       // files,
//   //       // address,
//   //       // purchaseDate,
//   //       // purchasePrice,
//   //       // saleDate,
//   //       // salePrice,
//   //       // number,
//   //       // mapNumber,
//   //       // area,
//   //       // useType,
//   //       // purpose,
//   //       // useTime,
//   //       // residentialArea,
//   //       // perennialTreeArea,
//   //       // taxDeadlineTime,
//   //       // taxRenewalTime,
//   //       // note,
//   //     ];
// }

extension LandCertificateEntityX on LandCertificateEntity {
  bool get isInValid => name == null || district == null || taxDeadlineTime == null || taxRenewalTime == null;
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
