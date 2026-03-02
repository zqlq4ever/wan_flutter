import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/widgets/web/webview_page.dart';
import 'package:wan_android_flutter/widgets/web/webview_widget.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> with TickerProviderStateMixin {
  final CancelToken _cancelToken = CancelToken();
  final double _value = 0;
  late List<AnimationController> _floatControllers;
  late List<Animation<double>> _floatAnimations;
  late AnimationController _waveController;
  late AnimationController _colorController;
  late math.Random _random;
  int _currentColorIndex = 0;

  final List<List<Color>> _colorPairs = [
    [const Color(0xFF6366F1), const Color(0xFF8B5CF6), const Color(0xFFA855F7), const Color(0xFFD946EF)],
    [const Color(0xFF3B82F6), const Color(0xFF06B6D4), const Color(0xFF14B8A6), const Color(0xFF22C55E)],
    [const Color(0xFFEC4899), const Color(0xFFF43F5E), const Color(0xFFEF4444), const Color(0xFFF97316)],
    [const Color(0xFF8B5CF6), const Color(0xFF7C3AED), const Color(0xFF6D28D9), const Color(0xFF5B21B6)],
    [const Color(0xFF06B6D4), const Color(0xFF0891B2), const Color(0xFF0E7490), const Color(0xFF155E75)],
    [const Color(0xFFF472B6), const Color(0xFFE879F9), const Color(0xFFA855F7), const Color(0xFF7C3AED)],
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

    _floatControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(seconds: 2 + _random.nextInt(3)),
        vsync: this,
      )..repeat(reverse: true);
    });

    _floatAnimations = _floatControllers.map((controller) {
      final begin = _random.nextDouble() * 15;
      final end = begin + 5 + _random.nextDouble() * 10;
      return Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _colorController.dispose();
    for (final controller in _floatControllers) {
      controller.dispose();
    }
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          _buildAnimatedBackground(),
          _buildFlowingCircles(),
          _buildWaveEffect(),
          _buildHeaderContent(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _colorController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getInterpolatedColors(),
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

  List<Color> _getInterpolatedColors() {
    final nextIndex = (_currentColorIndex + 1) % _colorPairs.length;
    final currentColors = _colorPairs[_currentColorIndex];
    final nextColors = _colorPairs[nextIndex];
    final t = _colorController.value;

    return List.generate(4, (i) {
      return Color.lerp(currentColors[i], nextColors[i], t) ?? currentColors[i];
    });
  }

  Widget _buildFlowingCircles() {
    return AnimatedBuilder(
      animation: Listenable.merge(_floatControllers),
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              right: -30.w + _floatAnimations[0].value * 2,
              top: 20.h + _floatAnimations[0].value,
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
              left: -20.w - _floatAnimations[1].value,
              bottom: 40.h + _floatAnimations[1].value * 1.5,
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
              right: 60.w,
              bottom: 60.h - _floatAnimations[2].value * 0.5,
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
              left: 80.w + _floatAnimations[3].value,
              top: 60.h - _floatAnimations[3].value,
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

  Widget _buildHeaderContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatAnimations[4],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_floatAnimations[4].value * 0.5),
                child: Container(
                  width: 90.r,
                  height: 90.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    size: 45.r,
                    color: const Color(0xFF8B5CF6),
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

  Widget _buildContent(BuildContext context) {
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
                    colors: [
                      const Color(0xFF8B5CF6),
                      const Color(0xFFD946EF),
                    ],
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
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Container(
            constraints: BoxConstraints(maxHeight: 280.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUpdateItem(AppStrings.getString('update_item_1')),
                  _buildUpdateItem(AppStrings.getString('update_item_2')),
                  _buildUpdateItem(AppStrings.getString('update_item_3')),
                  _buildUpdateItem(AppStrings.getString('update_item_4')),
                ],
              ),
            ),
          ),
          SizedBox(height: 36.h),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String text) {
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
                colors: [
                  const Color(0xFF8B5CF6),
                  const Color(0xFFD946EF),
                ],
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
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: AppStrings.getString('later'),
            isPrimary: false,
            onTap: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: _buildButton(
            text: AppStrings.getString('update_now'),
            isPrimary: true,
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
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFFD946EF),
                  ],
                )
              : null,
          color: isPrimary ? null : Colors.grey[50],
          borderRadius: BorderRadius.circular(48.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: Colors.grey[300]!,
                  width: 1.5,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
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
                color: isPrimary ? Colors.white : Colors.grey[600],
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
