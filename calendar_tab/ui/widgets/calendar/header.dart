import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final String month;
  final String year;

  Header({Key? key, required this.month, required this.year}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: month,
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
          children: [
            const TextSpan(
              text: " ",
            ),
            TextSpan(
              text: year,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 14.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
