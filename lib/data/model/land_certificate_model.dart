import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/index.dart';
import 'mapping_data.dart';

part 'land_certificate_model.g.dart';

@collection
class LandCertificateModel {
  Id id = Isar.autoIncrement;
  String? name;
  List<FileModel>? files;
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
    final ProvinceEntity? province = await _provinceRepository.getOneByName(input.province ?? '');
    final DistrictEntity? district = await _districtRepository.getOneByName(input.district ?? '');
    final WardEntity? ward = await _wardRepository.getOneByName(input.ward ?? '');

    return LandCertificateEntity(
      id: input.id,
      name: input.name ?? '',
      files: input.files?.map((e) => AttachmentModelToEntityMapping().from(e)).toList(),
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

class LandCertificateModelMapping extends Mapping<LandCertificateModel, LandCertificateEntity> {
  @override
  LandCertificateModel from(LandCertificateEntity item) {
    return LandCertificateModel()
      ..name = item.name
      ..files = item.files?.map((e) => AttachmentEntityToModelMapping().from(e)).toList()
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
