import 'package:flutter/material.dart';

class ThemeColor {
  final String name;
  final Color color;
  final String key;

  const ThemeColor({
    required this.name,
    required this.color,
    required this.key,
  });

  static const List<ThemeColor> presetColors = [
    ThemeColor(
      name: '活力绿',
      color: Color(0xFF4CAF50),
      key: 'green',
    ),
    ThemeColor(
      name: '清新蓝',
      color: Color(0xFF2196F3),
      key: 'blue',
    ),
    ThemeColor(
      name: '热情红',
      color: Color(0xFFF44336),
      key: 'red',
    ),
    ThemeColor(
      name: '温暖橙',
      color: Color(0xFFFF9800),
      key: 'orange',
    ),
    ThemeColor(
      name: '浪漫紫',
      color: Color(0xFF9C27B0),
      key: 'purple',
    ),
    ThemeColor(
      name: '少女粉',
      color: Color(0xFFE91E63),
      key: 'pink',
    ),
    ThemeColor(
      name: '钛金灰',
      color: Color(0xFF607D8B),
      key: 'grey',
    ),
    ThemeColor(
      name: '极夜黑',
      color: Color(0xFF1A1A1A),
      key: 'black',
    ),
  ];

  static ThemeColor fromKey(String key) {
    return presetColors.firstWhere(
      (e) => e.key == key,
      orElse: () => presetColors.first,
    );
  }
}
