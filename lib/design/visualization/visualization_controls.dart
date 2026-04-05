// Visualization Controls Component
// 可视化控制栏组件，包含播放/暂停/步进/速度调节
//
// 使用示例：
// ```dart
// VisualizationControls(
//   isPlaying: false,
//   onPlay: () {},
//   onPause: () {},
//   onStepForward: () {},
//   onStepBackward: () {},
//   onReset: () {},
//   speed: 1.0,
//   onSpeedChanged: (speed) {},
// )
// ```

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system.dart';
import 'step_indicator.dart';

class VisualizationControls extends StatelessWidget {
  const VisualizationControls({
    super.key,
    required this.isPlaying,
    this.onPlay,
    this.onPause,
    this.onStepForward,
    this.onStepBackward,
    this.onReset,
    this.speed = 1.0,
    this.onSpeedChanged,
    this.showStepControls = true,
    this.showSpeedControl = true,
    this.isStepBackwardEnabled = true,
    this.isStepForwardEnabled = true,
  });

  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onStepForward;
  final VoidCallback? onStepBackward;
  final VoidCallback? onReset;
  final double speed;
  final ValueChanged<double>? onSpeedChanged;
  final bool showStepControls;
  final bool showSpeedControl;
  final bool isStepBackwardEnabled;
  final bool isStepForwardEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 重置按钮
          _ControlButton(
            icon: Icons.replay,
            tooltip: '重置',
            onTap: onReset,
          ),

          if (showStepControls) ...[
            const SizedBox(width: AppSpacing.xs),
            // 后退一步
            _ControlButton(
              icon: Icons.skip_previous,
              tooltip: '上一步',
              onTap: isStepBackwardEnabled ? onStepBackward : null,
            ),
          ],

          const SizedBox(width: AppSpacing.xs),
          // 播放/暂停
          _PlayPauseButton(
            isPlaying: isPlaying,
            onPlay: onPlay,
            onPause: onPause,
          ),

          if (showStepControls) ...[
            const SizedBox(width: AppSpacing.xs),
            // 前进一步
            _ControlButton(
              icon: Icons.skip_next,
              tooltip: '下一步',
              onTap: isStepForwardEnabled ? onStepForward : null,
            ),
          ],

          if (showSpeedControl) ...[
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 1,
              height: 24,
              color: AppColors.border,
            ),
            const SizedBox(width: AppSpacing.md),
            // 速度控制
            _SpeedControl(
              speed: speed,
              onChanged: onSpeedChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onTap != null;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap?.call();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.isActive || _isHovered
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: isEnabled
                  ? (_isHovered ? AppColors.primary : AppColors.textSecondary)
                  : AppColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatefulWidget {
  const _PlayPauseButton({
    required this.isPlaying,
    this.onPlay,
    this.onPause,
  });

  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;

  @override
  State<_PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<_PlayPauseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          if (widget.isPlaying) {
            widget.onPause?.call();
          } else {
            widget.onPlay?.call();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: _isHovered ? AppColors.primaryGradient : null,
            color: _isHovered ? null : AppColors.primary,
            borderRadius: BorderRadius.circular(22),
            boxShadow: widget.isPlaying || _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SpeedControl extends StatelessWidget {
  const _SpeedControl({
    required this.speed,
    this.onChanged,
  });

  final double speed;
  final ValueChanged<double>? onChanged;

  static const _speedOptions = [0.25, 0.5, 1.0, 1.5, 2.0];
  static const _speedLabels = ['0.25x', '0.5x', '1x', '1.5x', '2x'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.speed,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xs),
        ...List.generate(_speedOptions.length, (index) {
          final option = _speedOptions[index];
          final isSelected = (speed - option).abs() < 0.01;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _SpeedOption(
              label: _speedLabels[index],
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged?.call(option);
              },
            ),
          );
        }),
      ],
    );
  }
}

class _SpeedOption extends StatefulWidget {
  const _SpeedOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SpeedOption> createState() => _SpeedOptionState();
}

class _SpeedOptionState extends State<_SpeedOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : _isHovered
                    ? AppColors.border
                    : Colors.transparent,
            borderRadius: AppRadius.borderXs,
            border: widget.isSelected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
                : null,
          ),
          child: Text(
            widget.label,
            style: AppFonts.labelMedium(
              color: widget.isSelected
                  ? AppColors.primary
                  : _isHovered
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

/// 完整的可视化控制面板（包含所有控制选项）
class VisualizationControlPanel extends StatelessWidget {
  const VisualizationControlPanel({
    super.key,
    required this.isPlaying,
    required this.currentStep,
    required this.totalSteps,
    this.onPlay,
    this.onPause,
    this.onStepForward,
    this.onStepBackward,
    this.onReset,
    this.speed = 1.0,
    this.onSpeedChanged,
    this.stepDescription,
  });

  final bool isPlaying;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onStepForward;
  final VoidCallback? onStepBackward;
  final VoidCallback? onReset;
  final double speed;
  final ValueChanged<double>? onSpeedChanged;
  final String? stepDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 步骤信息
          if (stepDescription != null) ...[
            Text(
              stepDescription!,
              style: AppFonts.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // 进度条
          StepIndicator(
            currentStep: currentStep,
            totalSteps: totalSteps,
          ),

          const SizedBox(height: AppSpacing.md),

          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ControlButton(
                icon: Icons.replay,
                tooltip: '重置',
                onTap: onReset,
              ),
              const SizedBox(width: AppSpacing.xs),
              _ControlButton(
                icon: Icons.skip_previous,
                tooltip: '上一步',
                onTap: onStepBackward,
                isActive: currentStep > 1,
              ),
              const SizedBox(width: AppSpacing.sm),
              _PlayPauseButton(
                isPlaying: isPlaying,
                onPlay: onPlay,
                onPause: onPause,
              ),
              const SizedBox(width: AppSpacing.xs),
              _ControlButton(
                icon: Icons.skip_next,
                tooltip: '下一步',
                onTap: onStepForward,
                isActive: currentStep < totalSteps,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // 速度控制
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.speed,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '速度：',
                style: AppFonts.labelMedium(color: AppColors.textTertiary),
              ),
              const SizedBox(width: AppSpacing.sm),
              ..._buildSpeedOptions(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSpeedOptions() {
    const speeds = [0.25, 0.5, 1.0, 1.5, 2.0];
    const labels = ['0.25x', '0.5x', '1x', '1.5x', '2x'];

    return List.generate(speeds.length, (index) {
      final option = speeds[index];
      final isSelected = (speed - option).abs() < 0.01;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: _SpeedOption(
          label: labels[index],
          isSelected: isSelected,
          onTap: () => onSpeedChanged?.call(option),
        ),
      );
    });
  }
}
