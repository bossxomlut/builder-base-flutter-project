import 'package:isar/isar.dart';

part 'province_model.g.dart';

@collection
class ProvinceModel {
  Id id = Isar.autoIncrement;
  String? name;
}

@collection
class DistrictModel {
  Id id = Isar.autoIncrement;
  int? provinceId;
  String? name;
}

@collection
class WardModel {
  Id id = Isar.autoIncrement;
  int? districtId;
  String? name;
}

@collection
class FlatProvinceModel {
  Id id = Isar.autoIncrement;
  String combineId = '';
  String fullName = '';
}
