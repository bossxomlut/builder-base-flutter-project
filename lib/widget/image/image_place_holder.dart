import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../widget/index.dart';
import '../../domain/index.dart';
import '../../resource/index.dart';

class UploadImagePlaceholder extends StatelessWidget {
  const UploadImagePlaceholder({super.key, required this.title, this.filePath, this.onChanged, this.onRemove});
  final String title;
  final String? filePath;
  final ValueChanged<List<AppFile>?>? onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final height = 120.0;
    final theme = context.appTheme;
    if (filePath != null) {
      return Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.borderColor,
            width: 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              child: AppImage.file(
                url: filePath!,
                fit: BoxFit.cover,
                height: height,
              ),
            ),
            if (onRemove != null)
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    onRemove?.call();
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
      );
    }

    return InkWell(
      onTap: () async {
        AppFilePicker(
          allowMultiple: true,
        ).opeFilePicker().then((appFiles) {
          onChanged?.call(appFiles);
        });
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

class Base64ImagePlaceholder extends StatefulWidget {
  const Base64ImagePlaceholder({super.key, required this.data, this.onRemove});
  final String data;
  final VoidCallback? onRemove;

  @override
  State<Base64ImagePlaceholder> createState() => _Base64ImagePlaceholderState();
}

class _Base64ImagePlaceholderState extends State<Base64ImagePlaceholder> {
  Uint8List imageBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final height = 120.0;
    final theme = context.appTheme;
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.borderColor,
          width: 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              height: height,
            ),
          ),
          if (widget.onRemove != null)
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: () {
                  widget.onRemove?.call();
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
    );
  }
}

//create list photo view
void showImages(
  BuildContext context,
  List<String> images,
  int defaultIndex,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final theme = context.appTheme;
      return Dialog(
        // backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(),
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListPhotoView(
              images: images,
              defaultIndex: defaultIndex,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    // color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ListPhotoView extends StatefulWidget {
  const ListPhotoView({super.key, required this.images, required this.defaultIndex});

  final List<String> images;
  final int defaultIndex;

  @override
  State<ListPhotoView> createState() => _ListPhotoViewState();
}

class _ListPhotoViewState extends State<ListPhotoView> with SingleTickerProviderStateMixin {
  List<String> get images => widget.images;
  late final TabController tabController;

  final Duration duration = const Duration(milliseconds: 300);
  final Curve curve = Curves.easeInOut;

  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: images.length, vsync: this, initialIndex: widget.defaultIndex);
    pageController = PageController(initialPage: widget.defaultIndex);
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.sync(
        () {
          return List<Uint8List>.generate(images.length, (index) {
            return base64Decode(images[index]);
          });
        },
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Đã có lỗi xảy ra...'),
          );
        }

        return Container(
          child: Column(
            children: [
              Expanded(
                child: PhotoViewGallery.builder(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  pageController: pageController,
                  enableRotation: true,
                  wantKeepAlive: true,
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: MemoryImage(snapshot.data![index]),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                    );
                  },
                  itemCount: images.length,
                ),
              ),
              AppDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  onTap: (int value) {
                    pageController.animateToPage(value, duration: duration, curve: curve);
                  },
                  tabs: List.generate(images.length, (index) {
                    return Tab(
                      child: Image.memory(
                        snapshot.data![index],
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

///Show only one image

//
// showDialog(
// context: context,
// traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
// useSafeArea: false,
// builder: (BuildContext context) {
// return Dialog(
// backgroundColor: Colors.transparent,
// insetPadding: EdgeInsets.zero,
// child: Stack(
// fit: StackFit.expand,
// children: [
// Container(
// color: theme.canvasColor,
// child: PhotoView(
// imageProvider: MemoryImage(imageBytes),
// backgroundDecoration: BoxDecoration(color: Colors.transparent),
// enableRotation: true,
// wantKeepAlive: true,
// ),
// ),
// Positioned(
// top: 0,
// left: 0,
// child: SafeArea(
// child: IconButton(
// icon: Icon(
// Icons.close,
// // color: theme.iconTheme.color,
// ),
// onPressed: () {
// Navigator.of(context).pop();
// },
// ),
// ),
// ),
// ],
// ),
// );
// },
// );
