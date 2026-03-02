import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/widgets/my_app_bar.dart';

/// 扫描页面
/// 
/// 页面结构：
/// - 顶部：透明AppBar
/// - 中间：相机预览 + 扫描线动画
/// - 底部：扫描结果组件 + 扫描提示组件
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  /// 扫描结果
  Barcode? _barcode;

  /// 扫描线动画控制器
  late AnimationController _scanController;

  /// 扫描线位移动画
  late Animation<double> _scanAnimation;

  /// 是否显示扫描线
  bool _showScanLine = true;

  /// 扫描结果是否展开
  bool _isResultExpanded = false;

  @override
  void initState() {
    super.initState();
    _initScanAnimation();
  }

  /// 初始化扫描线动画
  /// 动画时长2秒，从屏幕1/4处扫描到3/4处
  void _initScanAnimation() {
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
    _scanController.addStatusListener(_onAnimationStatus);
    _scanController.forward();
  }

  /// 动画状态监听
  /// 完成后隐藏扫描线，等待2秒后重新开始
  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _showScanLine = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showScanLine = true;
          });
          _scanController.forward(from: 0);
        }
      });
    }
  }

  @override
  void dispose() {
    _scanController.removeStatusListener(_onAnimationStatus);
    _scanController.dispose();
    super.dispose();
  }

  /// 扫描提示组件
  /// 始终显示在底部，提示用户将二维码放入框内
  Widget _scanHint() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 21.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.white70, size: 53.r),
          SizedBox(width: 21.w),
          Text(
            '将二维码放入框内扫描',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 40.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// 扫描结果组件
  /// 
  /// 功能：
  /// - 点击复制按钮复制到剪切板
  /// - 支持展开/折叠，展开后最多显示5行
  Widget _scanResult(Barcode? value) {
    if (value == null) {
      return const SizedBox.shrink();
    }

    final resultText = value.displayValue ?? '扫描成功';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 21.h),
      decoration: BoxDecoration(
        color: Colours.app_main.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 53.r),
          SizedBox(width: 21.w),
          Expanded(
            child: Text(
              resultText,
              maxLines: _isResultExpanded ? 5 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 21.w),
          GestureDetector(
            onTap: () {
              setState(() {
                _isResultExpanded = !_isResultExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Icon(
                _isResultExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white70,
                size: 64.r,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: resultText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已复制到剪切板'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Icon(Icons.copy, color: Colors.white70, size: 53.r),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理扫描结果
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "扫一扫",
        backgroundColor: Colors.transparent,
        backImgColor: Colors.white,
        titleColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          _buildScanLine(screenHeight),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(vertical: 60.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _scanResult(_barcode),
                  SizedBox(height: 21.h),
                  _scanHint(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 扫描线组件
  /// 
  /// 特点：
  /// - 带渐变效果的扫描线
  /// - 从屏幕1/4处扫描到3/4处
  /// - 动画完成后隐藏
  Widget _buildScanLine(double screenHeight) {
    if (!_showScanLine) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: screenHeight * (0.25 + _scanAnimation.value * 0.5),
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colours.app_main.withValues(alpha: 0.8),
                  Colours.app_main,
                  Colours.app_main.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const [0, 0.2, 0.5, 0.8, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colours.app_main.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
