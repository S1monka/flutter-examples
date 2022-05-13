import 'package:catchup/core/const/images_paths.dart';
import 'package:catchup/features/gallery/bloc/gallery_bloc.dart';
import 'package:catchup/features/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';

class GalleryTabScreen extends StatelessWidget {
  final List<TabType> _tabs =
      TabType.commonGalleryTabs.where((tabType) => tabType is! AllTab).toList();

  GalleryTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showFiltersModalBottomSheet(context, _tabs);
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(ImagesPaths.filterIconImagePath),
            SizedBox(width: 10.w),
            Text("filter".tr()),
          ],
        ),
        isExtended: true,
        shape: const StadiumBorder(),
      ),
      body: SafeArea(
        child: GalleryTabsView<CommonGalleryBloc>(),
      ),
    );
  }
}
