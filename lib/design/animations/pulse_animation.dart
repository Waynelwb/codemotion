// Pulse Animation
// 脉冲动画组件，用于强调元素
//
// 使用示例：
// ```dart
// PulseAnimation(
//   child: Icon(Icons.star, color: Colors.amber),
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.scale = 1.15,
    this.opacity = 0.7,
  });

  final Widget child;
  final Duration duration;
  final double scale;
  final double opacity;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.opacity,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 脉冲扩散效果
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: widget.child,
                ),
              );
            },
          ),
          // 原始内容
          widget.child,
        ],
      ),
    );
  }
}

/// 带脉冲动画的高亮组件
class PulsingHighlight extends StatefulWidget {
  const PulsingHighlight({
    super.key,
    required this.child,
    this.color = AppColors.primary,
    this.borderRadius = 8,
  });

  final Widget child;
  final Color color;
  final double borderRadius;

  @override
  State<PulsingHighlight> createState() => _PulsingHighlightState();
}

class _PulsingHighlightState extends State<PulsingHighlight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: (1 - _controller.value) * 0.4,
                ),
                blurRadius: 12 * _controller.value,
                spreadRadius: 4 * _controller.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// 呼吸动画效果
class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// 闪烁动画
class BlinkingAnimation extends StatefulWidget {
  const BlinkingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  });

  final Widget child;
  final Duration duration;

  @override
  State<BlinkingAnimation> createState() => _BlinkingAnimationState();
}

class _BlinkingAnimationState extends State<BlinkingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }
}

/// Glowing 动画（发光效果）
class GlowingAnimation extends StatefulWidget {
  const GlowingAnimation({
    super.key,
    required this.child,
    this.color = AppColors.primary,
    this.glowRadius = 15,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color color;
  final double glowRadius;
  final Duration duration;

  @override
  State<GlowingAnimation> createState() => _GlowingAnimationState();
}

class _GlowingAnimationState extends State<GlowingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value),
                blurRadius: widget.glowRadius,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
