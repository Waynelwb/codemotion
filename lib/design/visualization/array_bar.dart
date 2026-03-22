// Array Bar Component
// 数组柱状图组件，用于排序算法可视化
//
// 使用示例：
// ```dart
// ArrayBar(
//   value: 42,
//   maxValue: 100,
//   state: BarState.comparing,
//   label: '42',
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

enum BarState {
  defaultState,
  comparing,
  swapping,
  sorted,
  pivot,
  highlighted,
}

class ArrayBar extends StatelessWidget {
  const ArrayBar({
    super.key,
    required this.value,
    required this.maxValue,
    this.state = BarState.defaultState,
    this.label,
    this.width = 40,
    this.showLabel = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final int value;
  final int maxValue;
  final BarState state;
  final String? label;
  final double width;
  final bool showLabel;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final heightFraction = value / maxValue;
    final barColor = _getBarColor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showLabel && label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label!,
              style: AppFonts.codeSmall(color: AppColors.textSecondary),
            ),
          ),
        AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          width: width,
          height: heightFraction * 200 + 10, // 最大高度 200
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            boxShadow: state == BarState.comparing || state == BarState.swapping
                ? [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ],
    );
  }

  Color _getBarColor() {
    switch (state) {
      case BarState.defaultState:
        return AppColors.vizDefault;
      case BarState.comparing:
        return AppColors.vizComparing;
      case BarState.swapping:
        return AppColors.vizSwapping;
      case BarState.sorted:
        return AppColors.vizSorted;
      case BarState.pivot:
        return AppColors.vizPivot;
      case BarState.highlighted:
        return AppColors.vizHighlight;
    }
  }
}

class ArrayBarChart extends StatelessWidget {
  const ArrayBarChart({
    super.key,
    required this.values,
    this.states = const [],
    this.maxValue,
    this.barWidth = 40,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final List<int> values;
  final List<BarState> states;
  final int? maxValue;
  final double barWidth;
  final bool showLabels;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxValue = maxValue ?? values.reduce((a, b) => a > b ? a : b);
    final effectiveStates = states.isEmpty
        ? List.filled(values.length, BarState.defaultState)
        : states;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.codeBlock(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 4,
              right: index == values.length - 1 ? 0 : 4,
            ),
            child: ArrayBar(
              value: values[index],
              maxValue: effectiveMaxValue,
              state: effectiveStates[index],
              label: '${values[index]}',
              width: barWidth,
              showLabel: showLabels,
              animationDuration: animationDuration,
            ),
          );
        }),
      ),
    );
  }
}

/// 带动画的数组柱状图，支持交换动画
class AnimatedArrayBarChart extends StatefulWidget {
  const AnimatedArrayBarChart({
    super.key,
    required this.values,
    this.initialStates = const [],
    this.maxValue,
    this.barWidth = 40,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final List<int> values;
  final List<BarState> initialStates;
  final int? maxValue;
  final double barWidth;
  final Duration animationDuration;

  @override
  State<AnimatedArrayBarChart> createState() => _AnimatedArrayBarChartState();
}

class _AnimatedArrayBarChartState extends State<AnimatedArrayBarChart> {
  late List<int> _currentValues;
  late List<BarState> _currentStates;

  @override
  void initState() {
    super.initState();
    _currentValues = List.from(widget.values);
    _currentStates = widget.initialStates.isEmpty
        ? List.filled(_currentValues.length, BarState.defaultState)
        : List.from(widget.initialStates);
  }

  @override
  void didUpdateWidget(AnimatedArrayBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      _currentValues = List.from(widget.values);
    }
    if (widget.initialStates != oldWidget.initialStates) {
      _currentStates = widget.initialStates.isEmpty
          ? List.filled(_currentValues.length, BarState.defaultState)
          : List.from(widget.initialStates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArrayBarChart(
      values: _currentValues,
      states: _currentStates,
      maxValue: widget.maxValue,
      barWidth: widget.barWidth,
      animationDuration: widget.animationDuration,
    );
  }
}
