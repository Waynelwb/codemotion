// Step Indicator Component
// 步骤指示器组件，显示当前步骤/总步骤
//
// 使用示例：
// ```dart
// StepIndicator(
//   currentStep: 3,
//   totalSteps: 10,
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 6,
    this.showLabel = true,
    this.labelFormat = StepLabelFormat.fraction,
  });

  final int currentStep;
  final int totalSteps;
  final double height;
  final bool showLabel;
  final StepLabelFormat labelFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          _buildLabel(),
          const SizedBox(height: AppSpacing.xs),
        ],
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildLabel() {
    String text;
    switch (labelFormat) {
      case StepLabelFormat.fraction:
        text = '步骤 $currentStep / $totalSteps';
        break;
      case StepLabelFormat.percentage:
        text = '${((currentStep / totalSteps) * 100).toInt()}%';
        break;
      case StepLabelFormat.stepOnly:
        text = '第 $currentStep 步';
        break;
      case StepLabelFormat.remaining:
        text = '剩余 ${totalSteps - currentStep} 步';
        break;
    }

    return Text(
      text,
      style: AppFonts.labelMedium(color: AppColors.textSecondary),
    );
  }

  Widget _buildProgressBar() {
    final progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // 背景轨道
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // 进度填充
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: height,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

enum StepLabelFormat {
  fraction,    // "步骤 3 / 10"
  percentage,  // "30%"
  stepOnly,    // "第 3 步"
  remaining,   // "剩余 7 步"
}

/// 圆形步骤指示器（用于算法选择等场景）
class CircleStepIndicator extends StatelessWidget {
  const CircleStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.size = 48,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.border,
  });

  final int currentStep;
  final int totalSteps;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final step = index + 1;
        final isActive = step == currentStep;
        final isCompleted = step < currentStep;

        return Row(
          children: [
            _CircleStep(
              step: step,
              isActive: isActive,
              isCompleted: isCompleted,
              size: size,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            if (index < totalSteps - 1)
              Container(
                width: 24,
                height: 2,
                color: isCompleted ? activeColor : inactiveColor,
              ),
          ],
        );
      }),
    );
  }
}

class _CircleStep extends StatelessWidget {
  const _CircleStep({
    required this.step,
    required this.isActive,
    required this.isCompleted,
    required this.size,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int step;
  final bool isActive;
  final bool isCompleted;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isCompleted) {
      backgroundColor = activeColor;
      textColor = Colors.white;
      borderColor = activeColor;
    } else if (isActive) {
      backgroundColor = activeColor.withValues(alpha: 0.2);
      textColor = activeColor;
      borderColor = activeColor;
    } else {
      backgroundColor = Colors.transparent;
      textColor = AppColors.textTertiary;
      borderColor = inactiveColor;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, size: size * 0.4, color: textColor)
            : Text(
                '$step',
                style: AppFonts.labelLarge(color: textColor),
              ),
      ),
    );
  }
}
