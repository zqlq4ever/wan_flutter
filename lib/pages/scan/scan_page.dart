import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/widgets/my_app_bar.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  Barcode? _barcode;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
    _scanController.addStatusListener(_onAnimationStatus);
    _scanController.forward();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
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

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white70, size: 80.r),
            SizedBox(width: 32.w),
            Text(
              '将二维码放入框内扫描',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 60.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colours.app_main.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 80.r),
          SizedBox(width: 32.w),
          Flexible(
            child: Text(
              value.displayValue ?? '扫描成功',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 60.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              child: _barcodePreview(_barcode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanLine(double screenHeight) {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: _scanAnimation.value * screenHeight,
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
