// Learning Path Step Component
// 学习路径步骤组件，带序号、内容和连接线
//
// 使用示例：
// ```dart
// LearningPathStep(
//   stepNumber: 1,
//   title: '变量与数据类型',
//   description: '学习基本变量类型和声明方式',
//   isActive: true,
//   isCompleted: false,
// ),
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

class LearningPathStep extends StatelessWidget {
  const LearningPathStep({
    super.key,
    required this.stepNumber,
    required this.title,
    this.description,
    this.isActive = false,
    this.isCompleted = false,
    this.isLast = false,
    this.onTap,
  });

  final int stepNumber;
  final String title;
  final String? description;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIndicator(),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          _StepCircle(
            stepNumber: stepNumber,
            isActive: isActive,
            isCompleted: isCompleted,
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [AppColors.success, AppColors.success],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : LinearGradient(
                          colors: [
                            isActive
                                ? AppColors.primary
                                : AppColors.border,
                            AppColors.border,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.cardBackground,
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
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
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description!,
                style: AppFonts.bodyMedium(color: AppColors.textTertiary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.stepNumber,
    this.isActive = false,
    this.isCompleted = false,
  });

  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Widget? child;

    if (isCompleted) {
      backgroundColor = AppColors.success;
      borderColor = AppColors.success;
      textColor = AppColors.background;
      child = const Icon(Icons.check, size: 16, color: Colors.white);
    } else if (isActive) {
      backgroundColor = AppColors.primary;
      borderColor = AppColors.primary;
      textColor = Colors.white;
      child = null;
    } else {
      backgroundColor = Colors.transparent;
      borderColor = AppColors.border;
      textColor = AppColors.textTertiary;
      child = null;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: child ??
            Text(
              '$stepNumber',
              style: AppFonts.labelLarge(color: textColor),
            ),
      ),
    );
  }
}

/// 水平布局的学习路径步骤
class HorizontalLearningStep extends StatelessWidget {
  const HorizontalLearningStep({
    super.key,
    required this.stepNumber,
    required this.title,
    this.description,
    this.isActive = false,
    this.isCompleted = false,
    this.onTap,
  });

  final int stepNumber;
  final String title;
  final String? description;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.cardBackground,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.4)
                : isCompleted
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.border,
          ),
          boxShadow: isActive ? AppShadows.card(glowColor: AppColors.primary) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _HorizontalStepIndicator(
                  stepNumber: stepNumber,
                  isActive: isActive,
                  isCompleted: isCompleted,
                ),
                const Spacer(),
                if (isCompleted)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppFonts.titleMedium(
                color: isActive || isCompleted
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description!,
                style: AppFonts.bodySmall(color: AppColors.textTertiary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HorizontalStepIndicator extends StatelessWidget {
  const _HorizontalStepIndicator({
    required this.stepNumber,
    this.isActive = false,
    this.isCompleted = false,
  });

  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (isCompleted) {
      backgroundColor = AppColors.success;
      textColor = Colors.white;
    } else if (isActive) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
    } else {
      backgroundColor = AppColors.border;
      textColor = AppColors.textTertiary;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: AppFonts.labelLarge(color: textColor),
        ),
      ),
    );
  }
}
