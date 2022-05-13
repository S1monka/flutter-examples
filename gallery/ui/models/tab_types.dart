import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';

abstract class TabType extends Category {
  final String imagePath;

  const TabType(String title, this.imagePath, String id) : super(id, title);

  static const List<TabType> tabsList = [
    AllTab(),
    CasesTab(),
    SketchesTab(),
    MerchTab(),
    ReviewsTab()
  ];

  static const List<TabType> commonGalleryTabs = [
    AllTab(),
    CasesTab(),
    SketchesTab(),
    MerchTab(),
  ];

  static const List<TabType> masterGalleryTabs = [
    CasesTab(),
    SketchesTab(),
    MerchTab(),
    ReviewsTab()
  ];
}

class AllTab extends TabType {
  const AllTab() : super("all", ImagesPaths.allIconImagePath, '');
}

class CasesTab extends Case implements TabType {
  const CasesTab() : super(CategoriesId.casesCategoryId);

  @override
  String get imagePath => ImagesPaths.casesIconImagePath;
}

class SketchesTab extends Sketch implements TabType {
  const SketchesTab() : super(CategoriesId.sketchesCategoryId);

  @override
  String get imagePath => ImagesPaths.scetchesIconImagePath;
}

class MerchTab extends Merch implements TabType {
  const MerchTab() : super(CategoriesId.merchCategoryId);

  @override
  String get imagePath => ImagesPaths.merchIconImagePath;
}

class ReviewsTab extends HasReviews implements TabType {
  const ReviewsTab() : super('');

  @override
  String get imagePath => ImagesPaths.reviewsIconImagePath;
}
