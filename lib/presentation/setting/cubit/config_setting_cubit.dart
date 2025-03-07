import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/persistence/simple_key_value_storage.dart';
import '../../../domain/index.dart';
import '../../../widget/toast.dart';
import '../../utils/cubit_utils.dart';

@LazySingleton()
class ConfigSettingCubit extends Cubit<ConfigSettingState> with SafeEmit {
  ConfigSettingCubit(
    this._provinceRepository,
    this._simpleStorage,
  ) : super(ConfigSettingState());

  final ProvinceRepository _provinceRepository;
  final SimpleStorage _simpleStorage;

  static const String defaultProvinceName = 'Bình Dương';

  Future init() async {
    //get current storage name, if not => use defaultProvinceName
    final provinceName = (await _simpleStorage.getString(SimpleStorage.defaultProvinceName)) ?? defaultProvinceName;

    //search province by name
    final province = await _provinceRepository.getOneByName(provinceName);

    //update state
    emit(state.copyWith(defaultProvince: province));
  }

  void updateDefaultProvince(String provinceName) async {
    final province = await _provinceRepository.getOneByName(provinceName);

    //update state
    emit(state.copyWith(defaultProvince: province));

    //update storage
    await _simpleStorage.saveString(SimpleStorage.defaultProvinceName, provinceName);

    showSuccess(message: 'Đã cập nhật tỉnh thành mặc định');
  }

  ProvinceEntity? get defaultProvince => state.defaultProvince;
}

class ConfigSettingState extends Equatable {
  ConfigSettingState({this.defaultProvince});

  final ProvinceEntity? defaultProvince;

  @override
  List<Object?> get props => [defaultProvince];

  ConfigSettingState copyWith({
    ProvinceEntity? defaultProvince,
  }) {
    return ConfigSettingState(
      defaultProvince: defaultProvince ?? this.defaultProvince,
    );
  }
}
