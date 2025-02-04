import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../core/index.dart';
import '../../domain/index.dart';
import 'mapping_data.dart';

part 'land_certificate_model.g.dart';

@collection
class LandCertificateModel {
  Id id = Isar.autoIncrement;
  String? cerId;
  String? name;
  List<String>? files;
  String? province;
  String? district;
  String? ward;
  String? detailAddress;
  DateTime? purchaseDate;
  double? purchasePrice;
  DateTime? saleDate;
  double? salePrice;

  //Thửa đất số
  int? number;

  //Bản đồ số
  int? mapNumber;

  //Diện tích
  double? area;

  //Hình thức sử dụng
  String? useType;

  //Mục đích sử dụng
  String? purpose;

  //Thời gian sử dụng
  DateTime? useTime;

  //Đất ở
  String? residentialArea;

  //Cây lâu năm
  String? perennialTreeArea;

  //Thời điểm đóng thuế
  DateTime? taxDeadlineTime;

  //Thời điểm gia hạn thuế
  DateTime? taxRenewalTime;

  String? note;

  //Thời điểm cập nhật
  DateTime? updatedAt;
}

@injectable
class LandCertificateMapping extends FutureMapping<LandCertificateEntity, LandCertificateModel> {
  LandCertificateMapping(
      {required ProvinceRepository provinceRepository,
      required DistrictRepository districtRepository,
      required WardRepository wardRepository})
      : _provinceRepository = provinceRepository,
        _districtRepository = districtRepository,
        _wardRepository = wardRepository;

  final ProvinceRepository _provinceRepository;
  final DistrictRepository _districtRepository;
  final WardRepository _wardRepository;

  @override
  Future<LandCertificateEntity> from(LandCertificateModel input) async {
    final ProvinceEntity? province =
        input.province.isNullOrEmpty ? null : await _provinceRepository.getOneByName(input.province ?? '');
    final DistrictEntity? district =
        input.district.isNullOrEmpty ? null : await _districtRepository.getOneByName(input.district ?? '');
    final WardEntity? ward = input.ward.isNullOrEmpty ? null : await _wardRepository.getOneByName(input.ward ?? '');

    return LandCertificateEntity(
      id: input.id,
      cerId: input.cerId,
      name: input.name ?? '',
      files: input.files,
      mapNumber: input.mapNumber,
      area: input.area,
      useType: input.useType,
      purpose: input.purpose,
      useTime: input.useTime,
      residentialArea: input.residentialArea,
      perennialTreeArea: input.perennialTreeArea,
      taxDeadlineTime: input.taxDeadlineTime,
      taxRenewalTime: input.taxRenewalTime,
      purchaseDate: input.purchaseDate,
      purchasePrice: input.purchasePrice,
      saleDate: input.saleDate,
      salePrice: input.salePrice,
      number: input.number,
      note: input.note,
      province: province,
      district: district,
      ward: ward,
      detailAddress: input.detailAddress,
    );
  }
}

@injectable
class LandCertificateModelMapping extends Mapping<LandCertificateModel, LandCertificateEntity> {
  @override
  LandCertificateModel from(LandCertificateEntity item) {
    return LandCertificateModel()
      ..cerId = item.cerId
      ..name = item.name
      ..files = item.files
      ..province = item.province?.name
      ..district = item.district?.name
      ..ward = item.ward?.name
      ..detailAddress = item.detailAddress
      ..purchaseDate = item.purchaseDate
      ..purchasePrice = item.purchasePrice
      ..saleDate = item.saleDate
      ..salePrice = item.salePrice
      ..number = item.number
      ..mapNumber = item.mapNumber
      ..area = item.area
      ..useType = item.useType
      ..purpose = item.purpose
      ..useTime = item.useTime
      ..residentialArea = item.residentialArea
      ..perennialTreeArea = item.perennialTreeArea
      ..taxDeadlineTime = item.taxDeadlineTime
      ..taxRenewalTime = item.taxRenewalTime
      ..note = item.note;
  }
}

@embedded
class FileModel {
  final String? path;
  final String? name;

  FileModel({
    this.path,
    this.name,
  });
}

class AttachmentEntityToModelMapping extends Mapping<FileModel, AppFile> {
  @override
  FileModel from(AppFile input) {
    return FileModel(path: input.path, name: input.name);
  }
}

class AttachmentModelToEntityMapping extends Mapping<AppFile, FileModel> {
  @override
  AppFile from(FileModel input) {
    return AppFile(path: input.path ?? '', name: input.name ?? '');
  }
}

@injectable
class MappingToRow extends Mapping<List<dynamic>, LandCertificateModel> {
  @override
  List from(LandCertificateModel input) {
    String combinedBase64 = (input.files ?? []).join("|||");
    return [
      input.cerId ?? '',
      input.name ?? '',
      input.province ?? '',
      input.district ?? '',
      input.ward ?? '',
      input.detailAddress ?? '',
      input.purchaseDate ?? '',
      input.purchasePrice ?? '',
      input.saleDate ?? '',
      input.salePrice ?? '',
      input.number ?? '',
      input.mapNumber ?? '',
      input.area ?? '',
      input.useType ?? '',
      input.purpose ?? '',
      input.useTime ?? '',
      input.residentialArea ?? '',
      input.perennialTreeArea ?? '',
      input.taxDeadlineTime ?? '',
      input.taxRenewalTime ?? '',
      input.note ?? '',
      combinedBase64,
      input.updatedAt ?? '',
    ];
  }
}

@injectable
class MappingRowToModel extends Mapping<LandCertificateModel, List<dynamic>> {
  @override
  LandCertificateModel from(List input) {
    final files = input[21].toString().isEmpty ? null : input[21]?.toString().split("|||");
    return LandCertificateModel()
      ..cerId = input[0]?.toString() ?? ''
      ..name = input[1]?.toString() ?? ''
      ..province = input[2]?.toString() ?? ''
      ..district = input[3]?.toString() ?? ''
      ..ward = input[4]?.toString() ?? ''
      ..detailAddress = input[5]?.toString() ?? ''
      ..purchaseDate = input[6]?.toString().parseDateTime() ?? DateTime(0)
      ..purchasePrice = input[7]?.toString().parseDouble() ?? 0.0
      ..saleDate = input[8]?.toString().parseDateTime() ?? DateTime(0)
      ..salePrice = input[9]?.toString().parseDouble() ?? 0.0
      ..number = input[10]?.toString().parseInt() ?? 0
      ..mapNumber = input[11]?.toString().parseInt() ?? 0
      ..area = input[12]?.toString().parseDouble() ?? 0.0
      ..useType = input[13]?.toString() ?? ''
      ..purpose = input[14]?.toString() ?? ''
      ..useTime = input[15]?.toString().parseDateTime() ?? DateTime(0)
      ..residentialArea = input[16]?.toString() ?? ''
      ..perennialTreeArea = input[17]?.toString() ?? ''
      ..taxDeadlineTime = input[18]?.toString().parseDateTime() ?? DateTime(0)
      ..taxRenewalTime = input[19]?.toString().parseDateTime() ?? DateTime(0)
      ..note = input[20]?.toString() ?? ''
      ..files = files
      ..updatedAt = input[22]?.toString().parseDateTime() ?? DateTime(0);
  }
}
