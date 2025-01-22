import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../widget/index.dart';
import '../../resource/index.dart';
import 'image.dart';

class UploadImagePlaceholder extends StatelessWidget {
  const UploadImagePlaceholder({super.key, required this.title, this.filePath, this.onChanged});
  final String title;
  final String? filePath;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final height = 80.0;
    final theme = context.appTheme;
    if (filePath != null) {
      return DottedBorder(
        color: Color(0x1AFFFFFF),
        radius: Radius.circular(8),
        dashPattern: const [6, 6],
        strokeCap: StrokeCap.butt,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  child: AppImage.file(
                    url: filePath!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      onChanged?.call(null);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4)),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Color(0xFFEBEBEB),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          onChanged?.call(image.path);
        }
      },
      child: DottedBorder(
        color: theme.borderColor,
        radius: Radius.circular(8),
        dashPattern: const [6, 6],
        strokeCap: StrokeCap.butt,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(16),
              const Icon(
                LineIcons.file,
                color: Color(0xFF8F8F8F),
                size: 30,
              ),
              const Gap(8),
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              const Gap(8),
              Text(
                'Chọn các tệp (PDF, JPG, PNG)',
                style: theme.textTheme.labelMedium,
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
