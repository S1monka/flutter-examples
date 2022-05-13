import 'package:catchup/features/index.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showFiltersModalBottomSheet(BuildContext context, List<TabType> tabs) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.r),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(20.r),
        child: Wrap(
          runSpacing: 20.w,
          alignment: WrapAlignment.center,
          children: [
            Text(
              "filter".tr(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Row(
              children: tabs.asMap().keys.map(
                (index) {
                  final tab = tabs[index];

                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                          ..pop()
                          ..pushNamed(
                            FilterScreen.routeName,
                            arguments: tab,
                          );
                      },
                      child: Tab(
                        icon: SvgPicture.asset(tab.imagePath),
                        text: tab.title.tr(),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      );
    },
  );
}
