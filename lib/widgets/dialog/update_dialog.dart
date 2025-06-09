import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../utils/image_util.dart';
import '../my_button.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final CancelToken _cancelToken = CancelToken();
  double _value = 0;

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      /// 使用false禁止返回键返回，达到强制升级目的
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 120.0,
                  width: 280.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                    image: DecorationImage(
                      image: ImageUtil.getAssetImage('update_head', format: ImageFormat.jpg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 280.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius:
                          const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('新版本更新', style: TextStyles.textSize16),
                      Gaps.vGap10,
                      const Text('1.又双叒修复了一大堆bug。\n\n2.祭天了多名程序猿。'),
                      Gaps.vGap15,
                      _buildButton(context),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildButton(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 110.0,
          height: 36.0,
          child: MyButton(
            text: '残忍拒绝',
            fontSize: Dimens.font_sp16,
            textColor: primaryColor,
            disabledTextColor: Colors.white,
            disabledBackgroundColor: Colours.text_gray_c,
            radius: 18.0,
            side: BorderSide(
              color: primaryColor,
              width: 0.8,
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: 110.0,
          height: 36.0,
          child: MyButton(
            text: '立即更新',
            fontSize: Dimens.font_sp16,
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Colors.white,
            backgroundColor: primaryColor,
            disabledTextColor: Colors.white,
            disabledBackgroundColor: Colours.text_gray_c,
            radius: 18.0,
          ),
        )
      ],
    );
  }
}
