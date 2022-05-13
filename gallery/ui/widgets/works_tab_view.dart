import 'package:catchup/data/models/index.dart';
import 'package:catchup/features/gallery/bloc/gallery_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:catchup/core/index.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorksTabView<T extends GalleryBloc> extends StatefulWidget {
  final Function(ImageModel fromImage, ImageModel toImage)? onReorder;
  WorksTabView({
    Key? key,
    this.onReorder,
  }) : super(key: key);

  @override
  State<WorksTabView> createState() => _WorksTabViewState<T>();
}

class _WorksTabViewState<T extends GalleryBloc> extends State<WorksTabView<T>> {
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    initController();
    super.initState();
  }

  void initController() {
    scrollController.addListener(() {
      if (isBottom && !isLoading) {
        setState(() {
          isLoading = true;
        });
        context.read<T>().add(LoadNextPage());
      }
    });
  }

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    return currentScroll > (maxScroll - 150.h);
  }

  @override
  Widget build(BuildContext context) {
    return SingleDataLoaderWidget<T, GalleryState, GalleryModel>(
      listener: (context, state) {
        if (state.status == Status.success) {
          setState(() {
            isLoading = false;
          });
        }
      },
      loadingBuilder: (context, state) => CustomScrollView(
        slivers: [
          PhotosGrid(),
        ],
      ),
      builderIfSuccess: (context, state) {
        final images = [...?state.currentTabGallery.data];
        if (images.isEmpty) {
          return CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    "thisCategoryIsEmpty".tr(),
                  ),
                ),
              ),
            ],
          );
        }
        return CustomScrollView(
          controller: scrollController,
          physics: images.length > 6
              ? const BouncingScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          slivers: [
            PhotosGrid(
              imagesList: images,
              onReorder: widget.onReorder,
            ),
            if (isLoading && state.isNotLastPage)
              SliverToBoxAdapter(
                child: Center(
                  child: LoadingWidget(),
                ),
              ),
          ],
        );
      },
    );
  }
}
