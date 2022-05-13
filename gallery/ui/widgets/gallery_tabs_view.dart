import 'package:catchup/data/models/index.dart';
import 'package:catchup/features/gallery/bloc/gallery_bloc.dart';
import 'package:flutter/material.dart';

import 'package:catchup/core/index.dart';
import 'package:catchup/features/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryTabsView<T extends GalleryBloc> extends StatefulWidget {
  final Function(ImageModel fromImage, ImageModel toImage)? onReorder;

  GalleryTabsView({
    Key? key,
    this.onReorder,
  }) : super(key: key);

  @override
  _GalleryTabsViewState createState() => _GalleryTabsViewState<T>();
}

class _GalleryTabsViewState<T extends GalleryBloc>
    extends State<GalleryTabsView> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    final bloc = context.read<T>();
    tabController = TabController(length: bloc.state.tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocConsumer<T, GalleryState>(
          listener: (context, state) {
            setState(() {
              tabController.animateTo(state.currentIndex);
            });
          },
          listenWhen: (prev, current) =>
              prev.currentIndex != current.currentIndex,
          builder: (context, state) {
            return CustomTabBar(
              tabController: tabController,
              tabs: state.tabs,
              onTap: (index) {
                context.read<T>().add(ChangeTab(index));
              },
            );
          },
        ),
        Flexible(
          child: WorksTabView<T>(
            onReorder: widget.onReorder,
          ),
        ),
      ],
    );
  }
}
