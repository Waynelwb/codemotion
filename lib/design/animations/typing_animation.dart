// Typing Animation
// 打字机动画组件，代码输入效果
//
// 使用示例：
// ```dart
// TypingAnimation(
//   text: 'void bubbleSort() { ... }',
//   style: GoogleFonts.firaCode(fontSize: 14),
//   cursorColor: AppColors.primary,
// )
// ```

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';
import '../visualization/code_highlight.dart';

class TypingAnimation extends StatefulWidget {
  const TypingAnimation({
    super.key,
    required this.text,
    this.style,
    this.cursorColor = AppColors.primary,
    this.cursorWidth = 2,
    this.charDuration = const Duration(milliseconds: 50),
    this.startDelay = const Duration(milliseconds: 500),
    this.showCursor = true,
    this.onComplete,
  });

  final String text;
  final TextStyle? style;
  final Color cursorColor;
  final double cursorWidth;
  final Duration charDuration;
  final Duration startDelay;
  final bool showCursor;
  final VoidCallback? onComplete;

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  int _displayedCharCount = 0;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();

    // 光标闪烁控制器
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);

    // 延迟后开始打字
    Future.delayed(widget.startDelay, () {
      if (mounted) {
        _typeNextChar();
      }
    });
  }

  void _typeNextChar() {
    if (_displayedCharCount < widget.text.length) {
      Future.delayed(widget.charDuration, () {
        if (mounted) {
          setState(() => _displayedCharCount++);
          _typeNextChar();
        }
      });
    } else {
      setState(() => _animationComplete = true);
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _displayedCharCount);
    final defaultStyle = GoogleFonts.firaCode(
      fontSize: 14,
      color: AppColors.textPrimary,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayText,
          style: widget.style ?? defaultStyle,
        ),
        if (widget.showCursor)
          _Cursor(
            controller: _cursorController,
            color: widget.cursorColor,
            width: widget.cursorWidth,
            visible: !_animationComplete || _cursorController.value < 0.5,
          ),
      ],
    );
  }
}

class _Cursor extends StatelessWidget {
  const _Cursor({
    required AnimationController controller,
    required this.color,
    required this.width,
    required this.visible,
  })  : _controller = controller;

  final AnimationController _controller;
  final Color color;
  final double width;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: visible ? 1.0 : _controller.value,
          child: Container(
            width: width,
            height: 20,
            margin: const EdgeInsets.only(left: 2),
            color: color,
          ),
        );
      },
    );
  }
}

/// 多行打字机动画
class MultiLineTypingAnimation extends StatefulWidget {
  const MultiLineTypingAnimation({
    super.key,
    required this.lines,
    this.style,
    this.cursorColor = AppColors.primary,
    this.lineDelay = const Duration(milliseconds: 300),
    this.charDuration = const Duration(milliseconds: 40),
    this.startDelay = const Duration(milliseconds: 500),
    this.showCursor = true,
    this.onComplete,
  });

  final List<String> lines;
  final TextStyle? style;
  final Color cursorColor;
  final Duration lineDelay;
  final Duration charDuration;
  final Duration startDelay;
  final bool showCursor;
  final VoidCallback? onComplete;

  @override
  State<MultiLineTypingAnimation> createState() =>
      _MultiLineTypingAnimationState();
}

class _MultiLineTypingAnimationState extends State<MultiLineTypingAnimation>
    with TickerProviderStateMixin {
  int _currentLine = 0;
  int _displayedCharCount = 0;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.startDelay, () {
      if (mounted) {
        _typeNextChar();
      }
    });
  }

  void _typeNextChar() {
    if (_currentLine < widget.lines.length) {
      final currentLineText = widget.lines[_currentLine];
      if (_displayedCharCount < currentLineText.length) {
        Future.delayed(widget.charDuration, () {
          if (mounted) {
            setState(() => _displayedCharCount++);
            _typeNextChar();
          }
        });
      } else {
        // 当前行完成，移动到下一行
        Future.delayed(widget.lineDelay, () {
          if (mounted) {
            setState(() {
              _currentLine++;
              _displayedCharCount = 0;
            });
            if (_currentLine < widget.lines.length) {
              _typeNextChar();
            } else {
              setState(() => _animationComplete = true);
              widget.onComplete?.call();
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.firaCode(
      fontSize: 14,
      color: AppColors.textPrimary,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.lines.length, (index) {
        String displayText = '';
        bool isCurrentLine = index == _currentLine;
        bool isCompletedLine = index < _currentLine;

        if (isCompletedLine) {
          displayText = widget.lines[index];
        } else if (isCurrentLine) {
          displayText = widget.lines[index].substring(0, _displayedCharCount);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayText,
              style: widget.style ?? defaultStyle,
            ),
            if (widget.showCursor && isCurrentLine && !_animationComplete)
              _Cursor(
                controller: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 530),
                )..repeat(reverse: true),
                color: widget.cursorColor,
                width: 2,
                visible: true,
              ),
          ],
        );
      }),
    );
  }
}

/// 带语法高亮的打字机动画
class SyntaxTypingAnimation extends StatefulWidget {
  const SyntaxTypingAnimation({
    super.key,
    required this.code,
    this.fontSize = 14,
    this.cursorColor = AppColors.primary,
    this.charDuration = const Duration(milliseconds: 30),
    this.startDelay = const Duration(milliseconds: 500),
  });

  final String code;
  final double fontSize;
  final Color cursorColor;
  final Duration charDuration;
  final Duration startDelay;

  @override
  State<SyntaxTypingAnimation> createState() => _SyntaxTypingAnimationState();
}

class _SyntaxTypingAnimationState extends State<SyntaxTypingAnimation> {
  int _displayedCharCount = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.startDelay, () {
      if (mounted) {
        _typeNextChar();
      }
    });
  }

  void _typeNextChar() {
    if (_displayedCharCount < widget.code.length) {
      Future.delayed(widget.charDuration, () {
        if (mounted) {
          setState(() => _displayedCharCount++);
          _typeNextChar();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayCode = widget.code.substring(0, _displayedCharCount);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.codeBlock(),
      child: SingleChildScrollView(
        child: _SyntaxHighlightedCode(
          code: displayCode,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}

class _SyntaxHighlightedCode extends StatelessWidget {
  const _SyntaxHighlightedCode({
    required this.code,
    required this.fontSize,
  });

  final String code;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // 使用 CodeHighlight 组件进行语法高亮
    return CodeHighlight(
      code: code,
      language: 'cpp',
      fontSize: fontSize,
      showLineNumbers: false,
    );
  }
}
