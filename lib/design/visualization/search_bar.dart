// Search Bar Component
// 搜索可视化条状图组件
//
// 使用示例：
// ```dart
// SearchBarChart(
//   values: [1, 3, 5, 7, 9],
//   states: [...],
//   target: 7,
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';
import '../../content/algorithms/searching.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.value,
    required this.maxValue,
    this.state = SearchBarState.defaultState,
    this.label,
    this.width = 40,
    this.showLabel = true,
    this.isLeftPointer = false,
    this.isRightPointer = false,
    this.isMidPointer = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final int value;
  final int maxValue;
  final SearchBarState state;
  final String? label;
  final double width;
  final bool showLabel;
  final bool isLeftPointer;
  final bool isRightPointer;
  final bool isMidPointer;
  final Duration animationDuration;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  SearchBarState? _previousState;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce animation when found state is reached
    if (widget.state == SearchBarState.found &&
        _previousState != SearchBarState.found) {
      _bounceController.forward(from: 0);
    }
    _previousState = widget.state;
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightFraction = widget.value / widget.maxValue;
    final barColor = _getBarColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final labelHeight = (widget.showLabel && widget.label != null) ? 24.0 : 0.0;
        final availableHeight = constraints.maxHeight - labelHeight;
        final barHeight = (heightFraction * availableHeight.clamp(10.0, 180.0) + 10)
            .clamp(10.0, availableHeight > 0 ? availableHeight : 210.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pointer indicators
            if (widget.isLeftPointer || widget.isRightPointer || widget.isMidPointer)
              _buildPointerIndicator(),
            if (widget.showLabel && widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  widget.label!,
                  style: AppFonts.codeSmall(
                    color: _getLabelColor(),
                  ),
                ),
              ),
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.state == SearchBarState.found
                      ? _bounceAnimation.value
                      : 1.0,
                  child: AnimatedContainer(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    width: widget.width,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      boxShadow: widget.state == SearchBarState.comparing ||
                              widget.state == SearchBarState.current
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
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPointerIndicator() {
    String text;
    Color color;

    if (widget.isMidPointer) {
      text = 'mid';
      color = AppColors.primary;
    } else if (widget.isLeftPointer) {
      text = 'L';
      color = AppColors.success;
    } else {
      text = 'R';
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getLabelColor() {
    switch (widget.state) {
      case SearchBarState.defaultState:
        return AppColors.textSecondary;
      case SearchBarState.comparing:
        return AppColors.vizComparing;
      case SearchBarState.current:
        return AppColors.primary;
      case SearchBarState.eliminated:
        return AppColors.textDisabled;
      case SearchBarState.found:
        return AppColors.vizSorted;
      case SearchBarState.leftPointer:
        return AppColors.success;
      case SearchBarState.rightPointer:
        return AppColors.warning;
      case SearchBarState.midPointer:
        return AppColors.primary;
    }
  }

  Color _getBarColor() {
    switch (widget.state) {
      case SearchBarState.defaultState:
        return AppColors.vizDefault;
      case SearchBarState.comparing:
        return AppColors.vizComparing;
      case SearchBarState.current:
        return AppColors.primary;
      case SearchBarState.eliminated:
        return AppColors.textDisabled.withValues(alpha: 0.4);
      case SearchBarState.found:
        return AppColors.vizSorted;
      case SearchBarState.leftPointer:
        return AppColors.success.withValues(alpha: 0.7);
      case SearchBarState.rightPointer:
        return AppColors.warning.withValues(alpha: 0.7);
      case SearchBarState.midPointer:
        return AppColors.primary;
    }
  }
}

class SearchBarChart extends StatelessWidget {
  const SearchBarChart({
    super.key,
    required this.values,
    this.barStates = const [],
    this.maxValue,
    this.barWidth = 44,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.leftIndex,
    this.rightIndex,
    this.midIndex,
  });

  final List<int> values;
  final List<SearchBarState> barStates;
  final int? maxValue;
  final double barWidth;
  final bool showLabels;
  final Duration animationDuration;
  final int? leftIndex;
  final int? rightIndex;
  final int? midIndex;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxValue = maxValue ?? values.reduce((a, b) => a > b ? a : b);
    final effectiveStates = barStates.isEmpty
        ? List.filled(values.length, SearchBarState.defaultState)
        : barStates;

    const barSpacing = 4.0;
    final totalBarsWidth = values.length * barWidth + (values.length - 1) * barSpacing;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.codeBlock(),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final horizontalPadding = availableWidth > totalBarsWidth
              ? (availableWidth - totalBarsWidth) / 2
              : 0.0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left: horizontalPadding.clamp(0.0, double.infinity)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : barSpacing,
                      right: index == values.length - 1 ? 0 : 0,
                    ),
                    child: SearchBar(
                      value: values[index],
                      maxValue: effectiveMaxValue,
                      state: effectiveStates[index],
                      label: '${values[index]}',
                      width: barWidth,
                      showLabel: showLabels,
                      isLeftPointer: index == leftIndex,
                      isRightPointer: index == rightIndex,
                      isMidPointer: index == midIndex,
                      animationDuration: animationDuration,
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Search visualization legend
class SearchLegend extends StatelessWidget {
  const SearchLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isMobile ? 12 : 24,
      runSpacing: isMobile ? 8 : 0,
      children: [
        _legendItem(AppColors.vizDefault, '默认'),
        _legendItem(AppColors.vizComparing, '比较中'),
        _legendItem(AppColors.primary, '当前'),
        _legendItem(AppColors.success, '左指针'),
        _legendItem(AppColors.warning, '右指针'),
        _legendItem(AppColors.textDisabled.withValues(alpha: 0.4), '已排除'),
        _legendItem(AppColors.vizSorted, '已找到'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppFonts.labelMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
