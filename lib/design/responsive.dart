// Responsive Design Helpers
// 提供响应式布局的辅助工具，避免在每个页面重复写 MediaQuery/LayoutBuilder

import 'package:flutter/material.dart';

/// 响应式断点
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

/// 响应式尺寸
class Responsive {
  Responsive._();

  /// 当前屏幕宽度
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// 当前屏幕高度
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// 是否为移动端（< 600）
  static bool isMobile(BuildContext context) =>
      screenWidth(context) < ResponsiveBreakpoints.mobile;

  /// 是否为平板端（600 - 1024）
  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= ResponsiveBreakpoints.mobile &&
      screenWidth(context) < ResponsiveBreakpoints.tablet;

  /// 是否为桌面端（>= 1024）
  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= ResponsiveBreakpoints.tablet;

  /// 水平内边距（响应式）
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 32;
    return 48;
  }

  /// 垂直内边距（响应式）
  static double verticalPadding(BuildContext context) {
    if (isMobile(context)) return 40;
    if (isTablet(context)) return 60;
    return 80;
  }

  /// Hero 标题字号
  static double heroTitleSize(BuildContext context) {
    if (isMobile(context)) return 36;
    if (isTablet(context)) return 56;
    return 72;
  }

  /// 区块标题字号
  static double sectionTitleSize(BuildContext context) {
    if (isMobile(context)) return 28;
    if (isTablet(context)) return 32;
    return 36;
  }

  /// 栅格列数（Features / 课程卡片）
  static int gridCrossAxisCount(BuildContext context, {int desktopCols = 4}) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return desktopCols;
  }

  /// 学习路径列数
  static int pathStageCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 4;
  }

  /// 学习路径卡片宽度
  static double pathCardWidth(BuildContext context) {
    if (isMobile(context)) return screenWidth(context) - horizontalPadding(context) * 2;
    if (isTablet(context)) return (screenWidth(context) - horizontalPadding(context) * 2 - 12) / 2;
    return 200;
  }

  /// Feature 卡片宽度
  static double featureCardWidth(BuildContext context) {
    final availableWidth = screenWidth(context) - horizontalPadding(context) * 2;
    final cols = gridCrossAxisCount(context);
    final totalSpacing = 12.0 * (cols - 1);
    return (availableWidth - totalSpacing) / cols;
  }

  /// 课程卡片高度
  static double courseCardHeight(BuildContext context) {
    if (isMobile(context)) return 180;
    return 200;
  }

  /// 课程网格最大宽度
  static double courseGridMaxWidth(BuildContext context) {
    return screenWidth(context) - horizontalPadding(context) * 2;
  }
}

/// 响应式 Scaffold（自动处理移动端 Drawer）
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.navItems,
    this.selectedIndex = 0,
    this.onNavTap,
    this.title,
  });

  final Widget body;
  final List<String>? navItems;
  final int selectedIndex;
  final ValueChanged<int>? onNavTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile && navItems != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0F),
          elevation: 0,
          title: Text(
            title ?? 'CodeMotion',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.code, color: Colors.white, size: 24),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xFF12121A),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF0A0A0F)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.code, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CodeMotion',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ...List.generate(navItems!.length, (index) {
                final isActive = index == selectedIndex;
                return ListTile(
                  leading: Icon(
                    _getNavIcon(index),
                    color: isActive ? const Color(0xFF6366F1) : Colors.white60,
                  ),
                  title: Text(
                    navItems![index],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onNavTap?.call(index);
                  },
                );
              }),
            ],
          ),
        ),
        body: body,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: body,
    );
  }

  IconData _getNavIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.school;
      case 2:
        return Icons.play_circle;
      default:
        return Icons.info;
    }
  }
}
