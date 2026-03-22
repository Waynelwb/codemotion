// Course Card Component
// 课程卡片组件，用于展示课程信息
//
// 使用示例：
// ```dart
// CourseCard(
//   title: '排序算法基础',
//   description: '学习冒泡、选择、插入排序的原理',
//   difficulty: DifficultyLevel.intermediate,
//   icon: Icons.sort,
//   progress: 0.65,
//   onTap: () {},
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

enum DifficultyLevel {
  beginner('入门', AppColors.success),
  intermediate('进阶', AppColors.warning),
  advanced('高级', AppColors.error);

  const DifficultyLevel(this.label, this.color);
  final String label;
  final Color color;
}

class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.icon,
    this.progress,
    this.onTap,
    this.tags = const [],
  });

  final String title;
  final String description;
  final DifficultyLevel difficulty;
  final IconData icon;
  final double? progress; // 0.0 - 1.0，未完成则为 null
  final VoidCallback? onTap;
  final List<String> tags;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 160),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : AppShadows.card(),
          ),
          transform: _isHovered
              ? (Matrix4.translationValues(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.md),
                _buildContent(),
                if (widget.progress != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildProgress(),
                ],
                if (widget.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildTags(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderMd,
          ),
          child: Icon(widget.icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DifficultyBadge(difficulty: widget.difficulty),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppFonts.titleMedium(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          widget.description,
          style: AppFonts.bodyMedium(color: AppColors.textSecondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '学习进度',
              style: AppFonts.labelMedium(color: AppColors.textTertiary),
            ),
            Text(
              '${(widget.progress! * 100).toInt()}%',
              style: AppFonts.labelMedium(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        ClipRRect(
          borderRadius: AppRadius.borderXs,
          child: LinearProgressIndicator(
            value: widget.progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: widget.tags.map((tag) => _TagChip(label: tag)).toList(),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final DifficultyLevel difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: difficulty.color.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderXs,
        border: Border.all(
          color: difficulty.color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        difficulty.label,
        style: AppFonts.labelMedium(color: difficulty.color),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: AppRadius.borderXs,
      ),
      child: Text(
        label,
        style: AppFonts.labelMedium(color: AppColors.textTertiary),
      ),
    );
  }
}
