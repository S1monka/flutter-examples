import 'package:catchup/core/blocs/index.dart';
import 'package:catchup/core/data/failures.dart';
import 'package:catchup/data/models/index.dart';
import 'package:catchup/data/repositories/gallery_repository.dart';
import 'package:catchup/features/gallery/ui/models/tab_types.dart';

import 'package:injectable/injectable.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

abstract class GalleryBloc
    extends SingleDataLoaderBloc<GalleryEvent, GalleryState, GalleryModel> {
  final GalleryRepository _galleryRepository;
  final String? _masterId;
  GalleryBloc(
    this._galleryRepository,
    @factoryParam this._masterId,
    List<TabType> tabs,
  ) : super(GalleryState.initial(tabs: tabs));

  @override
  Stream<GalleryState> mapEventToState(SingleDataLoaderEvent event) async* {
    if (event is GetSingleData) {
      final hash = DateTime.now().toString();
      yield state.copyWith(
        hash: hash,
      );
      yield* super.mapEventToState(event);
      final tabs = [...state.tabsData];
      tabs[state.currentIndex] = state.data!;
      if (_masterId != null && state.currentIndex == 3) {
        tabs[state.currentIndex] = state.currentTabGallery.copyWith(
          data: [...?state.currentTabGallery.data]
              .where((work) => work.profileClient != null)
              .toList(),
        );
      }
      yield state.copyWith(
        tabsData: tabs,
      );
    } else if (event is ChangeTab) {
      yield state.copyWith(
        currentIndex: event.currentIndex,
      );
      if (state.tabsData[event.currentIndex].data!.isEmpty) {
        add(GetSingleData());
      }
    } else if (event is LoadNextPage) {
      final nextPage = state.currentTabGallery.meta!.currentPage + 1;
      if (state.isNotLastPage) {
        final works = await _getWorksResponse(
          page: nextPage,
          categoryId: state.currentCategoryId,
        );
        final tabs = [...state.tabsData];
        tabs[state.currentIndex] = state.currentTabGallery.copyWith(
          data: [...?state.currentTabGallery.data, ...?works.data],
          meta: state.currentTabGallery.meta?.copyWith(
            currentPage: nextPage,
          ),
        );
        yield state.copyWith(
          tabsData: tabs,
        );
      }
    }
  }

  Future<GalleryModel> _getWorksResponse({
    int page = 0,
    required String categoryId,
    Map<String, dynamic>? filters,
  }) async {
    return await _galleryRepository.readWorks(
      categoryId: categoryId,
      page: page,
      masterId: _masterId,
      filters: filters,
      hash: state.hash,
    );
  }

  @override
  Future<GalleryModel> getDataFromRepository() async {
    return await _getWorksResponse(categoryId: state.currentCategoryId);
  }
}

@injectable
class CommonGalleryBloc extends GalleryBloc {
  CommonGalleryBloc(GalleryRepository galleryRepository)
      : super(
          galleryRepository,
          null,
          TabType.commonGalleryTabs,
        );

  @override
  Stream<GalleryState> mapEventToState(SingleDataLoaderEvent event) async* {
    yield* super.mapEventToState(event);
    if (event is GetDataWithFilters) {
      final newIndex = state.tabs.indexWhere((tab) => tab.id == event.tab.id);
      yield state.copyWith(
        status: Status.loading,
        currentIndex: newIndex,
      );
      final filteredData = await _getWorksResponse(
        categoryId: state.currentCategoryId,
        filters: event.filters,
      );
      final tabsData = [...state.tabsData];
      tabsData[state.currentIndex] = filteredData;
      yield state.copyWith(
        tabsData: tabsData,
        status: Status.success,
      );
    }
  }
}

@injectable
class MasterGalleryBloc extends GalleryBloc {
  MasterGalleryBloc(
    GalleryRepository galleryRepository,
    @factoryParam String masterId,
  ) : super(
          galleryRepository,
          masterId,
          TabType.masterGalleryTabs,
        ) {
    add(UpdateWorkCounter());
  }

  @override
  Stream<GalleryState> mapEventToState(SingleDataLoaderEvent event) async* {
    yield* super.mapEventToState(event);
    if (event is ChangeSorting) {
      final tabsData = [...state.tabsData];
      final fromIndex =
          tabsData[state.currentIndex].data!.indexOf(event.fromImage);
      final toIndex = tabsData[state.currentIndex].data!.indexOf(event.toImage);

      final newTabData = state.currentTabGallery.copyWith(
        data: [...state.currentTabGallery.data!]
          ..remove(event.fromImage)
          ..remove(event.toImage)
          ..insert(fromIndex, event.toImage)
          ..insert(toIndex, event.fromImage),
      );
      tabsData[state.currentIndex] = newTabData;
      yield state.copyWith(
        tabsData: tabsData,
      );
      await _galleryRepository.reorder(
        masterId: _masterId!,
        fromId: event.fromImage.id,
        toId: event.toImage.id,
      );
    } else if (event is UpdateWorkCounter) {
      final allWorks = await _getWorksResponse(categoryId: '');
      yield state.copyWith(
        allWorksCount: allWorks.data!.length,
      );
    } else if (event is UpdateAllTabs) {
      yield state.copyWith(
        status: Status.loading,
      );
      final tabsData = [...state.tabsData];
      for (var index = 0; index < state.tabs.length; index++) {
        final works = await _getWorksResponse(categoryId: state.tabs[index].id);
        tabsData[index] = works;
      }
      yield state.copyWith(
        tabsData: tabsData,
        status: Status.success,
      );
      add(UpdateWorkCounter());
    }
  }
}
