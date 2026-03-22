// App Router - Simple Navigation Shell for CodeMotion
//
// 使用 setState + IndexedStack 管理页面切换，稳定可靠。
// 不依赖 RouterDelegate，避免 Flutter web 上的兼容性问题。
//
// 页面切换：通过 Navigator.push/pop 实现（支持过渡动画）
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart' show HomePage;
import 'pages/course_list_page.dart';
import 'pages/course_detail_page.dart';
import 'pages/visualization_page.dart';

/// 页面路由名称
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String courses = '/courses';
  static const String courseDetail = '/course';
  static const String visualize = '/visualize';
}

/// 导航状态管理（单例，全局可访问）
class AppNavigator extends ChangeNotifier {
  AppNavigator._();
  static final AppNavigator instance = AppNavigator._();

  // 当前路由路径
  String _currentPath = AppRoutes.home;

  // course_detail 页面需要传递 courseId
  String? _currentCourseId;

  String get currentPath => _currentPath;
  String? get currentCourseId => _currentCourseId;

  bool isAtHome() => _currentPath == AppRoutes.home;
  bool isAtCourses() => _currentPath == AppRoutes.courses;
  bool isAtVisualize() => _currentPath == AppRoutes.visualize;
  bool isAtCourseDetail() => _currentPath == AppRoutes.courseDetail;

  void navigateTo(String path) {
    HapticFeedback.selectionClick();
    _currentPath = path;
    _currentCourseId = null;
    if (path.startsWith(AppRoutes.courseDetail)) {
      // courseId 从 path 中解析：/course/basics_variables
      final segments = Uri.parse(path).pathSegments;
      if (segments.length >= 2) {
        _currentCourseId = segments[1];
      }
    }
    notifyListeners();
  }

  void navigateToHome() => navigateTo(AppRoutes.home);
  void navigateToCourses() => navigateTo(AppRoutes.courses);
  void navigateToVisualize() => navigateTo(AppRoutes.visualize);
  void navigateToCourseDetail(String courseId) =>
      navigateTo('${AppRoutes.courseDetail}/$courseId');
}

/// 全局导航器访问
AppNavigator get globalNavigator => AppNavigator.instance;

/// 路由信息解析器（兼容 MaterialApp.router）
class AppRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) async {
    return routeInformation.uri.path;
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}

/// 路由委托（兼容 MaterialApp.router，但核心导航逻辑在 AppNavigator）
class AppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppNavigator _appNavigator;

  AppRouterDelegate(this._appNavigator) {
    _appNavigator.addListener(_onNavChanged);
  }

  void _onNavChanged() {
    notifyListeners();
  }

  @override
  String? get currentConfiguration => _appNavigator.currentPath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        _appNavigator.navigateToHome();
      },
    );
  }

  List<Page<dynamic>> _buildPages() {
    final pages = <Page<dynamic>>[
      const MaterialPage<void>(
        key: ValueKey('home'),
        name: '/',
        child: HomePage(),
      ),
    ];

    final path = _appNavigator.currentPath;
    if (path == AppRoutes.courses) {
      pages.add(
        _FadeSlidePage<void>(
          key: const ValueKey('courses'),
          name: '/courses',
          child: const CourseListPage(),
        ),
      );
    } else if (path == AppRoutes.visualize) {
      pages.add(
        _FadeSlidePage<void>(
          key: const ValueKey('visualize'),
          name: '/visualize',
          child: const VisualizationPage(),
        ),
      );
    } else if (path.startsWith(AppRoutes.courseDetail) &&
        _appNavigator.currentCourseId != null) {
      pages.add(
        _FadeSlidePage<void>(
          key: ValueKey('course_${_appNavigator.currentCourseId}'),
          name: '/course/${_appNavigator.currentCourseId}',
          child: CourseDetailPage(courseId: _appNavigator.currentCourseId!),
        ),
      );
    }

    return pages;
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _appNavigator.navigateTo(configuration);
  }
}

/// 自定义 Page：淡入+滑动过渡
class _FadeSlidePage<T> extends Page<T> {
  final Widget child;

  const _FadeSlidePage({
    required this.child,
    super.key,
    super.name,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }
}
