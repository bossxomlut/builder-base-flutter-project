import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/index.dart';
import '../model/land_certificate_model.dart';
import 'isar_repository.dart';

@Injectable(as: LandCertificateRepository)
class LandCertificateRepositoryImpl extends LandCertificateRepository
    with IsarCrudRepository<LandCertificateEntity, LandCertificateModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  IsarCollection<LandCertificateModel> get collection => _isar.landCertificateModels;

  @override
  LandCertificateModel createNewItem(LandCertificateEntity item) {
    return LandCertificateModel()
      ..name = item.name
      ..files = []
      ..combineAddressId = item.address?.combineId
      ..combineAddressName = item.address?.combineProvinceName
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

  @override
  Future<List<LandCertificateEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  LandCertificateEntity getItemFromCollection(LandCertificateModel collection) {
    final combineId = collection.combineAddressId;

    List<int> addressIds = ProvinceUtil.getIds(combineId ?? '');

    List<String> names = ProvinceUtil.getNames(collection.combineAddressName ?? '');

    return LandCertificateEntity(
      id: collection.id,
      name: collection.name ?? '',
      files: collection.files,
      mapNumber: collection.mapNumber,
      area: collection.area,
      useType: collection.useType,
      purpose: collection.purpose,
      useTime: collection.useTime,
      residentialArea: collection.residentialArea,
      perennialTreeArea: collection.perennialTreeArea,
      taxDeadlineTime: collection.taxDeadlineTime,
      taxRenewalTime: collection.taxRenewalTime,
      purchaseDate: collection.purchaseDate,
      purchasePrice: collection.purchasePrice,
      saleDate: collection.saleDate,
      salePrice: collection.salePrice,
      number: collection.number,
      note: collection.note,
      address: AddressEntity(
        province: ProvinceEntity(id: addressIds[0], name: names[0]),
        district: DistrictEntity(id: addressIds[1], provinceId: addressIds[0], name: names[1]),
        ward: WardEntity(id: addressIds[2], districtId: addressIds[1], name: names[2]),
        detail: collection.detailAddress,
      ),
    );
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<LandCertificateEntity>> search(String keyword) {
    return collection.where().filter().nameContains(keyword).findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
    // return isar.writeTxn(() async {
    //   return collection.where().filter().nameContains(keyword).findAll().then((collections) async {
    //     List<LandCertificateEntity> result = [];
    //
    //     for (var collection in collections) {
    //       final combineId = collection.combineAddressId;
    //
    //       List<int> addressIds = ProvinceUtil.getIds(combineId ?? '');
    //
    //       final province = await _provinceRepository.read(addressIds[0]);
    //       final district = await _districtRepository.read(addressIds[1]);
    //       final ward = await _wardRepository.read(addressIds[2]);
    //
    //       result.add(
    //         LandCertificateEntity(
    //           id: collection.id,
    //           name: collection.name ?? '',
    //           files: collection.files,
    //           mapNumber: collection.mapNumber,
    //           area: collection.area,
    //           useType: collection.useType,
    //           purpose: collection.purpose,
    //           useTime: collection.useTime,
    //           residentialArea: collection.residentialArea,
    //           perennialTreeArea: collection.perennialTreeArea,
    //           taxTime: collection.taxTime,
    //           taxRenewalTime: collection.taxRenewalTime,
    //           purchaseDate: collection.purchaseDate,
    //           purchasePrice: collection.purchasePrice,
    //           saleDate: collection.saleDate,
    //           salePrice: collection.salePrice,
    //           number: collection.number,
    //           note: collection.note,
    //           address: AddressEntity(
    //             province: province,
    //             district: district,
    //             ward: ward,
    //             detail: collection.detailAddress,
    //           ),
    //         ),
    //       );
    //     }
    //
    //     return result;
    //   });
    // });
  }

  @override
  LandCertificateModel updateNewItem(LandCertificateEntity item) {
    return createNewItem(item)..id = item.id;
  }
}
