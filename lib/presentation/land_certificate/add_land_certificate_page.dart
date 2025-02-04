import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../../widget/toast.dart';
import '../province/search_province_page.dart';
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

  final CreateLandCertificateUseCase _createLandCertificateUseCase = getIt.get<CreateLandCertificateUseCase>();

  bool get haveInitData => widget.initialLandCertificateEntity != null;

  final GlobalKey nameKey = GlobalKey();
  final GlobalKey addressKey = GlobalKey();
  final GlobalKey taxKey = GlobalKey();

  @override
  void initState() {
    if (haveInitData) {
      landCertificateEntity = widget.initialLandCertificateEntity!;
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
    String? residentialArea,
    String? perennialTreeArea,
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

      if (landCertificateEntity.province == null || landCertificateEntity.detailAddress == null) {
        showError(message: 'Địa chỉ không được để trống');
        try {
          Scrollable.ensureVisible(addressKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }

      if (landCertificateEntity.taxDeadlineTime == null) {
        showError(message: 'Thời điểm đóng thuế không được để trống');
        try {
          Scrollable.ensureVisible(taxKey.currentContext!, duration: d);
        } catch (e) {}
        return;
      }

      return;
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
      messageSuccessDescription: LKey.messageAddLandCertificateSuccessfully.tr(),
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
                      hint: LKey.fieldsNameDescription.tr(),
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
                          ...?landCertificateEntity.files?.map(
                            (file) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Base64ImagePlaceholder(
                                  data: file,
                                  onRemove: () {
                                    // final List<AppFile> list = [...?landCertificateEntity.files];
                                    // list.remove(file);
                                    // _updateLandCertificateEntity(files: list);
                                  },
                                ),
                              );
                            },
                          )
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
                          label: LKey.fieldsProvinceCity.tr(),
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
                          hint: LKey.fieldsSpecificAddress.tr(),
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
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.purchasePrice?.toString(),
                          onChanged: (value) => _updateLandCertificateEntity(purchasePrice: double.tryParse(value)),
                          hint: LKey.fieldsPurchasePrice.tr(),
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
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.salePrice?.toString(),
                          onChanged: (value) => _updateLandCertificateEntity(salePrice: double.tryParse(value)),
                          hint: LKey.fieldsSalePrice.tr(),
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsLandPlot.tr(),
                    child: Column(
                      children: [
                        CustomTextField(
                          initialValue: landCertificateEntity.number?.toString(),
                          onChanged: (value) => _updateLandCertificateEntity(number: int.tryParse(value)),
                          hint: LKey.fieldsLandPlotNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.mapNumber?.toString(),
                          onChanged: (value) => _updateLandCertificateEntity(mapNumber: int.tryParse(value)),
                          hint: LKey.fieldsMapNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.area?.toString(),
                          onChanged: (value) => _updateLandCertificateEntity(area: double.tryParse(value)),
                          hint: LKey.fieldsAreaSize.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.useType,
                          onChanged: (value) => _updateLandCertificateEntity(useType: value),
                          hint: LKey.fieldsUsageForm.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.purpose,
                          onChanged: (value) => _updateLandCertificateEntity(purpose: value),
                          hint: LKey.fieldsUsagePurpose.tr(),
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
                        CustomTextField(
                          initialValue: landCertificateEntity.residentialArea,
                          onChanged: (value) => _updateLandCertificateEntity(residentialArea: value),
                          hint: LKey.fieldsResidentialLand.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          initialValue: landCertificateEntity.perennialTreeArea,
                          onChanged: (value) => _updateLandCertificateEntity(perennialTreeArea: value),
                          hint: LKey.fieldsPerennialTrees.tr(),
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
                          label: LKey.fieldsTaxRenewalTime.tr(),
                          value: landCertificateEntity.taxRenewalTime.date,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(taxRenewalTime: selectedDate);
                                }
                              },
                            );
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsTaxPaymentDeadline.tr(),
                          value: landCertificateEntity.taxDeadlineTime.date,
                          onTap: () async {
                            AppShowDatePicker(
                              context,
                              (selectedDate) {
                                if (selectedDate != null) {
                                  _updateLandCertificateEntity(taxDeadlineTime: selectedDate);
                                }
                              },
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
                          hint: LKey.fieldsDetails.tr(),
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

void AppShowDatePicker(BuildContext context, ValueChanged<DateTime?> onChanged) async {
  context.hideKeyboard();

  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  ).then(onChanged);
}
