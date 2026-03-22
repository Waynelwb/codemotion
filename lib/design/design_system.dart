// CodeMotion Design System
// Flutter C++ 可视化学习应用的设计系统
//
// 设计原则：
// - 深色主题优先，一致的视觉语言
// - Material 3 组件基础
// - 中英文混排优化

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// 颜色系统
/// ============================================================================

class AppColors {
  AppColors._();

  // --- 主题背景 ---
  static const Color background = Color(0xFF0A0A0F);       // 主背景
  static const Color cardBackground = Color(0xFF12121A);   // 卡片背景
  static const Color codeBackground = Color(0xFF16161D);  // 代码区背景
  static const Color surfaceElevated = Color(0xFF1A1A24); // 悬浮表面

  // --- 主色系 (Primary #6366F1) ---
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFF1E1B4B);
  static const Color onPrimaryContainer = Color(0xFFE0E7FF);

  // --- 次色系 (Tertiary) ---
  static const Color tertiary = Color(0xFFEC4899);
  static const Color tertiaryLight = Color(0xFFF472B6);
  static const Color tertiaryDark = Color(0xFFDB2777);
  static const Color tertiaryContainer = Color(0xFF4C0519);

  // --- 语义色 ---
  static const Color success = Color(0xFF34D399);
  static const Color successContainer = Color(0xFF064E3B);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFF451A03);
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFF450A0A);
  static const Color info = Color(0xFF60A5FA);
  static const Color infoContainer = Color(0xFF1E3A5F);

  // --- 文字色 ---
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // --- 边框 & 分割线 ---
  static const Color border = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF334155);
  static const Color divider = Color(0xFF1E293B);

  // --- 渐变色预设 ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [cardBackground, Color(0xFF0F0F1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- 算法可视化专用颜色 ---
  static const Color vizDefault = Color(0xFF6366F1);      // 默认状态（紫色）
  static const Color vizComparing = Color(0xFFFBBF24);    // 比较中（黄色）
  static const Color vizSwapping = Color(0xFFEF4444);     // 交换中（红色）
  static const Color vizSorted = Color(0xFF34D399);       // 已完成（绿色）
  static const Color vizPivot = Color(0xFFEC4899);        // 基准元素（粉色）
  static const Color vizHighlight = Color(0xFF60A5FA);    // 高亮（蓝色）

  // --- 语法高亮色（与 Landing Page 一致） ---
  static const Color syntaxKeyword = Color(0xFFA78BFA);   // 关键字 (purple)
  static const Color syntaxType = Color(0xFF60A5FA);      // 类型 (blue)
  static const Color syntaxFunction = Color(0xFFF472B6);  // 函数 (pink)
  static const Color syntaxString = Color(0xFF34D399);    // 字符串 (green)
  static const Color syntaxNumber = Color(0xFFFBBF24);   // 数字 (amber)
  static const Color syntaxComment = Color(0xFF64748B);  // 注释 (gray)
  static const Color syntaxOperator = Color(0xFFFFFFFF);  // 操作符 (white)
}

/// ============================================================================
/// 字体系统
/// ============================================================================

class AppFonts {
  AppFonts._();

  // Space Grotesk - 标题、中文混排场景的主标题
  // 特点：几何感强，现代科技感
  static TextStyle displayLarge({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        height: 1.1,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle headlineLarge({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle titleLarge({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  // Inter - 正文、说明文字
  // 特点：清晰易读，适合小号字体
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textTertiary,
        height: 1.5,
      );

  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
        height: 1.4,
      );

  // Fira Code - 代码块
  // 特点：等宽字体，支持连字
  static TextStyle codeLarge({Color? color}) => GoogleFonts.firaCode(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.7,
      );

  static TextStyle codeMedium({Color? color}) => GoogleFonts.firaCode(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle codeSmall({Color? color}) => GoogleFonts.firaCode(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.5,
      );

  /// 获取代码高亮 TextSpan 的便捷方法
  static List<TextSpan> highlightCode(String code) {
    // 简化版高亮，实际项目可使用 flutter_highlight 或 similar
    return [
      TextSpan(text: code, style: codeLarge()),
    ];
  }
}

/// ============================================================================
/// 间距系统
/// ============================================================================

class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// ============================================================================
/// 圆角系统
/// ============================================================================

class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;

  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderXxl = BorderRadius.all(Radius.circular(xxl));
}

/// ============================================================================
/// 阴影系统
/// ============================================================================

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card({Color? glowColor}) => [
        BoxShadow(
          color: (glowColor ?? AppColors.primary).withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> elevated({Color? glowColor}) => [
        BoxShadow(
          color: (glowColor ?? AppColors.primary).withValues(alpha: 0.15),
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ];

  static List<BoxShadow> button({Color? color}) => [
        BoxShadow(
          color: (color ?? AppColors.primary).withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

/// ============================================================================
/// 主题扩展
/// ============================================================================

extension ThemeExtensions on ThemeData {
  Color get cardBg => AppColors.cardBackground;
  Color get codeBg => AppColors.codeBackground;
  Color get surfaceElevated => AppColors.surfaceElevated;
}

/// ============================================================================
/// 通用装饰
/// ============================================================================

class AppDecorations {
  AppDecorations._();

  static BoxDecoration card({
    Color? background,
    Color? borderColor,
    Color? glowColor,
    double borderRadius = 16,
  }) =>
      BoxDecoration(
        color: background ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: 1,
        ),
        boxShadow: AppShadows.card(glowColor: glowColor),
      );

  static BoxDecoration codeBlock({double borderRadius = 12}) => BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border, width: 1),
      );

  static BoxDecoration primaryButton() => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.borderSm,
        boxShadow: AppShadows.button(),
      );
}
