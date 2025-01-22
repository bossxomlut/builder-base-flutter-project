import 'package:flutter/material.dart';

import '../../domain/entity/land_certificate_entity.dart';
import '../../domain/use_case/land_certificate_use_case.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../widget/image/image_place_holder.dart';
import '../../widget/index.dart';
import '../province/search_province_page.dart';
import '../utils/index.dart';

@RoutePage()
class AddLandCertificatePage extends StatefulWidget {
  const AddLandCertificatePage({Key? key}) : super(key: key);

  @override
  State<AddLandCertificatePage> createState() => _AddLandCertificatePageState();
}

class _AddLandCertificatePageState extends State<AddLandCertificatePage> with StateTemplate<AddLandCertificatePage> {
  LandCertificateEntity landCertificateEntity = LandCertificateEntity(id: -1);

  final CreateLandCertificateUseCase _createLandCertificateUseCase = getIt.get<CreateLandCertificateUseCase>();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(title: 'Thêm mảnh đất');
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
                    title: 'Thông tin đất',
                    child: CustomTextField(
                      onChanged: (String value) {},
                      hint: 'Tên/mô tả',
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Hình ảnh sổ đỏ',
                    child: UploadImagePlaceholder(
                      title: 'Hình ảnh sổ đỏ',
                      onChanged: (String? value) {},
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Địa chỉ',
                    child: Column(
                      children: [
                        OutlineField(
                          label: 'Tỉnh/Thành phố',
                          onTap: () {
                            SearchProvincePage().show(context).then((dynamic value) {});
                          },
                        ),
                        Gap(16),
                        OutlineField(
                          label: 'Quận/Huyện',
                          onTap: () {},
                        ),
                        Gap(16),
                        OutlineField(
                          label: 'Phường/Xã',
                          onTap: () {},
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Địa chỉ cụ thể',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Chi tiết giá mua',
                    child: Column(
                      children: [
                        OutlineField(
                          label: 'Ngày mua',
                          onTap: () {},
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Giá mua',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Chi tiết giá bán',
                    child: Column(
                      children: [
                        OutlineField(
                          label: 'Ngày bán',
                          onTap: () {},
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Giá bán',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Thửa đất',
                    child: Column(
                      children: [
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Thửa đất số',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Bản đồ số',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Diện tích',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Hình thức sử dụng',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Mục đích sử dụng',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Thời hạn sử dụng',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Diện tích',
                    child: Column(
                      children: [
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Đất ở',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Cây lâu năm',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Thuế',
                    child: Column(
                      children: [
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Thời điểm gia hạn đất',
                        ),
                        Gap(16),
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Thời hạn đóng thuế',
                        ),
                      ],
                    ),
                  ),
                  Gap(16),
                  AddCard(
                    title: 'Ghi chú',
                    child: Column(
                      children: [
                        CustomTextField(
                          onChanged: (String value) {},
                          hint: 'Chi tiết',
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
                onPressed: () {
                  _createLandCertificateUseCase.execute(
                    LandCertificateEntity(
                      id: -1,
                      name: 'name',
                      area: 100,
                      mapNumber: 10,
                    ),
                  );
                },
                child: Text('Lưu')),
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
