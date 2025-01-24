import 'package:flutter/material.dart';

import '../../core/index.dart';
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
    super.initState();
    if (haveInitData) {
      landCertificateEntity = widget.initialLandCertificateEntity!;
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: LKey.addLandCertificate.tr(),
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
    AddressEntity? address,
    List<AppFile>? files,
  }) {
    setState(() {
      landCertificateEntity = LandCertificateEntity(
        id: landCertificateEntity.id,
        name: name ?? landCertificateEntity.name,
        area: area ?? landCertificateEntity.area,
        mapNumber: mapNumber ?? landCertificateEntity.mapNumber,
        number: number ?? landCertificateEntity.number,
        useType: useType ?? landCertificateEntity.useType,
        purpose: purpose ?? landCertificateEntity.purpose,
        residentialArea: residentialArea ?? landCertificateEntity.residentialArea,
        perennialTreeArea: perennialTreeArea ?? landCertificateEntity.perennialTreeArea,
        purchasePrice: purchasePrice ?? landCertificateEntity.purchasePrice,
        purchaseDate: purchaseDate ?? landCertificateEntity.purchaseDate,
        salePrice: salePrice ?? landCertificateEntity.salePrice,
        saleDate: saleDate ?? landCertificateEntity.saleDate,
        taxRenewalTime: taxRenewalTime ?? landCertificateEntity.taxRenewalTime,
        taxDeadlineTime: taxDeadlineTime ?? landCertificateEntity.taxDeadlineTime,
        note: note ?? landCertificateEntity.note,
        address: address ?? landCertificateEntity.address, // Không thay đổi địa chỉ
        files: files ?? landCertificateEntity.files, // Không thay đổi files
      );
    });
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

      if (landCertificateEntity.address?.isInValid ?? true) {
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
                      onChanged: (value) => _updateLandCertificateEntity(name: value),
                      hint: LKey.fieldsNameDescription.tr(),
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: LKey.sectionsLandCertificateImage.tr(),
                    child: Column(
                      children: [
                        UploadImagePlaceholder(
                          title: LKey.fieldsLandCertificateImageTitle.tr(),
                          onChanged: (appFiles) {
                            if (appFiles != null) {
                              _updateLandCertificateEntity(files: [...?landCertificateEntity.files, ...appFiles]);
                            }
                          },
                        ),
                        Gap(8),
                        if (landCertificateEntity.files.isNotNullAndEmpty)
                          ...?landCertificateEntity.files?.map(
                            (file) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: UploadImagePlaceholder(
                                  title: file.name,
                                  filePath: file.path,
                                  onRemove: () {
                                    _updateLandCertificateEntity(files: landCertificateEntity.files?..remove(file));
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
                          value: landCertificateEntity.address?.province?.name,
                          onTap: () {
                            SearchProvincePage.searchProvince().show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                final currentAddress = landCertificateEntity.address ?? AddressEntity.empty();

                                if (currentAddress.province?.id == value.provinceId) {
                                  return;
                                }

                                final updatedAddress = AddressEntity.empty().copyWith(
                                  province: ProvinceEntity(
                                    id: value.provinceId,
                                    name: value.name,
                                  ),
                                );
                                _updateLandCertificateEntity(address: updatedAddress);
                              }
                            });
                          },
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsDistrict.tr(),
                          value: landCertificateEntity.address?.district?.name,
                          isDisabled: landCertificateEntity.address?.province == null,
                          onTap: () {
                            // Similar to province

                            SearchProvincePage.searchDistrict(
                              selectedProvince: landCertificateEntity.address?.province,
                            ).show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                final currentAddress = landCertificateEntity.address ?? AddressEntity.empty();

                                if (currentAddress.district?.id == value.districtId) {
                                  return;
                                }

                                final updatedAddress = AddressEntity.empty().copyWith(
                                  province: currentAddress.province,
                                  district: DistrictEntity(
                                    id: value.districtId,
                                    provinceId: value.provinceId,
                                    name: value.name,
                                  ),
                                  ward: null,
                                );
                                _updateLandCertificateEntity(address: updatedAddress);
                              }
                            });
                          },
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsWard.tr(),
                          value: landCertificateEntity.address?.ward?.name,
                          isDisabled: landCertificateEntity.address?.district == null,
                          onTap: () {
                            // Similar to province
                            SearchProvincePage.searchWard(
                              selectedDistrict: landCertificateEntity.address?.district,
                            ).show(context).then((value) {
                              // Update address if needed
                              if (value != null) {
                                final currentAddress = landCertificateEntity.address ?? AddressEntity.empty();

                                if (currentAddress.ward?.id == value.wardId) {
                                  return;
                                }

                                final updatedAddress = currentAddress.copyWith(
                                  ward: WardEntity(
                                    id: value.wardId,
                                    districtId: value.districtId,
                                    name: value.name,
                                  ),
                                );
                                _updateLandCertificateEntity(address: updatedAddress);
                              }
                            });
                          },
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (value) {
                            final currentAddress = landCertificateEntity.address;
                            final updatedAddress = AddressEntity(
                              province: currentAddress?.province,
                              district: currentAddress?.district,
                              ward: currentAddress?.ward,
                              detail: value,
                            );
                            _updateLandCertificateEntity(address: updatedAddress);
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
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _updateLandCertificateEntity(purchaseDate: selectedDate);
                            }
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField(
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
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _updateLandCertificateEntity(saleDate: selectedDate);
                            }
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        CustomTextField(
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
                          onChanged: (value) => _updateLandCertificateEntity(number: int.tryParse(value)),
                          hint: LKey.fieldsLandPlotNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (value) => _updateLandCertificateEntity(mapNumber: int.tryParse(value)),
                          hint: LKey.fieldsMapNumber.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (value) => _updateLandCertificateEntity(area: double.tryParse(value)),
                          hint: LKey.fieldsAreaSize.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (value) => _updateLandCertificateEntity(useType: value),
                          hint: LKey.fieldsUsageForm.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
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
                          onChanged: (value) => _updateLandCertificateEntity(residentialArea: value),
                          hint: LKey.fieldsResidentialLand.tr(),
                        ),
                        Gap(16),
                        CustomTextField(
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
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _updateLandCertificateEntity(taxRenewalTime: selectedDate);
                            }
                          },
                          trailing: Icon(Icons.calendar_today_outlined),
                        ),
                        Gap(16),
                        OutlineField(
                          label: LKey.fieldsTaxPaymentDeadline.tr(),
                          value: landCertificateEntity.taxDeadlineTime.date,
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _updateLandCertificateEntity(taxDeadlineTime: selectedDate);
                            }
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
