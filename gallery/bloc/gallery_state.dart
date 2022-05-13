part of 'gallery_bloc.dart';

class GalleryState extends SingleDataLoaderState<GalleryModel> {
  final List<GalleryModel> tabsData;

  final int currentIndex;

  final List<TabType> tabs;

  final String hash;

  final int allWorksCount;
  GalleryState(Failure? failure, Status status, data, this.tabsData,
      this.currentIndex, this.tabs, this.hash,
      {this.allWorksCount = 0})
      : super(
          failure,
          status,
          data,
        );

  GalleryState.initial({
    this.currentIndex = 0,
    required this.tabs,
  })  : tabsData = [
          for (var _ in tabs) const GalleryModel.empty(),
        ],
        allWorksCount = 0,
        hash = '',
        super.initial();

  bool get isNotLastPage {
    final nextPage = currentTabGallery.meta!.currentPage + 1;
    final lastPage = currentTabGallery.meta!.lastPage;
    return lastPage >= nextPage;
  }

  String get currentCategoryId => tabs[currentIndex].id;

  GalleryModel get currentTabGallery => tabsData[currentIndex];

  @override
  List<Object?> get props => [
        ...super.props,
        tabsData,
        currentIndex,
        tabs,
        allWorksCount,
      ];

  @override
  GalleryState copyWith({
    Status? status,
    GalleryModel? data,
    Failure? failure,
    List<GalleryModel>? tabsData,
    int? currentIndex,
    int? allWorksCount,
    String? hash,
  }) {
    return GalleryState(
      failure ?? this.failure,
      status ?? this.status,
      data ?? this.data,
      tabsData ?? this.tabsData,
      currentIndex ?? this.currentIndex,
      tabs,
      hash ?? this.hash,
      allWorksCount: allWorksCount ?? this.allWorksCount,
    );
  }
}
