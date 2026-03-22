// Section Header Component
// 章节标题组件，带装饰线的标题样式
//
// 使用示例：
// ```dart
// SectionHeader(
//   title: '第一章：基础语法',
//   subtitle: '变量、数据类型与控制流',
//   decoration: SectionDecoration.gradient,
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

enum SectionDecoration {
  none,
  line,
  gradient,
  bullet,
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.decoration = SectionDecoration.gradient,
    this.alignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String? subtitle;
  final SectionDecoration decoration;
  final CrossAxisAlignment alignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        _buildDecoration(),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildSubtitle(),
        ],
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: titleStyle ?? AppFonts.headlineMedium(),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle!,
      style: subtitleStyle ?? AppFonts.bodyMedium(color: AppColors.textSecondary),
    );
  }

  Widget _buildDecoration() {
    switch (decoration) {
      case SectionDecoration.none:
        return _buildTitle();
      case SectionDecoration.line:
        return _WithLineDecoration(
          title: title,
          titleStyle: titleStyle,
        );
      case SectionDecoration.gradient:
        return _WithGradientDecoration(
          title: title,
          titleStyle: titleStyle,
        );
      case SectionDecoration.bullet:
        return _WithBulletDecoration(
          title: title,
          titleStyle: titleStyle,
        );
    }
  }
}

class _WithLineDecoration extends StatelessWidget {
  const _WithLineDecoration({
    required this.title,
    this.titleStyle,
  });

  final String title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: titleStyle ?? AppFonts.headlineMedium(),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.5),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WithGradientDecoration extends StatelessWidget {
  const _WithGradientDecoration({
    required this.title,
    this.titleStyle,
  });

  final String title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppRadius.borderXs,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: titleStyle ?? AppFonts.headlineMedium(),
        ),
      ],
    );
  }
}

class _WithBulletDecoration extends StatelessWidget {
  const _WithBulletDecoration({
    required this.title,
    this.titleStyle,
  });

  final String title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: titleStyle ?? AppFonts.headlineMedium(),
        ),
      ],
    );
  }
}

/// 步骤指示器样式的 Section Header
class StepSectionHeader extends StatelessWidget {
  const StepSectionHeader({
    super.key,
    required this.step,
    required this.title,
    this.subtitle,
    this.isActive = false,
    this.isCompleted = false,
  });

  final int step;
  final String title;
  final String? subtitle;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepIndicator(
          step: step,
          isActive: isActive,
          isCompleted: isCompleted,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.titleMedium(
                  color: isActive || isCompleted
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle!,
                  style: AppFonts.bodyMedium(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.step,
    this.isActive = false,
    this.isCompleted = false,
  });

  final int step;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isCompleted) {
      backgroundColor = AppColors.success;
      textColor = AppColors.background;
      borderColor = AppColors.success;
    } else if (isActive) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.textPrimary;
      borderColor = AppColors.primary;
    } else {
      backgroundColor = Colors.transparent;
      textColor = AppColors.textTertiary;
      borderColor = AppColors.border;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, size: 16, color: textColor)
            : Text(
                '$step',
                style: AppFonts.labelLarge(color: textColor),
              ),
      ),
    );
  }
}
