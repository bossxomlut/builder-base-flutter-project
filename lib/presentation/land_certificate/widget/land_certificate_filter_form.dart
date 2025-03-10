import 'package:flutter/material.dart';

import '../../../core/index.dart';
import '../../../domain/entity/filter_land_certificate_entity.dart';
import '../../../resource/index.dart';
import '../../../widget/index.dart';
import '../../../widget/toast.dart';

class LandCertificateFilterForm extends StatefulWidget with ShowBottomSheet {
  const LandCertificateFilterForm({super.key, this.filter, this.onApply});

  final FilterLandCertificateEntity? filter;
  final ValueChanged<FilterLandCertificateEntity?>? onApply;

  @override
  State<LandCertificateFilterForm> createState() => _LandCertificateFilterFormState();
}

class _LandCertificateFilterFormState extends State<LandCertificateFilterForm> {
  FilterLandCertificateEntity? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter ?? FilterLandCertificateEntity();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onApply?.call(null);
                },
                child: Text('Bỏ lọc'),
              ),
            ],
          ),
        ),
        Flexible(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Theo ngày', style: Theme.of(context).textTheme.titleMedium),
                Card(
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Ngày mua', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineField(
                                label: 'Từ ngày',
                                value: _filter?.purchaseDateFrom?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          purchaseDateFrom: selectedDate,
                                        );
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: OutlineField(
                                label: 'Đến ngày',
                                value: _filter?.purchaseDateTo?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          purchaseDateTo: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Text('Ngày bán', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineField(
                                label: 'Từ ngày',
                                value: _filter?.saleDateFrom?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          saleDateFrom: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: OutlineField(
                                label: 'Đến ngày',
                                value: _filter?.saleDateTo?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          saleDateTo: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        //Thời điểm đóng thuế
                        Text('Thời điểm đóng thuế', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineField(
                                label: 'Từ thời điểm',
                                value: _filter?.taxDeadlineTimeFrom?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          taxDeadlineTimeFrom: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: OutlineField(
                                label: 'Đến thời điểm',
                                value: _filter?.taxDeadlineTimeTo?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          taxDeadlineTimeTo: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),

                        //Thời điểm gia hạn thuế
                        Text('Thời điểm gia hạn thuế', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineField(
                                label: 'Từ thời điểm',
                                value: _filter?.taxRenewalTimeFrom?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          taxRenewalTimeFrom: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: OutlineField(
                                label: 'Đến thời điểm',
                                value: _filter?.taxRenewalTimeTo?.date,
                                onTap: () async {
                                  AppShowDatePicker(
                                    context,
                                    (selectedDate) {
                                      if (selectedDate != null) {
                                        _filter = _filter?.copyWith(
                                          taxRenewalTimeTo: selectedDate,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                trailing: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                Text('Theo giá', style: Theme.of(context).textTheme.titleMedium),
                Card(
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Giá mua', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Từ giá',
                                initialValue: _filter?.purchasePriceFrom?.toString(),
                                onChanged: (String value) {
                                  _filter = _filter?.copyWith(
                                    purchasePriceFrom: double.tryParse(value),
                                  );
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: CustomTextField(
                                label: 'Đến giá',
                                initialValue: _filter?.purchasePriceTo?.toString(),
                                onChanged: (String value) {
                                  _filter = _filter?.copyWith(
                                    purchasePriceTo: double.tryParse(value),
                                  );
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        //Ngày bán
                        const Gap(10),
                        //Giá bán
                        Text('Giá bán', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Từ giá',
                                initialValue: _filter?.salePriceFrom?.toString(),
                                onChanged: (String value) {
                                  _filter = _filter?.copyWith(
                                    salePriceFrom: double.tryParse(value),
                                  );
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: CustomTextField(
                                label: 'Đến giá',
                                initialValue: _filter?.salePriceTo?.toString(),
                                onChanged: (String value) {
                                  _filter = _filter?.copyWith(
                                    salePriceTo: double.tryParse(value),
                                  );
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                Text('Khác', style: Theme.of(context).textTheme.titleMedium),
                Card(
                  color: theme.cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Diện tích', style: Theme.of(context).textTheme.titleMedium),
                            const Gap(8),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: 'Từ diện tích',
                                    initialValue: _filter?.areaFrom?.toString(),
                                    onChanged: (String value) {
                                      _filter = _filter?.copyWith(
                                        areaFrom: double.tryParse(value),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: CustomTextField(
                                    label: 'Đến diện tích',
                                    initialValue: _filter?.areaTo?.toString(),
                                    onChanged: (String value) {
                                      _filter = _filter?.copyWith(
                                        areaTo: double.tryParse(value),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
        )),
        AppDivider(),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
              onPressed: () {
                //validate

                if (_filter?.isValid == false) {
                  showError(message: 'Vui lòng chọn ít nhất một điều kiện lọc');
                  return;
                }

                Navigator.of(context).pop();
                widget.onApply?.call(_filter);
              },
              child: Text('Áp dụng')),
        ),
        const Gap(8),
      ],
    );
  }
}
