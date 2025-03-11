import 'package:flutter/material.dart';

import '../../../core/index.dart';
import '../../../domain/index.dart';
import '../../../resource/index.dart';
import '../../../widget/index.dart';

class OtherAreaWidget extends StatefulWidget {
  const OtherAreaWidget({
    super.key,
    this.areaEntity,
    required this.onChanged,
    required this.onRemove,
    required this.title,
    this.isExpanded = true,
    required this.onExpand,
  });

  final AreaEntity? areaEntity;
  final ValueChanged<AreaEntity> onChanged;
  final VoidCallback onRemove;
  final String title;
  final bool isExpanded;
  final ValueChanged<bool> onExpand;

  @override
  State<OtherAreaWidget> createState() => _OtherAreaWidgetState();
}

class _OtherAreaWidgetState extends State<OtherAreaWidget> {
  final TextEditingController _residentialAreaController = TextEditingController();
  final TextEditingController _perennialTreeAreaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _residentialAreaController.text = widget.areaEntity?.typeName ?? '';
    _perennialTreeAreaController.text = widget.areaEntity?.area?.inputFormat() ?? '';
  }

  @override
  void didUpdateWidget(covariant OtherAreaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!const DeepCollectionEquality().equals(oldWidget.areaEntity, widget.areaEntity)) {
      _residentialAreaController.text = widget.areaEntity?.typeName ?? '';
      _perennialTreeAreaController.text = widget.areaEntity?.area?.inputFormat() ?? '';
    }
  }

  @override
  void dispose() {
    _residentialAreaController.dispose();
    _perennialTreeAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return ExpansionTile(
      key: ValueKey(widget.isExpanded),
      initiallyExpanded: widget.isExpanded,
      onExpansionChanged: widget.onExpand,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor),
      ),
      backgroundColor: theme.colorScheme.surface,
      leading: IconButton(
        onPressed: widget.onRemove,
        icon: const Icon(LineIcons.trash),
      ),
      tilePadding: const EdgeInsets.only(right: 16),
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(widget.title),
      children: [
        CustomTextField(
          controller: _residentialAreaController,
          onChanged: (value) {
            widget.onChanged((widget.areaEntity ?? AreaEntity()).copyWith(typeName: value));
          },
          label: 'Loại đất',
        ),
        Gap(16),
        CustomTextField(
          controller: _perennialTreeAreaController,
          onChanged: (value) {
            widget.onChanged((widget.areaEntity ?? AreaEntity()).copyWith(area: double.tryParse(value)));
          },
          label: 'Diện tích',
          keyboardType: TextInputType.number,
        ),
        Gap(12),
      ],
    );
  }
}
