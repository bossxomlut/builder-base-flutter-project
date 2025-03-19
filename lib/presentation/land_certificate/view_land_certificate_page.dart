import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../../domain/index.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../utils/index.dart';
import 'add_land_certificate_page.dart';

@RoutePage()
class ViewLandCertificatePage extends StatefulWidget {
  const ViewLandCertificatePage({Key? key, required this.initialLandCertificateEntity}) : super(key: key);

  final LandCertificateEntity initialLandCertificateEntity;

  @override
  State<ViewLandCertificatePage> createState() => _ViewLandCertificatePageState();
}

class _ViewLandCertificatePageState extends State<ViewLandCertificatePage> with StateTemplate<ViewLandCertificatePage> {
  LandCertificateEntity landCertificateEntity = LandCertificateEntity(id: -1);

  @override
  void initState() {
    super.initState();
    landCertificateEntity = widget.initialLandCertificateEntity!;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: LKey.viewLandCertificate.tr(),
    );
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
                    title: LKey.sectionsLandInfo.tr(),
                    child: CustomTextField(
                      initialValue: landCertificateEntity.name ?? nullPlaceHolder,
                      isReadOnly: true,
                      label: LKey.fieldsNameDescription.tr(),
                      onChanged: (String value) {},
                    ),
                  ),
                  if (landCertificateEntity.files.isNotNullAndEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AddCard(
                        title: LKey.sectionsLandCertificateImage.tr(),
                        child: SeeMoreList<String>(
                          items: landCertificateEntity.files ?? [],
                          itemBuilder: (String file, int? index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  showImages(context, landCertificateEntity.files ?? [], index ?? 0);
                                },
                                child: Base64ImagePlaceholder(
                                  data: file,
                                ),
                              ),
                            );
                          },
                          onSeeMore: () {
                            showImages(context, landCertificateEntity.files ?? [], 0);
                          },
                        ),
                      ),
                    ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsAddress.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsProvinceCity.tr(),
                          value: landCertificateEntity.province?.name,
                          onTap: () {},
                        ),
                        const Gap(16),
                        OutlineField(
                          label: LKey.fieldsDistrict.tr(),
                          value: landCertificateEntity.district?.name,
                          isDisabled: landCertificateEntity.province == null,
                          onTap: () {},
                        ),
                        const Gap(16),
                        OutlineField(
                          label: LKey.fieldsWard.tr(),
                          value: landCertificateEntity.ward?.name,
                          isDisabled: landCertificateEntity.district == null,
                          onTap: () {},
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          initialValue: landCertificateEntity.detailAddress ?? nullPlaceHolder,
                          onChanged: (value) {},
                          label: LKey.fieldsSpecificAddress.tr(),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsPurchaseDetails.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsPurchaseDate.tr(),
                          value: landCertificateEntity.purchaseDate.date,
                          onTap: () async {},
                          trailing: const Icon(Icons.calendar_today_outlined),
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsPurchasePrice.tr(),
                          initialValue: landCertificateEntity.purchasePrice?.displayFormat() ?? nullPlaceHolder,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsSaleDetails.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsSaleDate.tr(),
                          value: landCertificateEntity.saleDate.date,
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: () async {},
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsSalePrice.tr(),
                          initialValue: landCertificateEntity.salePrice?.displayFormat() ?? nullPlaceHolder,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsLandPlot.tr(),
                    child: Column(
                      children: [
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsLandPlotNumber.tr(),
                          initialValue: landCertificateEntity.number?.displayFormat() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsMapNumber.tr(),
                          initialValue: landCertificateEntity.mapNumber?.displayFormat() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsAreaSize.tr(),
                          initialValue: landCertificateEntity.area?.displayFormat() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsUsageForm.tr(),
                          initialValue: landCertificateEntity.useType ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsUsagePurpose.tr(),
                          initialValue: landCertificateEntity.purpose ?? nullPlaceHolder,
                        ),
                      ],
                    ),
                  ),
                  // Các phần khác tương tự...
                  const Gap(16),

                  AddCard(
                    title: LKey.sectionsArea.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: 'Tổng diện tích',
                          initialValue: landCertificateEntity.totalAllArea.displayFormat(),
                        ),
                        const Gap(16),
                        Text('Tổng: ${landCertificateEntity.totalArea.displayFormat()}',
                            style: theme.textTheme.titleMedium),
                        const Gap(10),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsResidentialLand.tr(),
                          initialValue: landCertificateEntity.residentialArea?.displayFormat() ?? nullPlaceHolder,
                        ),
                        const Gap(8),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsPerennialTrees.tr(),
                          initialValue: landCertificateEntity.perennialTreeArea?.displayFormat() ?? nullPlaceHolder,
                        ),
                        if (landCertificateEntity.otherAreas.isNotNullAndEmpty) ...[
                          const Gap(16),
                          Text(
                            'Diện tích khác',
                            style: theme.textTheme.titleMedium,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final otherArea = landCertificateEntity.otherAreas![index];
                              return Card(
                                color: theme.cardColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text('Khác ${index + 1}', style: theme.textTheme.titleMedium),
                                      const Gap(10),
                                      CustomTextField(
                                        isReadOnly: true,
                                        onChanged: (value) {},
                                        label: 'Loại đất',
                                        initialValue: otherArea.typeName ?? nullPlaceHolder,
                                      ),
                                      const Gap(8),
                                      CustomTextField(
                                        isReadOnly: true,
                                        onChanged: (value) {},
                                        label: 'Diện tích',
                                        initialValue: otherArea.area?.displayFormat() ?? nullPlaceHolder,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Gap(8),
                            itemCount: landCertificateEntity.otherAreas!.length,
                          ),
                        ]
                      ],
                    ),
                  ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsTax.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsTaxRenewalTime.tr(),
                          value: landCertificateEntity.taxRenewalTime.date,
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: () {},
                        ),
                        const Gap(16),
                        OutlineField(
                          label: LKey.fieldsTaxPaymentDeadline.tr(),
                          value: landCertificateEntity.taxDeadlineTime.date,
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: () {},
                          borderColor: landCertificateEntity.taxDeadlineTime != null
                              ? theme.getWarningByCountDate(landCertificateEntity.taxDeadlineTime.countToNow)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsNote.tr(),
                    child: Column(
                      children: [
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsDetails.tr(),
                          initialValue: landCertificateEntity.note ?? nullPlaceHolder,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        appRouter.goToEditLandCertificate(landCertificateEntity);
      },
      child: const Icon(LineIcons.edit),
    );
  }
}
