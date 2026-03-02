import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../res/colors.dart';
import '../res/dimens.dart';
import '../res/gaps.dart';
import '../utils/theme_util.dart';
import 'my_button.dart';

/// 自定义 AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {super.key,
      this.backgroundColor,
      this.title = '',
      this.centerTitle = '',
      this.actionName = '',
      this.backImg = 'assets/images/icon_back.png',
      this.backImgColor,
      this.titleColor,
      this.onPressed,
      this.isBack = true});

  final Color? backgroundColor;
  final String title;
  final String centerTitle;
  final String backImg;
  final Color? backImgColor;
  final Color? titleColor;
  final String actionName;
  final VoidCallback? onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? context.backgroundColor;

    final SystemUiOverlayStyle overlayStyle =
        ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark ? ThemeUtils.light : ThemeUtils.dark;

    final Widget action = actionName.isNotEmpty
        ? Positioned(
            right: 0.0,
            child: Theme(
              data: Theme.of(context).copyWith(
                buttonTheme: const ButtonThemeData(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  minWidth: 60.0,
                ),
              ),
              child: MyButton(
                key: const Key('actionName'),
                fontSize: Dimens.font_sp14,
                minWidth: null,
                text: actionName,
                textColor: context.isDark ? Colours.dark_text : Colours.text,
                backgroundColor: Colors.transparent,
                onPressed: onPressed,
              ),
            ),
          )
        : Gaps.empty;

    final Widget back = isBack
        ? IconButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final isBack = await Navigator.maybePop(context);
              if (!isBack) {
                await SystemNavigator.pop();
              }
            },
            tooltip: 'Back',
            padding: const EdgeInsets.all(12.0),
            icon: Image.asset(
              backImg,
              color: backImgColor ?? (context.isDark ? Colors.white.withValues(alpha: 0.7) : ThemeUtils.getIconColor(context)),
            ),
          )
        : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Text(
          title.isEmpty ? centerTitle : title,
          style: TextStyle(
            fontSize: Dimens.font_sp18,
            color: titleColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: bgColor,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                titleWidget,
                back,
                action,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
