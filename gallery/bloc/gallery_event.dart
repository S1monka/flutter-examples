part of 'gallery_bloc.dart';

abstract class GalleryEvent extends SingleDataLoaderEvent {}

class LoadNextPage extends GalleryEvent {}

class ChangeTab extends GalleryEvent {
  final int currentIndex;

  ChangeTab(this.currentIndex);
}

class UpdateWorkCounter extends GalleryEvent {}

class UpdateAllTabs extends GalleryEvent {}

class ChangeSorting extends GalleryEvent {
  final ImageModel fromImage;
  final ImageModel toImage;

  ChangeSorting({required this.fromImage, required this.toImage});
}

class GetDataWithFilters extends GalleryEvent {
  final TabType tab;
  final Map<String, dynamic> filters;

  GetDataWithFilters({
    required this.tab,
    required this.filters,
  });
}
