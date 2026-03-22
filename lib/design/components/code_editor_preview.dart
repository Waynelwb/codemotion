// Code Editor Preview Component
// 代码预览卡片组件，支持语法高亮和可选运行按钮
//
// 使用示例：
// ```dart
// CodeEditorPreview(
//   filename: 'sort.cpp',
//   code: 'void bubbleSort(vector<int>& arr) { ... }',
//   language: 'cpp',
//   showLineNumbers: true,
//   onRun: () { /* run code */ },
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

class CodeEditorPreview extends StatelessWidget {
  const CodeEditorPreview({
    super.key,
    required this.filename,
    required this.code,
    this.language = 'cpp',
    this.showLineNumbers = true,
    this.highlightedLines = const [],
    this.onRun,
    this.maxHeight,
  });

  final String filename;
  final String code;
  final String language;
  final bool showLineNumbers;
  final List<int> highlightedLines; // 需要高亮的行号（从 1 开始）
  final VoidCallback? onRun;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.codeBlock(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppColors.border),
          _buildCodeArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // macOS 窗口按钮
          _WindowButton(color: const Color(0xFFFF5F57)),
          const SizedBox(width: AppSpacing.xs),
          _WindowButton(color: const Color(0xFFFFBD2E)),
          const SizedBox(width: AppSpacing.xs),
          _WindowButton(color: const Color(0xFF28CA41)),
          const SizedBox(width: AppSpacing.md),
          // 文件名
          Text(
            filename,
            style: AppFonts.labelMedium(color: AppColors.textTertiary),
          ),
          const Spacer(),
          // 语言标签
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: AppRadius.borderXs,
            ),
            child: Text(
              language.toUpperCase(),
              style: AppFonts.labelMedium(color: AppColors.textTertiary),
            ),
          ),
          if (onRun != null) ...[
            const SizedBox(width: AppSpacing.sm),
            _RunButton(onTap: onRun!),
          ],
        ],
      ),
    );
  }

  Widget _buildCodeArea() {
    final lines = code.split('\n');

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight ?? 400),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers) _buildLineNumbers(lines),
              if (showLineNumbers) const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildCodeText(lines)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineNumbers(List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(lines.length, (index) {
        final lineNumber = index + 1;
        final isHighlighted = highlightedLines.contains(lineNumber);
        return Container(
          height: 22, // 与代码行高匹配
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          decoration: isHighlighted
              ? BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderXs,
                )
              : null,
          child: Text(
            '$lineNumber',
            style: AppFonts.codeMedium(color: AppColors.textTertiary),
          ),
        );
      }),
    );
  }

  Widget _buildCodeText(List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (index) {
        final lineNumber = index + 1;
        final isHighlighted = highlightedLines.contains(lineNumber);
        return Container(
          height: 22,
          decoration: isHighlighted
              ? BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderXs,
                )
              : null,
          child: _buildHighlightedLine(lines[index]),
        );
      }),
    );
  }

  Widget _buildHighlightedLine(String line) {
    // 简化的语法高亮实现
    // 实际项目建议使用 flutter_highlight 包
    final spans = _tokenize(line);
    return RichText(
      text: TextSpan(
        style: AppFonts.codeMedium(),
        children: spans,
      ),
    );
  }

  List<TextSpan> _tokenize(String line) {
    if (line.trim().isEmpty) {
      return [TextSpan(text: line, style: AppFonts.codeMedium())];
    }

    final spans = <TextSpan>[];
    final buffer = StringBuffer();
    bool inString = false;
    String stringChar = '';

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      // 字符串处理
      if ((char == '"' || char == "'") && !inString) {
        if (buffer.isNotEmpty) {
          spans.addAll(_tokenizeWord(buffer.toString()));
          buffer.clear();
        }
        inString = true;
        stringChar = char;
        buffer.write(char);
      } else if (char == stringChar && inString) {
        buffer.write(char);
        spans.add(TextSpan(
          text: buffer.toString(),
          style: AppFonts.codeMedium(color: AppColors.syntaxString),
        ));
        buffer.clear();
        inString = false;
        stringChar = '';
      } else if (inString) {
        buffer.write(char);
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      if (inString) {
        spans.add(TextSpan(
          text: buffer.toString(),
          style: AppFonts.codeMedium(color: AppColors.syntaxString),
        ));
      } else {
        spans.addAll(_tokenizeWord(buffer.toString()));
      }
    }

    return spans;
  }

  List<TextSpan> _tokenizeWord(String word) {
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
      'try', 'catch', 'throw', ' noexcept', 'constexpr', 'decltype',
    };

    // 内置类型
    const types = {
      'int', 'char', 'float', 'double', 'void', 'bool',
      'size_t', 'string', 'vector', 'map', 'set', 'pair',
    };

    if (keywords.contains(word)) {
      return [TextSpan(
        text: word,
        style: AppFonts.codeMedium(color: AppColors.syntaxKeyword),
      )];
    } else if (types.contains(word)) {
      return [TextSpan(
        text: word,
        style: AppFonts.codeMedium(color: AppColors.syntaxType),
      )];
    } else if (RegExp(r'^\d+$').hasMatch(word)) {
      return [TextSpan(
        text: word,
        style: AppFonts.codeMedium(color: AppColors.syntaxNumber),
      )];
    } else if (word.startsWith('//') || word.startsWith('/*')) {
      return [TextSpan(
        text: word,
        style: AppFonts.codeMedium(color: AppColors.syntaxComment),
      )];
    } else {
      return [TextSpan(text: word, style: AppFonts.codeMedium())];
    }
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _RunButton extends StatefulWidget {
  const _RunButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_RunButton> createState() => _RunButtonState();
}

class _RunButtonState extends State<_RunButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.success.withValues(alpha: 0.2)
                : AppColors.border,
            borderRadius: AppRadius.borderXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                size: 14,
                color: _isHovered ? AppColors.success : AppColors.textSecondary,
              ),
              const SizedBox(width: 2),
              Text(
                '运行',
                style: AppFonts.labelMedium(
                  color: _isHovered ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
