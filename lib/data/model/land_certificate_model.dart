import 'package:isar/isar.dart';

import '../../domain/entity/index.dart';
import 'mapping_data.dart';

part 'land_certificate_model.g.dart';

@collection
class LandCertificateModel {
  Id id = Isar.autoIncrement;
  String? name;
  List<FileModel>? files;
  String? combineAddressId;
  String? combineAddressName;
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

class LandCertificateMapping extends Mapping<LandCertificateEntity, LandCertificateModel> {
  @override
  LandCertificateEntity from(LandCertificateModel input) {
    final combineId = input.combineAddressId;

    List<int> addressIds = ProvinceUtil.getIds(combineId ?? '');

    List<String> names = ProvinceUtil.getNames(input.combineAddressName ?? '');

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
      address: AddressEntity(
        province: ProvinceEntity(id: addressIds[0], name: names[0]),
        district: DistrictEntity(id: addressIds[1], provinceId: addressIds[0], name: names[1]),
        ward: WardEntity(id: addressIds[2], districtId: addressIds[1], name: names[2]),
        detail: input.detailAddress,
      ),
    );
  }
}

class LandCertificateModelMapping extends Mapping<LandCertificateModel, LandCertificateEntity> {
  @override
  LandCertificateModel from(LandCertificateEntity item) {
    return LandCertificateModel()
      ..name = item.name
      ..files = item.files?.map((e) => AttachmentEntityToModelMapping().from(e)).toList()
      ..combineAddressId = (item.address ?? AddressEntity.empty()).combineId
      ..combineAddressName = (item.address ?? AddressEntity.empty()).combineProvinceName
      ..detailAddress = item.address?.detail
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
