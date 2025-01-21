import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/model/province_model.dart';

@singleton
class IsarDatabase {
  @override
  Future initialize() {
    return Isar.initializeIsarCore().whenComplete(() {
      return getApplicationDocumentsDirectory().then(
        (dir) {
          return Isar.open(
            [
              ProvinceModelSchema,
              DistrictModelSchema,
              WardModelSchema,
            ],
            directory: dir.path,
          );
        },
      );
    });
  }
}
