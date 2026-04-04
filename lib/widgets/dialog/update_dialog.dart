import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';
import 'package:wan_android_flutter/pages/web/webview_page.dart';
import 'package:wan_android_flutter/pages/web/webview_widget.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> with TickerProviderStateMixin {
  final CancelToken _cancelToken = CancelToken();
  final double _value = 0;
  late AnimationController _waveController;
  late AnimationController _colorController;
  late math.Random _random;
  int _currentColorIndex = 0;

  late List<AnimationController> _pathControllers;
  late List<List<Offset>> _paths;
  late List<Animation<double>> _pathAnimations;
  late AnimationController _iconFloatController;
  late Animation<double> _iconFloatAnimation;

  final List<List<Color>> _colorPairs = [
    [const Color(0xFF4FC3F7), const Color(0xFF29B6F6), const Color(0xFF03A9F4), const Color(0xFF039BE5)],
    [const Color(0xFF81C784), const Color(0xFF66BB6A), const Color(0xFF4CAF50), const Color(0xFF43A047)],
    [const Color(0xFFFFD54F), const Color(0xFFFFCA28), const Color(0xFFFFC107), const Color(0xFFFFB300)],
    [const Color(0xFF4DD0E1), const Color(0xFF26C6DA), const Color(0xFF00BCD4), const Color(0xFF00ACC1)],
    [const Color(0xFFAED581), const Color(0xFF9CCC65), const Color(0xFF8BC34A), const Color(0xFF7CB342)],
    [const Color(0xFF80DEEA), const Color(0xFF4DD0E1), const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
  ];

  final List<List<Color>> _darkColorPairs = [
    [const Color(0xFF374151), const Color(0xFF4B5563), const Color(0xFF6B7280), const Color(0xFF9CA3AF)],
    [const Color(0xFF1F2937), const Color(0xFF374151), const Color(0xFF4B5563), const Color(0xFF6B7280)],
    [const Color(0xFF111827), const Color(0xFF1F2937), const Color(0xFF374151), const Color(0xFF4B5563)],
    [const Color(0xFF374151), const Color(0xFF4B5563), const Color(0xFF6B7280), const Color(0xFF9CA3AF)],
    [const Color(0xFF1F2937), const Color(0xFF374151), const Color(0xFF4B5563), const Color(0xFF6B7280)],
    [const Color(0xFF374151), const Color(0xFF4B5563), const Color(0xFF6B7280), const Color(0xFF9CA3AF)],
  ];

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _currentColorIndex = _random.nextInt(_colorPairs.length);

    _waveController = AnimationController(
      duration: Duration(seconds: 3 + _random.nextInt(2)),
      vsync: this,
    )..repeat();

    _colorController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _pathControllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(seconds: 10 + _random.nextInt(10)),
        vsync: this,
      )..repeat(reverse: true);
    });

    _paths = _generateRandomPaths(4);
    _pathAnimations = _pathControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _iconFloatController = AnimationController(
      duration: Duration(seconds: 2 + _random.nextInt(3)),
      vsync: this,
    )..repeat(reverse: true);

    final iconBegin = _random.nextDouble() * 15;
    final iconEnd = iconBegin + 5 + _random.nextDouble() * 10;
    _iconFloatAnimation = Tween<double>(begin: iconBegin, end: iconEnd).animate(
      CurvedAnimation(parent: _iconFloatController, curve: Curves.easeInOut),
    );
  }

  List<List<Offset>> _generateRandomPaths(int count) {
    final List<List<Offset>> allPaths = [];
    final headerWidth = 280.0;
    final headerHeight = 280.0;

    for (int i = 0; i < count; i++) {
      final path = <Offset>[];
      final controlPointCount = 3 + _random.nextInt(3);

      double x = _random.nextDouble() * headerWidth * 0.3;
      double y = _random.nextDouble() * headerHeight * 0.5;
      path.add(Offset(x, y));

      for (int j = 0; j < controlPointCount; j++) {
        x = _random.nextDouble() * headerWidth * 0.8 + headerWidth * 0.1;
        y = _random.nextDouble() * headerHeight * 0.8 + headerHeight * 0.1;
        path.add(Offset(x, y));
      }

      x = _random.nextDouble() * headerWidth * 0.3 + headerWidth * 0.5;
      y = _random.nextDouble() * headerHeight * 0.5;
      path.add(Offset(x, y));

      allPaths.add(path);
    }

    return allPaths;
  }

  Offset _getPositionOnPath(List<Offset> path, double t) {
    if (path.length < 2) return path.first;

    final totalSegments = path.length - 1;
    final segment = (t * totalSegments).floor().clamp(0, totalSegments - 1);
    final segmentT = (t * totalSegments) - segment;

    final p0 = path[segment];
    final p1 = path[segment + 1];

    return Offset(
      p0.dx + (p1.dx - p0.dx) * segmentT,
      p0.dy + (p1.dy - p0.dy) * segmentT,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _colorController.dispose();
    _iconFloatController.dispose();
    for (final controller in _pathControllers) {
      controller.dispose();
    }
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth - 100.w * 2;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            width: dialogWidth,
            decoration: BoxDecoration(
              color: isDark ? Colours.dark_card_bg : Colors.white,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(isDark),
                _buildContent(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(isDark),
          _buildFlowingCircles(),
          _buildWaveEffect(),
          _buildHeaderContent(isDark),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _colorController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getInterpolatedColors(isDark),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getInterpolatedColors(bool isDark) {
    final colorPairs = isDark ? _darkColorPairs : _colorPairs;
    final nextIndex = (_currentColorIndex + 1) % colorPairs.length;
    final currentColors = colorPairs[_currentColorIndex];
    final nextColors = colorPairs[nextIndex];
    final t = _colorController.value;

    return List.generate(4, (i) {
      return Color.lerp(currentColors[i], nextColors[i], t) ?? currentColors[i];
    });
  }

  Widget _buildFlowingCircles() {
    return AnimatedBuilder(
      animation: Listenable.merge(_pathControllers),
      builder: (context, child) {
        final positions = List.generate(4, (index) {
          return _getPositionOnPath(_paths[index], _pathAnimations[index].value);
        });

        return Stack(
          children: [
            Positioned(
              right: positions[0].dx,
              top: positions[0].dy,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: positions[1].dx,
              bottom: positions[1].dy,
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              right: positions[2].dx,
              bottom: positions[2].dy,
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              left: positions[3].dx,
              top: positions[3].dy,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaveEffect() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            size: Size(double.infinity, 60.h),
            painter: _WavePainter(_waveController.value),
          );
        },
      ),
    );
  }

  Widget _buildHeaderContent(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _iconFloatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_iconFloatAnimation.value * 0.5),
                child: Container(
                  width: 90.r,
                  height: 90.r,
                  decoration: BoxDecoration(
                    color: isDark ? Colours.dark_card_bg : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.1 : 0.3),
                        blurRadius: 15,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    size: 45.r,
                    color: isDark ? Colours.dark_text : const Color(0xFF039BE5),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.getString('new_version_found'),
            style: TextStyle(
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'v2.0.0',
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 36.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [Colours.dark_text_gray, Colours.dark_text]
                        : [const Color(0xFF4FC3F7), const Color(0xFF81C784)],
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                AppStrings.getString('update_content'),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colours.dark_text : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Container(
            constraints: BoxConstraints(maxHeight: 280.h),
            decoration: BoxDecoration(
              color: isDark ? Colours.dark_bg_color : Colors.grey[50],
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUpdateItem(AppStrings.getString('update_item_1'), isDark),
                  _buildUpdateItem(AppStrings.getString('update_item_2'), isDark),
                  _buildUpdateItem(AppStrings.getString('update_item_3'), isDark),
                  _buildUpdateItem(AppStrings.getString('update_item_4'), isDark),
                ],
              ),
            ),
          ),
          SizedBox(height: 36.h),
          _buildButtons(context, isDark),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colours.dark_text_gray, Colours.dark_text]
                    : [const Color(0xFF4FC3F7), const Color(0xFF81C784)],
              ),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 32.sp,
                color: isDark ? Colours.dark_text_gray : Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: AppStrings.getString('later'),
            isPrimary: false,
            isDark: isDark,
            onTap: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: _buildButton(
            text: AppStrings.getString('update_now'),
            isPrimary: true,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
              Get.to(
                WebViewPage(
                  loadResource: "https://www.pgyer.com/ER0YOhzL",
                  webViewType: WebViewType.URL,
                  title: AppStrings.getString('download_page'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isDark
                      ? [Colours.dark_text_gray, Colours.dark_text]
                      : [const Color(0xFF4FC3F7), const Color(0xFF81C784)],
                )
              : null,
          color: isPrimary ? null : (isDark ? Colours.dark_bg_color : Colors.grey[50]),
          borderRadius: BorderRadius.circular(48.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark ? Colours.dark_divider : Colors.grey[300]!,
                  width: 1.5,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: (isDark ? Colours.dark_text : const Color(0xFF4FC3F7)).withValues(alpha: isDark ? 0.3 : 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPrimary) ...[
              Icon(
                Icons.download_rounded,
                size: 36.r,
                color: Colors.white,
              ),
              SizedBox(width: 12.w),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : (isDark ? Colours.dark_text_gray : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    const waveCount = 2;
    final waveWidth = size.width / waveCount;
    final waveHeight = 15.h;

    path.moveTo(0, size.height);

    for (int i = 0; i <= waveCount; i++) {
      final x = i * waveWidth;
      final xOffset = animationValue * 2 * math.pi;
      final y1 = size.height * 0.3 + math.sin(xOffset + i * math.pi) * waveHeight;
      final y2 = size.height * 0.6 + math.sin(xOffset + i * math.pi + math.pi / 2) * waveHeight;

      path.quadraticBezierTo(
        x + waveWidth / 4,
        y1,
        x + waveWidth / 2,
        size.height * 0.5,
      );
      path.quadraticBezierTo(
        x + waveWidth * 3 / 4,
        y2,
        x + waveWidth,
        size.height * 0.4,
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => true;
}
