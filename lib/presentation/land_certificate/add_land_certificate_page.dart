import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/presentation/land_certificate/widget/other_area_widget.dart';

import '../../core/index.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../../widget/toast.dart';
import '../province/search_province_page.dart';
import '../setting/cubit/config_setting_cubit.dart';
import '../utils/index.dart';

@RoutePage()
class AddLandCertificatePage extends StatefulWidget {
  const AddLandCertificatePage({Key? key, this.initialLandCertificateEntity}) : super(key: key);

  final LandCertificateEntity? initialLandCertificateEntity;

  @override
  State<AddLandCertificatePage> createState() => _AddLandCertificatePageState();
}

class _AddLandCertificatePageState extends State<AddLandCertificatePage> with StateTemplate<AddLandCertificatePage> {
  LandCertificateEntity landCertificateEntity = LandCertificateEntity(id: -1);

  //helper to storage list of expand status
  List<bool> _expandList = [];

  final CreateLandCertificateUseCase _createLandCertificateUseCase = getIt.get<CreateLandCertificateUseCase>();

  bool get haveInitData => widget.initialLandCertificateEntity != null;

  final GlobalKey nameKey = GlobalKey();
  final GlobalKey addressKey = GlobalKey();
  final GlobalKey taxKey = GlobalKey();

  @override
  void initState() {
    if (haveInitData) {
      landCertificateEntity = widget.initialLandCertificateEntity!;
      _expandList = List.generate(landCertificateEntity.otherAreas?.length ?? 0, (index) => true);
    } else {
      final configCubit = getIt.get<ConfigSettingCubit>();
      landCertificateEntity = landCertificateEntity.copyWith(province: configCubit.defaultProvince);
    }
    super.initState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: haveInitData ? LKey.editLandCertificate.tr() : LKey.addLandCertificate.tr(),
    );
  }

  void _updateLandCertificateEntity({
    String? name,
    double? area,
    int? mapNumber,
    int? number,
    String? useType,
    String? purpose,
    double? residentialArea,
    double? perennialTreeArea,
    double? purchasePrice,
    DateTime? purchaseDate,
    double? salePrice,
    DateTime? saleDate,
    DateTime? taxRenewalTime,
    DateTime? taxDeadlineTime,
    String? note,
    List<String>? files,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
    String? detailAddress,
    DateTime? useTime,
  }) {
    landCertificateEntity = landCertificateEntity.copyWith2(
      name: name,
      area: area,
      mapNumber: mapNumber,
      number: number,
      useType: useType,
      purpose: purpose,
      residentialArea: residentialArea,
      perennialTreeArea: perennialTreeArea,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      salePrice: salePrice,
      saleDate: saleDate,
      taxRenewalTime: taxRenewalTime,
      taxDeadlineTime: taxDeadlineTime,
      note: note,
      files: files,
      province: province,
      district: district,
      ward: ward,
      detailAddress: detailAddress,
      useTime: useTime,
    );

    setState(() {});
  }

  void onSave() {
    bool isInvalid = landCertificateEntity.isInValid;

    if (isInvalid) {
      final Duration d = const Duration(milliseconds: 300);
      if (landCertificateEntity.name.isNullOrEmpty) {
        showError(message: 'Tên không được để trống');
        //scroll to this key

        try {
          Scrollable.ensureVisible(nameKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }

      if (landCertificateEntity.province == null && landCertificateEntity.detailAddress == null) {
        showError(message: 'Địa chỉ Thành phố hoặc địa chỉ cụ thể không được để trống');
        try {
          Scrollable.ensureVisible(addressKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }

      if (landCertificateEntity.taxRenewalTime == null) {
        showError(message: 'Thời điểm gia hạn đất không được để trống');
        try {
          Scrollable.ensureVisible(taxKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }

      if (landCertificateEntity.taxDeadlineTime == null) {
        showError(message: 'Thời hạn đóng thuế không được để trống');
        try {
          Scrollable.ensureVisible(taxKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }
    }

    //

    // _createLandCertificateUseCase.execute(landCertificateEntity);
    // return;
    ProcessingWidget(
      execute: () => Future.sync(() async {
        await Future.delayed(const Duration(seconds: 1));
        _createLandCertificateUseCase.execute(landCertificateEntity);
      }),
      onCompleted: () {
        Navigator.of(context).pop();
      },
      messageSuccessDescription: haveInitData
          ? LKey.messageEditLandCertificateSuccessfully.tr()
          : LKey.messageAddLandCertificateSuccessfully.tr(),
    ).show(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  AddCard(
                    key: nameKey,
                    title: LKey.sectionsLandInfo.tr(),
                    child: CustomTextField(
                      initialValue: landCertificateEntity.name,
                      isRequired: true,
                      label: LKey.fieldsNameDescription.tr(),
                      onChanged: (value) => _updateLandCertificateEntity(name: value),
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsLandCertificateImage.tr(),
                    child: Column(
                      children: [
                        UploadImagePlaceholder(
                          title: LKey.fieldsLandCertificateImageTitle.tr(),
                          onChanged: (appFiles) async {
                            if (appFiles != null) {
                              List<String> base64s = await mapListAsync(
                                appFiles!,
                                (p0) => convertImageToBase64(p0.path),
                              );

                              _updateLandCertificateEntity(files: [...?landCertificateEntity.files, ...base64s]);
                            }
                          },
                        ),
                        Gap(8),
                        if (landCertificateEntity.files.isNotNullAndEmpty)
                          ExpandMoreList<String>(
                            items: landCertificateEntity.files ?? [],
                            itemBuilder: (String file, int? index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showImages(context, landCertificateEntity.files ?? [], index ?? 0);
                                  },
                                  child: Base64ImagePlaceholder(
                                    key: ValueKey(file),
                                    data: file,
                                    onRemove: () {
                                      final List<String> list = [...?landCertificateEntity.files];
                                      list.remove(file);
                                      _updateLandCertificateEntity(files: list);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    key: addressKey,
                    title: LKey.sectionsAddress.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsProvinceCity.tr() + '*',
                          value: landCertificateEntity.province?.name,
                          onTap: () {
                            SearchProvincePage.searchProvince().show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                landCertificateEntity = landCertificateEntity.copyWith(
                                  province: value.province,
                                  district: null,
                                  ward: null,
                                );
                                setState(() {});
                              }
                            });
                          },
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsDistrict.tr(),
                          value: landCertificateEntity.district?.name,
                          isDisabled: landCertificateEntity.province == null,
                          onTap: () {
                            // Similar to province

                            SearchProvincePage.searchDistrict(
                              selectedProvince: landCertificateEntity.province,
                            ).show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                landCertificateEntity = landCertificateEntity.copyWith(
                                  district: value.district,
                                  ward: null,
                                );
                                setState(() {});
                              }
                            });
                          },
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsWard.tr(),
                          value: landCertificateEntity.ward?.name,
                          isDisabled: landCertificateEntity.district == null,
                          onTap: () {
                            // Similar to province
                            SearchProvincePage.searchWard(
                              selectedDistrict: landCertificateEntity.district,
                            ).show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                landCertificateEntity = landCertificateEntity.copyWith(
                                  ward: value.ward,
                                );
                                setState(() {});
                              }
                            });
                          },
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity?.detailAddress,
                          onChanged: (value) {
                            _updateLandCertificateEntity(detailAddress: value);
                          },
                          label: LKey.fieldsSpecificAddress.tr(),
                          isRequired: true,
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsPurchaseDetails.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsPurchaseDate.tr(),
                          value: landCertificateEntity.purchaseDate.date,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(purchaseDate: selectedDate);
                                }
                              },
                              initialDate: landCertificateEntity.purchaseDate,
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.purchasePrice?.inputFormat(),
                          onChanged: (value) => _updateLandCertificateEntity(purchasePrice: value),
                          label: LKey.fieldsPurchasePrice.tr(),
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsSaleDetails.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsSaleDate.tr(),
                          value: landCertificateEntity.saleDate.date,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(saleDate: selectedDate);
                                }
                              },
                              initialDate: landCertificateEntity.saleDate,
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.salePrice?.inputFormat(),
                          onChanged: (value) => _updateLandCertificateEntity(salePrice: value),
                          label: LKey.fieldsSalePrice.tr(),
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsLandPlot.tr(),
                    child: Column(
                      children: [
                        CustomTextField.number(
                          initialValue: landCertificateEntity.number?.inputFormat(),
                          onChanged: (value) => _updateLandCertificateEntity(number: value?.toInt()),
                          label: LKey.fieldsLandPlotNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.mapNumber?.inputFormat(),
                          onChanged: (value) => _updateLandCertificateEntity(mapNumber: value?.toInt()),
                          label: LKey.fieldsMapNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.area?.inputFormat(),
                          onChanged: (value) => _updateLandCertificateEntity(area: value),
                          label: LKey.fieldsAreaSize.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.useType,
                          onChanged: (value) => _updateLandCertificateEntity(useType: value),
                          label: LKey.fieldsUsageForm.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.purpose,
                          onChanged: (value) => _updateLandCertificateEntity(purpose: value),
                          label: LKey.fieldsUsagePurpose.tr(),
                        ),
                      ],
                    ),
                  ),
                  // Các phần khác tương tự...
                  Gap(16),

                  AddCard(
                    title: LKey.sectionsArea.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: 'Tổng diện tích',
                          value: landCertificateEntity.totalAllArea.displayFormat(),
                          onTap: () {},
                          showTrailingIcon: false,
                          isDisabled: true,
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.residentialArea?.inputFormat(),
                          onChanged: (value) {
                            landCertificateEntity = landCertificateEntity.copyWith(
                              residentialArea: value,
                            );
                            setState(() {});
                          },
                          label: LKey.fieldsResidentialLand.tr(),
                        ),
                        Gap(16),
                        CustomTextField.number(
                          initialValue: landCertificateEntity.perennialTreeArea?.inputFormat(),
                          onChanged: (value) {
                            landCertificateEntity = landCertificateEntity.copyWith(
                              perennialTreeArea: value,
                            );
                            setState(() {});
                          },
                          label: LKey.fieldsPerennialTrees.tr(),
                        ),
                        Gap(16),
                        ...?landCertificateEntity.otherAreas?.mapIndexed(
                          (index, area) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: OtherAreaWidget(
                                isExpanded: _expandList[index],
                                onExpand: (value) {
                                  _expandList[index] = value;
                                  // setState(() {});
                                },
                                areaEntity: area,
                                title: 'Khác ${index + 1}',
                                onChanged: (value) {
                                  final List<AreaEntity> list = [...?landCertificateEntity.otherAreas];

                                  list[index] = value;

                                  landCertificateEntity = landCertificateEntity.copyWith2(otherAreas: list);

                                  setState(() {});
                                },
                                onRemove: () {
                                  try {
                                    final List<AreaEntity> list = [...?landCertificateEntity.otherAreas];

                                    list.removeAt(index);
                                    _expandList.removeAt(index);

                                    landCertificateEntity = landCertificateEntity.copyWith2(otherAreas: list);
                                    setState(() {});
                                  } catch (e, st) {
                                    log(e.toString(), error: e, stackTrace: st);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        OutlinedButton(
                          onPressed: () {
                            landCertificateEntity = landCertificateEntity.copyWith2(
                              otherAreas: [...?landCertificateEntity.otherAreas, AreaEntity()],
                            );
                            _expandList.add(true);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: theme.colorScheme.primary,
                              ),
                              Gap(8),
                              Text(
                                'Khác',
                                style: context.appTheme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    key: taxKey,
                    title: LKey.sectionsTax.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsTaxRenewalTime.tr() + '*',
                          value: landCertificateEntity.taxRenewalTime.date,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(taxRenewalTime: selectedDate);
                                }
                              },
                              initialDate: landCertificateEntity.taxRenewalTime,
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsTaxPaymentDeadline.tr() + '*',
                          value: landCertificateEntity.taxDeadlineTime.date,
                          borderColor: landCertificateEntity.taxDeadlineTime != null
                              ? theme.getWarningByCountDate(landCertificateEntity.taxDeadlineTime.countToNow)
                              : null,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(taxDeadlineTime: selectedDate);
                                }
                              },
                              initialDate: landCertificateEntity.taxDeadlineTime,
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsNote.tr(),
                    child: Column(
                      children: [
                        CustomTextField(
                          initialValue: landCertificateEntity.note,
                          onChanged: (value) => _updateLandCertificateEntity(note: value),
                          label: LKey.fieldsDetails.tr(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FilledButton(
              onPressed: onSave,
              child: Text(LKey.actionsSave.tr()),
            ),
          ),
        ),
      ],
    );
  }
}

class AddCard extends StatelessWidget {
  const AddCard({
    super.key,
    required this.child,
    required this.title,
    this.titleWidget,
  });

  final Widget child;
  final String title;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleWidget ??
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
            const SizedBox(height: 16.0),
            child,
          ],
        ),
      ),
    );
  }
}
