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
      ..taxTime = item.taxTime
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
    return LandCertificateEntity(
      id: collection.id,
      name: collection.name ?? '',
    );
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<LandCertificateEntity>> search(String keyword) {
    return isar.writeTxn(() async {
      return collection.where().filter().nameContains(keyword).findAll().then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  LandCertificateModel updateNewItem(LandCertificateEntity item) {
    return createNewItem(item)..id = item.id;
  }
}
