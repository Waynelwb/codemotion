// App Router - Route configuration for CodeMotion
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design/design_system.dart';
import 'main.dart' show HomePage;
import 'pages/course_list_page.dart';
import 'pages/visualization_page.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String courses = '/courses';
  static const String visualize = '/visualize';
}

/// Simple router delegate implementation
class AppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _currentPath = AppRoutes.home;

  String get currentPath => _currentPath;

  @override
  String? get currentConfiguration => _currentPath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        if (_currentPath != AppRoutes.home) {
          _currentPath = AppRoutes.home;
          notifyListeners();
        }
      },
    );
  }

  List<Page<dynamic>> _buildPages() {
    return [
      MaterialPage<void>(
        key: const ValueKey('home'),
        child: const HomePage(),
      ),
      if (_currentPath == AppRoutes.courses)
        MaterialPage<void>(
          key: const ValueKey('courses'),
          child: const CourseListPage(),
        ),
      if (_currentPath == AppRoutes.visualize)
        MaterialPage<void>(
          key: const ValueKey('visualize'),
          child: const VisualizationPage(),
        ),
    ];
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _currentPath = configuration;
    notifyListeners();
  }

  void navigateTo(String path, {bool useHeroTransition = false}) {
    HapticFeedback.selectionClick();
    _currentPath = path;
    notifyListeners();
  }

  void navigateToHome() => navigateTo(AppRoutes.home);
  void navigateToCourses() =>
      navigateTo(AppRoutes.courses, useHeroTransition: true);
  void navigateToVisualize() =>
      navigateTo(AppRoutes.visualize, useHeroTransition: true);
}

/// Global router instance accessor
AppRouterDelegate get globalRouter {
  return _globalRouter!;
}

AppRouterDelegate? _globalRouter;

void setGlobalRouter(AppRouterDelegate router) {
  _globalRouter = router;
}

/// Route information parser
class AppRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation.uri.path;
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}

// ============================================================================
// Page Transition Utilities
// ============================================================================

class PageTransitions {
  PageTransitions._();

  static Widget fadeSlide({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
  }) {
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
  }

  static Widget scaleFade({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }

  static Widget slideUp({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: FadeTransition(
        opacity: curvedAnimation,
        child: child,
      ),
    );
  }
}

// ============================================================================
// Skeleton Loading
// ============================================================================

class SkeletonLoading extends StatefulWidget {
  const SkeletonLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: const [
                Color(0xFF1A1A24),
                Color(0xFF2A2A34),
                Color(0xFF1A1A24),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// Loading Button
// ============================================================================

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final String? loadingText;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinnerController;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void didUpdateWidget(LoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _spinnerController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _spinnerController.stop();
    }
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.surfaceElevated : AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading) ...[
              RotationTransition(
                turns: _spinnerController,
                child: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
              if (widget.loadingText != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.loadingText!,
                  style: AppFonts.labelLarge(color: Colors.white),
                ),
              ],
            ] else ...[
              widget.child,
            ],
          ],
        ),
      ),
    );
  }
}
