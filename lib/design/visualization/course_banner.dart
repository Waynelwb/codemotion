// Animated Course Banner Widget
// 带 shimmer 渐变动画的关联课程 Banner 组件

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design/design_system.dart';

/// Animated course banner with shimmer gradient effect and hover glow
class AnimatedCourseBanner extends StatefulWidget {
  const AnimatedCourseBanner({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseIcon,
    required this.heroTag,
    required this.onTap,
    this.padding = 20.0,
    this.isMobile = false,
  });

  final String courseId;
  final String courseName;
  final IconData courseIcon;
  final String heroTag;
  final VoidCallback onTap;
  final double padding;
  final bool isMobile;

  @override
  State<AnimatedCourseBanner> createState() => _AnimatedCourseBannerState();
}

class _AnimatedCourseBannerState extends State<AnimatedCourseBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _shimmerAnimation = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.warning.withValues(alpha: 0.55)
                  : AppColors.border.withValues(alpha: 0.4),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.warning.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment(_shimmerAnimation.value - 1, 0),
                    end: Alignment(_shimmerAnimation.value, 0),
                    colors: [
                      AppColors.surfaceElevated.withValues(alpha: _isHovered ? 0.8 : 0.5),
                      AppColors.surfaceElevated.withValues(alpha: _isHovered ? 0.95 : 0.65),
                      AppColors.warning.withValues(alpha: _isHovered ? 0.12 : 0.06),
                      AppColors.surfaceElevated.withValues(alpha: _isHovered ? 0.95 : 0.65),
                      AppColors.surfaceElevated.withValues(alpha: _isHovered ? 0.8 : 0.5),
                    ],
                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                  ),
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.courseIcon, color: AppColors.warning, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '关联课程',
                        style: AppFonts.labelMedium(color: AppColors.textTertiary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.courseName,
                        style: AppFonts.labelLarge(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                _buildViewButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isHovered
            ? AppColors.warning.withValues(alpha: 0.2)
            : AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: _isHovered ? 0.5 : 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '查看课程',
            style: AppFonts.labelMedium(
              color: _isHovered
                  ? AppColors.warning
                  : AppColors.warning.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 4),
          AnimatedRotation(
            turns: _isHovered ? 0.05 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.warning,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
