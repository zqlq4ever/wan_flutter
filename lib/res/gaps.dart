import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gaps {
  static final Widget hGap4 = SizedBox(width: 4.w);
  static final Widget hGap5 = SizedBox(width: 5.w);
  static final Widget hGap8 = SizedBox(width: 8.w);
  static final Widget hGap10 = SizedBox(width: 10.w);
  static final Widget hGap12 = SizedBox(width: 12.w);
  static final Widget hGap15 = SizedBox(width: 15.w);
  static final Widget hGap16 = SizedBox(width: 16.w);
  static final Widget hGap32 = SizedBox(width: 32.w);

  static final Widget vGap4 = SizedBox(height: 4.h);
  static final Widget vGap5 = SizedBox(height: 5.h);
  static final Widget vGap8 = SizedBox(height: 8.h);
  static final Widget vGap10 = SizedBox(height: 10.h);
  static final Widget vGap12 = SizedBox(height: 12.h);
  static final Widget vGap15 = SizedBox(height: 15.h);
  static final Widget vGap16 = SizedBox(height: 16.h);
  static final Widget vGap24 = SizedBox(height: 24.h);
  static final Widget vGap32 = SizedBox(height: 32.h);
  static final Widget vGap50 = SizedBox(height: 50.h);

  static final Widget line = Divider();

  static final Widget vLine = SizedBox(
    width: 0.6.w,
    height: 24.h,
    child: VerticalDivider(),
  );

  static final Widget empty = SizedBox.shrink();
}
