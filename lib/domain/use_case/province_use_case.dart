import 'dart:developer';

import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../../core/persistence/simple_key_value_storage.dart';
import '../index.dart';

@injectable
class CheckInitialProvinceDataUseCase extends FutureUseCase<void, void> {
  CheckInitialProvinceDataUseCase(
    this._simpleStorage,
    this._provinceRepository,
    this._districtRepository,
    this._wardRepository,
    this._flatProvinceRepository,
  );

  final SimpleStorage _simpleStorage;
  final ProvinceRepository _provinceRepository;
  final DistrictRepository _districtRepository;
  final WardRepository _wardRepository;
  final FlatProvinceRepository _flatProvinceRepository;

  @override
  Future<void> execute(void input) async {
    final isInitialData = await _simpleStorage.getBool('is_initial_data');

    if (isInitialData == true) {
      return;
    }

    await _wardRepository.clearAll();
    await _districtRepository.clearAll();
    await _provinceRepository.clearAll();

    //load data from json file

    final provinceData = await loadListJsonFile('assets/vietnam-provinces.json');

    log('provinceData: $provinceData');

    for (final province in provinceData) {
      //create provice
      final provinceEntity = ProvinceEntity.fromJson(province as Map<String, dynamic>);
      final provinceStorage = await _provinceRepository.create(provinceEntity);

      //create districts
      final districts = province['districts'] as List<dynamic>;
      for (final district in districts) {
        final districtEntity = DistrictEntity.fromJson(district as Map<String, dynamic>).copyWith(
          provinceId: provinceStorage.id,
        );
        final districtStorage = await _districtRepository.create(districtEntity);

        //create wards
        final wards = district['wards'] as List<dynamic>;
        for (final ward in wards) {
          final wardEntity = WardEntity.fromJson(ward as Map<String, dynamic>).copyWith(
            districtId: districtStorage.id,
          );
          final wardStorage = await _wardRepository.create(wardEntity);
          await _flatProvinceRepository.create(
            FlatProvinceEntity.combine(provinceStorage, districtStorage, wardStorage),
          );
        }
      }

      log('province: $province');
    }

    //save to database

    _simpleStorage.saveBool('is_initial_data', true);
  }
}
