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
                  const Gap(16),
                  // AddCard(
                  //   title: LKey.sectionsLandCertificateImage.tr(),
                  //   child: UploadImagePlaceholder(
                  //     title: LKey.fieldsLandCertificateImageTitle.tr(),
                  //     onChanged: (value) {
                  //       // Update files if necessary
                  //     },
                  //   ),
                  // ),
                  const Gap(16),
                  AddCard(
                    title: LKey.sectionsAddress.tr(),
                    child: Column(
                      children: [
                        OutlineField(
                          label: LKey.fieldsProvinceCity.tr(),
                          value: landCertificateEntity.address?.province?.name,
                          onTap: () {},
                        ),
                        const Gap(16),
                        OutlineField(
                          label: LKey.fieldsDistrict.tr(),
                          value: landCertificateEntity.address?.district?.name,
                          isDisabled: landCertificateEntity.address?.province == null,
                          onTap: () {},
                        ),
                        const Gap(16),
                        OutlineField(
                          label: LKey.fieldsWard.tr(),
                          value: landCertificateEntity.address?.ward?.name,
                          isDisabled: landCertificateEntity.address?.district == null,
                          onTap: () {},
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          initialValue: landCertificateEntity.address?.detail ?? nullPlaceHolder,
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
                          initialValue: landCertificateEntity.purchasePrice?.toString() ?? nullPlaceHolder,
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
                          initialValue: landCertificateEntity.salePrice?.toString() ?? nullPlaceHolder,
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
                          initialValue: landCertificateEntity.number?.toString() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsMapNumber.tr(),
                          initialValue: landCertificateEntity.mapNumber?.toString() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsAreaSize.tr(),
                          initialValue: landCertificateEntity.area?.toString() ?? nullPlaceHolder,
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
                      children: [
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsResidentialLand.tr(),
                          initialValue: landCertificateEntity.residentialArea?.toString() ?? nullPlaceHolder,
                        ),
                        const Gap(16),
                        CustomTextField(
                          isReadOnly: true,
                          onChanged: (value) {},
                          label: LKey.fieldsPerennialTrees.tr(),
                          initialValue: landCertificateEntity.perennialTreeArea?.toString() ?? nullPlaceHolder,
                        ),
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
