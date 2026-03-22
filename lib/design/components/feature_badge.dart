// Feature Badge Component
// 特性标签组件，渐变背景的小标签
//
// 使用示例：
// ```dart
// FeatureBadge(
//   label: '新手推荐',
//   icon: Icons.star,
// )
// FeatureBadge(
//   label: '热门',
//   variant: BadgeVariant.warning,
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

enum BadgeVariant {
  primary,
  success,
  warning,
  error,
  info,
  purple,
}

class FeatureBadge extends StatelessWidget {
  const FeatureBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.medium,
  });

  final String label;
  final IconData? icon;
  final BadgeVariant variant;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: _iconSize, color: _textColor),
            SizedBox(width: _iconSpacing),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets get _padding {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  double get _borderRadius {
    switch (size) {
      case BadgeSize.small:
        return 4;
      case BadgeSize.medium:
        return 6;
      case BadgeSize.large:
        return 8;
    }
  }

  double get _fontSize {
    switch (size) {
      case BadgeSize.small:
        return 10;
      case BadgeSize.medium:
        return 12;
      case BadgeSize.large:
        return 14;
    }
  }

  double get _iconSize {
    switch (size) {
      case BadgeSize.small:
        return 10;
      case BadgeSize.medium:
        return 12;
      case BadgeSize.large:
        return 14;
    }
  }

  double get _iconSpacing {
    switch (size) {
      case BadgeSize.small:
        return 3;
      case BadgeSize.medium:
        return 4;
      case BadgeSize.large:
        return 5;
    }
  }

  LinearGradient get _gradient {
    switch (variant) {
      case BadgeVariant.primary:
        return LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        );
      case BadgeVariant.success:
        return LinearGradient(
          colors: [
            AppColors.success,
            AppColors.success.withValues(alpha: 0.8),
          ],
        );
      case BadgeVariant.warning:
        return LinearGradient(
          colors: [
            AppColors.warning,
            AppColors.warning.withValues(alpha: 0.8),
          ],
        );
      case BadgeVariant.error:
        return LinearGradient(
          colors: [
            AppColors.error,
            AppColors.error.withValues(alpha: 0.8),
          ],
        );
      case BadgeVariant.info:
        return LinearGradient(
          colors: [
            AppColors.info,
            AppColors.info.withValues(alpha: 0.8),
          ],
        );
      case BadgeVariant.purple:
        return LinearGradient(
          colors: [
            AppColors.syntaxKeyword,
            AppColors.tertiary,
          ],
        );
    }
  }

  Color get _textColor => Colors.white;

  Color get _shadowColor {
    switch (variant) {
      case BadgeVariant.primary:
        return AppColors.primary.withValues(alpha: 0.3);
      case BadgeVariant.success:
        return AppColors.success.withValues(alpha: 0.3);
      case BadgeVariant.warning:
        return AppColors.warning.withValues(alpha: 0.3);
      case BadgeVariant.error:
        return AppColors.error.withValues(alpha: 0.3);
      case BadgeVariant.info:
        return AppColors.info.withValues(alpha: 0.3);
      case BadgeVariant.purple:
        return AppColors.syntaxKeyword.withValues(alpha: 0.3);
    }
  }
}

enum BadgeSize {
  small,
  medium,
  large,
}

/// 胶囊形状的标签（无渐变）
class CapsuleBadge extends StatelessWidget {
  const CapsuleBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (backgroundColor ?? AppColors.primary).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: textColor ?? AppColors.primary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppFonts.labelMedium(
              color: textColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
