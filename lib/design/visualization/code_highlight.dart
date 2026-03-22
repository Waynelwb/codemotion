// Code Highlight Component
// 代码高亮器组件，高亮当前执行的代码行
//
// 使用示例：
// ```dart
// CodeHighlight(
//   code: 'void bubbleSort(vector<int>& arr) {\n  for (...) {\n    ...\n  }\n}',
//   highlightedLine: 3,
//   language: 'cpp',
// )
// ```

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

class CodeHighlight extends StatelessWidget {
  const CodeHighlight({
    super.key,
    required this.code,
    this.highlightedLine,
    this.language = 'cpp',
    this.showLineNumbers = true,
    this.fontSize = 14,
  });

  final String code;
  final int? highlightedLine;
  final String language;
  final bool showLineNumbers;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');

    return Container(
      decoration: AppDecorations.codeBlock(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers) ...[
                _LineNumbers(lines: lines, highlightedLine: highlightedLine),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: _CodeLines(
                  lines: lines,
                  highlightedLine: highlightedLine,
                  language: language,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineNumbers extends StatelessWidget {
  const _LineNumbers({
    required this.lines,
    this.highlightedLine,
  });

  final List<String> lines;
  final int? highlightedLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(lines.length, (index) {
        final lineNumber = index + 1;
        final isHighlighted = lineNumber == highlightedLine;

        return Container(
          height: 20,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          decoration: isHighlighted
              ? BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderXs,
                )
              : null,
          child: Text(
            '$lineNumber',
            style: GoogleFonts.firaCode(
              fontSize: fontSize,
              color: isHighlighted
                  ? AppColors.primary
                  : AppColors.textTertiary,
            ),
          ),
        );
      }),
    );
  }

  double get fontSize => 14;
}

class _CodeLines extends StatelessWidget {
  const _CodeLines({
    required this.lines,
    this.highlightedLine,
    required this.language,
    required this.fontSize,
  });

  final List<String> lines;
  final int? highlightedLine;
  final String language;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (index) {
        final lineNumber = index + 1;
        final isHighlighted = lineNumber == highlightedLine;

        return Container(
          height: 20,
          decoration: isHighlighted
              ? BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderXs,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                )
              : null,
          child: _HighlightedLine(
            line: lines[index],
            language: language,
            fontSize: fontSize,
          ),
        );
      }),
    );
  }
}

class _HighlightedLine extends StatelessWidget {
  const _HighlightedLine({
    required this.line,
    required this.language,
    required this.fontSize,
  });

  final String line;
  final String language;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (line.trim().isEmpty) {
      return Text(line, style: _textStyle());
    }

    final spans = _tokenizeLine(line);
    return RichText(
      text: TextSpan(
        style: _textStyle(),
        children: spans,
      ),
    );
  }

  TextStyle _textStyle() => GoogleFonts.firaCode(
        fontSize: fontSize,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  List<TextSpan> _tokenizeLine(String line) {
    // C++ 关键字
    const keywords = {
      'auto', 'break', 'case', 'char', 'const', 'continue',
      'default', 'do', 'double', 'else', 'enum', 'extern',
      'float', 'for', 'goto', 'if', 'inline', 'int', 'long',
      'register', 'return', 'short', 'signed', 'sizeof', 'static',
      'struct', 'switch', 'typedef', 'union', 'unsigned', 'void',
      'volatile', 'while', 'class', 'public', 'private', 'protected',
      'virtual', 'override', 'new', 'delete', 'this', 'nullptr',
      'true', 'false', 'template', 'typename', 'namespace', 'using',
      'try', 'catch', 'throw', 'noexcept', 'constexpr', 'decltype',
      'friend', 'mutable', 'operator', 'static_cast', 'dynamic_cast',
      'reinterpret_cast', 'const_cast', 'size_t', 'string', 'vector', 'map',
      'set', 'pair', 'list', 'deque', 'stack', 'queue', 'priority_queue',
    };

    // STL 容器和算法
    const stl = {
      'vector', 'list', 'deque', 'array', 'forward_list',
      'map', 'set', 'multimap', 'multiset',
      'unordered_map', 'unordered_set',
      'stack', 'queue', 'priority_queue',
      'sort', 'find', 'binary_search', 'lower_bound', 'upper_bound',
      'min', 'max', 'swap', 'reverse', 'unique',
    };

    final spans = <TextSpan>[];
    final words = line.split(RegExp(r'(\s+|(?=[{}();,]))'));

    for (final word in words) {
      if (word.isEmpty) continue;

      // 注释
      if (word.startsWith('//')) {
        spans.add(TextSpan(
          text: line.substring(line.indexOf('//')),
          style: _textStyle().copyWith(color: AppColors.syntaxComment),
        ));
        break;
      }

      // 字符串
      if (word.startsWith('"') || word.startsWith("'")) {
        spans.add(TextSpan(
          text: word,
          style: _textStyle().copyWith(color: AppColors.syntaxString),
        ));
        continue;
      }

      // 数字
      if (RegExp(r'^\d+\.?\d*[fFlL]?[uUlL]*$').hasMatch(word)) {
        spans.add(TextSpan(
          text: word,
          style: _textStyle().copyWith(color: AppColors.syntaxNumber),
        ));
        continue;
      }

      // 关键字
      if (keywords.contains(word)) {
        spans.add(TextSpan(
          text: word,
          style: _textStyle().copyWith(color: AppColors.syntaxKeyword),
        ));
        continue;
      }

      // STL 类型和函数
      if (stl.contains(word)) {
        spans.add(TextSpan(
          text: word,
          style: _textStyle().copyWith(color: AppColors.syntaxType),
        ));
        continue;
      }

      // 普通标识符
      spans.add(TextSpan(text: word));
    }

    return spans;
  }
}

/// 代码高亮行指示器（用于算法可视化中的当前执行行）
class CodeHighlightIndicator extends StatelessWidget {
  const CodeHighlightIndicator({
    super.key,
    required this.lineNumber,
    this.description,
  });

  final int lineNumber;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderSm,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_right,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            '行 $lineNumber',
            style: AppFonts.labelMedium(color: AppColors.primary),
          ),
          if (description != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              '- $description',
              style: AppFonts.labelMedium(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
