// Course Detail Page - Display course chapters and lessons with code examples
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import '../design/design_system.dart';
import '../design/responsive.dart';
import '../design/visualization/code_highlight.dart';
import '../content/content.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({
    super.key,
    required this.courseId,
    this.heroIcon,
    this.heroTitle,
  });

  final String courseId;
  final IconData? heroIcon;
  final String? heroTitle;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  // Track expanded chapters and lessons
  final Set<String> _expandedChapters = {};
  final Set<String> _expandedLessons = {};

  // Track lesson completion
  final Set<String> _completedLessons = {};

  // Search
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    // Load saved progress
    _loadProgress();

    // Listen to scroll position for FAB visibility
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showFab = _scrollController.offset > 400;
    if (showFab != _showScrollToTop) {
      setState(() => _showScrollToTop = showFab);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    // Progress loading is handled via SharedPreferences in main app
    // For now, initialize empty
  }

  void _toggleLesson(String lessonId) {
    setState(() {
      if (_expandedLessons.contains(lessonId)) {
        _expandedLessons.remove(lessonId);
      } else {
        _expandedLessons.add(lessonId);
        // Auto-expand parent chapter
        _expandedChapters.add(_getParentChapterId(lessonId));
      }
    });
  }

  String _getParentChapterId(String lessonId) {
    // lessonId format: basics_variables_basic
    // chapterId format: basics_variables
    final parts = lessonId.split('_');
    if (parts.length >= 2) {
      return '${parts[0]}_${parts[1]}';
    }
    return '';
  }

  void _markLessonComplete(String lessonId) {
    setState(() {
      _completedLessons.add(lessonId);
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final chapter = findChapterById(widget.courseId);
    final hp = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    if (chapter == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _buildNotFound(context, hp, isMobile),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context, chapter, hp, isMobile),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context, hp, isMobile),
                  _buildCourseHeader(chapter, hp),
                  _buildChapterList(chapter, hp, isMobile),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _showScrollToTop ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: _scrollToTop,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            mini: true,
            tooltip: '回到顶部',
            child: const Icon(Icons.keyboard_arrow_up, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CourseChapter chapter, double hp, bool isMobile) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      pinned: true,
      expandedHeight: isMobile ? 60 : 80,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: isMobile
          ? Text(
              chapter.title,
              style: AppFonts.titleMedium(),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      actions: [
        if (!isMobile) ...[
          Container(
            margin: EdgeInsets.only(right: hp),
            child: Row(
              children: [
                _buildBreadcrumb(context, chapter),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBreadcrumb(BuildContext context, CourseChapter chapter) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text(
            '课程',
            style: AppFonts.labelLarge(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 16),
        const SizedBox(width: 8),
        Text(
          chapter.title,
          style: AppFonts.labelLarge(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, double hp, bool isMobile) {
    if (!isMobile) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hp, vertical: 16),
        child: _SearchField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _SearchField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCourseHeader(CourseChapter chapter, double hp) {
    final difficultyColor = _getDifficultyColor(chapter.difficulty);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: hp, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero icon
          Hero(
            tag: widget.heroTitle != null
                ? 'course-hero-${widget.heroTitle}'
                : 'course-hero-${chapter.title}',
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                widget.heroIcon ?? Icons.code,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: difficultyColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getDifficultyIcon(chapter.difficulty),
                            color: difficultyColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getDifficultyLabel(chapter.difficulty),
                            style: AppFonts.labelMedium(color: difficultyColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${chapter.lessons.length} 课时',
                        style: AppFonts.labelMedium(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  chapter.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: Responsive.isMobile(context) ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  chapter.description,
                  style: AppFonts.bodyLarge(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                _buildProgressBar(chapter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(CourseChapter chapter) {
    final completedCount = chapter.lessons
        .where((l) => _completedLessons.contains(l.id))
        .length;
    final progress = chapter.lessons.isEmpty 
        ? 0.0 
        : completedCount / chapter.lessons.length;

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
              '$completedCount / ${chapter.lessons.length} 课时完成',
              style: AppFonts.labelMedium(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildChapterList(CourseChapter chapter, double hp, bool isMobile) {
    final filteredLessons = _searchQuery.isEmpty
        ? chapter.lessons
        : chapter.lessons.where((lesson) {
            final query = _searchQuery.toLowerCase();
            return lesson.title.toLowerCase().contains(query) ||
                lesson.content.toLowerCase().contains(query) ||
                lesson.keyPoints.any((p) => p.toLowerCase().contains(query));
          }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '课程内容',
                style: AppFonts.titleLarge(color: Colors.white),
              ),
              if (_searchQuery.isNotEmpty)
                Text(
                  '找到 ${filteredLessons.length} 个相关课时',
                  style: AppFonts.labelMedium(color: AppColors.textTertiary),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredLessons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = filteredLessons[index];
              return _LessonCard(
                lesson: lesson,
                index: index,
                totalLessons: filteredLessons.length,
                isExpanded: _expandedLessons.contains(lesson.id),
                isCompleted: _completedLessons.contains(lesson.id),
                onToggle: () => _toggleLesson(lesson.id),
                onComplete: () => _markLessonComplete(lesson.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return AppColors.success;
      case DifficultyLevel.intermediate:
        return AppColors.warning;
      case DifficultyLevel.advanced:
        return AppColors.error;
    }
  }

  IconData _getDifficultyIcon(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Icons.star_outline;
      case DifficultyLevel.intermediate:
        return Icons.star_half;
      case DifficultyLevel.advanced:
        return Icons.star;
    }
  }

  String _getDifficultyLabel(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return '入门';
      case DifficultyLevel.intermediate:
        return '进阶';
      case DifficultyLevel.advanced:
        return '高级';
    }
  }

  Widget _buildNotFound(BuildContext context, double hp, bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '未找到该课程',
            style: AppFonts.titleLarge(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '课程 ID: ${widget.courseId}',
            style: AppFonts.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '返回课程列表',
                style: AppFonts.labelLarge(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field widget
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppFonts.bodyMedium(color: Colors.white),
              decoration: InputDecoration(
                hintText: '搜索课时内容...',
                hintStyle: AppFonts.bodyMedium(color: AppColors.textTertiary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: AppColors.textTertiary, size: 18),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Individual lesson card with expandable content
class _LessonCard extends StatefulWidget {
  const _LessonCard({
    required this.lesson,
    required this.index,
    required this.totalLessons,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.onComplete,
  });

  final CourseLesson lesson;
  final int index;
  final int totalLessons;
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onComplete;

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _celebrateController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _celebrateScale;
  late Animation<double> _celebrateOpacity;
  bool _isHovered = false;
  bool _justCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation);

    _celebrateController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _celebrateScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _celebrateController,
        curve: Curves.easeOutBack,
      ),
    );
    _celebrateOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrateController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_LessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    // Trigger celebration when newly completed
    if (widget.isCompleted && !oldWidget.isCompleted) {
      _justCompleted = true;
      _celebrateController.forward(from: 0.0).then((_) {
        _celebrateController.reverse();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _justCompleted = false);
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _celebrateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isExpanded
                ? AppColors.primary.withValues(alpha: 0.5)
                : _isHovered
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.border,
            width: widget.isExpanded || _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        transform: _isHovered
            ? (Matrix4.translationValues(0.0, -2.0, 0.0))
            : Matrix4.identity(),
        child: Column(
          children: [
            // Header - always visible
            GestureDetector(
              onTap: widget.onToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Completion checkbox with celebration
                    GestureDetector(
                      onTap: widget.onComplete,
                      child: AnimatedBuilder(
                        animation: _celebrateController,
                        builder: (context, child) {
                          final scale = widget.isCompleted
                              ? (_justCompleted ? _celebrateScale.value : 1.0)
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: widget.isCompleted
                                        ? AppColors.success
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: widget.isCompleted
                                          ? AppColors.success
                                          : AppColors.border,
                                      width: 2,
                                    ),
                                  ),
                                  child: widget.isCompleted
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : null,
                                ),
                                if (_justCompleted)
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: _celebrateOpacity.value,
                                      child: _CompletionStars(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Lesson index badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.index + 1}',
                          style: AppFonts.labelMedium(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Lesson info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lesson.title,
                            style: AppFonts.titleMedium(
                              color: widget.isCompleted
                                  ? AppColors.textTertiary
                                  : Colors.white,
                            ).copyWith(
                              decoration: widget.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _estimateTime(),
                                style: AppFonts.labelMedium(color: AppColors.info),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.code,
                                size: 14,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.lesson.codeExamples.length} 个代码示例',
                                style: AppFonts.labelMedium(color: AppColors.textTertiary),
                              ),
                              if (widget.lesson.exercises.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.edit_note,
                                  size: 14,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.lesson.exercises.length} 道练习',
                                  style: AppFonts.labelMedium(color: AppColors.warning),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expand indicator with animated color
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          key: ValueKey(widget.isExpanded),
                          color: widget.isExpanded
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expandable content
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: _buildExpandedContent(),
            ),
          ],
        ),
      ),
    );
  }

  String _estimateTime() {
    // Estimate: 5 min per code example + 3 min per exercise + 1 min per key point
    final codeMin = widget.lesson.codeExamples.length * 5;
    final exerciseMin = widget.lesson.exercises.length * 3;
    final keyPointMin = widget.lesson.keyPoints.length * 1;
    final total = codeMin + exerciseMin + keyPointMin;
    if (total < 60) return '~$total 分钟';
    final hours = total ~/ 60;
    final mins = total % 60;
    return mins > 0 ? '~$hours 小时 $mins 分钟' : '~$hours 小时';
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          // Content
          _buildMarkdownContent(widget.lesson.content),
          const SizedBox(height: 24),
          // Key points
          if (widget.lesson.keyPoints.isNotEmpty) ...[
            _buildKeyPoints(widget.lesson.keyPoints),
            const SizedBox(height: 24),
          ],
          // Code examples
          if (widget.lesson.codeExamples.isNotEmpty) ...[
            ...widget.lesson.codeExamples.map((example) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CodeExampleCard(example: example),
            )),
          ],
          // Practice exercises
          if (widget.lesson.exercises.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.edit_note, color: AppColors.warning, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '练习题',
                          style: AppFonts.titleMedium(color: AppColors.warning),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '巩固所学知识，动手实践',
                          style: AppFonts.bodySmall(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.lesson.exercises.length}',
                      style: AppFonts.labelMedium(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...widget.lesson.exercises.map((exercise) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ExerciseCard(example: exercise),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildMarkdownContent(String content) {
    // Use flutter_markdown_plus for proper markdown rendering
    return Markdown(
      data: content,
      styleSheet: MarkdownStyleSheet(
        h1: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        h2: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        h3: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        p: AppFonts.bodyMedium(color: AppColors.textSecondary),
        a: AppFonts.bodyMedium(color: AppColors.primary),
        strong: AppFonts.bodyMedium(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
        em: AppFonts.bodyMedium(color: AppColors.textSecondary).copyWith(fontStyle: FontStyle.italic),
        blockquote: AppFonts.bodyMedium(color: AppColors.textSecondary),
        blockquoteDecoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          border: Border(
            left: BorderSide(
              color: AppColors.primary,
              width: 4,
            ),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        code: AppFonts.codeMedium(color: AppColors.textPrimary),
        codeblockPadding: const EdgeInsets.all(12),
        codeblockDecoration: BoxDecoration(
          color: AppColors.codeBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        listBullet: AppFonts.bodyMedium(color: AppColors.primary),
        listBulletPadding: const EdgeInsets.only(right: 8),
        tableHead: AppFonts.bodyMedium(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
        tableBody: AppFonts.bodyMedium(color: AppColors.textSecondary),
        tableBorder: TableBorder.all(
          color: AppColors.border,
          width: 1,
        ),
        tableCellsPadding: const EdgeInsets.all(8),
        tableCellsDecoration: BoxDecoration(
          color: AppColors.surfaceElevated,
        ),
      ),
      builders: {
        'code': CodeElementBuilder(),
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildKeyPoints(List<String> keyPoints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '核心知识点',
          style: AppFonts.labelLarge(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keyPoints.map((point) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      point,
                      style: AppFonts.labelMedium(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Stars burst animation when lesson is completed
class _CompletionStars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarsPainter(),
      size: Size.infinite,
    );
  }
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final starPositions = [
      Offset(center.dx - 18, center.dy - 18),
      Offset(center.dx + 18, center.dy - 14),
      Offset(center.dx - 14, center.dy + 16),
      Offset(center.dx + 16, center.dy + 12),
      Offset(center.dx, center.dy - 22),
    ];
    final starColor = AppColors.warning;
    for (final pos in starPositions) {
      final paint = Paint()
        ..color = starColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Code example card with syntax highlighting
class _CodeExampleCard extends StatefulWidget {
  const _CodeExampleCard({required this.example});

  final CodeExample example;

  @override
  State<_CodeExampleCard> createState() => _CodeExampleCardState();
}

class _CodeExampleCardState extends State<_CodeExampleCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 12.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.codeBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.code, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.example.title,
                      style: AppFonts.labelLarge(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Code block
            Padding(
              padding: const EdgeInsets.all(16),
              child: CodeHighlight(
                code: widget.example.code,
                language: 'cpp',
                showLineNumbers: true,
                fontSize: 13,
              ),
            ),
            // Description and output
            if (widget.example.description.isNotEmpty || widget.example.output != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.example.description.isNotEmpty) ...[
                      Text(
                        widget.example.description,
                        style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.example.output != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.terminal, color: AppColors.textTertiary, size: 14),
                                const SizedBox(width: 6),
                                Text('输出结果', style: AppFonts.labelMedium(color: AppColors.textTertiary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(widget.example.output!, style: AppFonts.codeSmall(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.example});

  final CodeExample example;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with exercise icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_note, color: AppColors.warning, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    example.title,
                    style: AppFonts.labelLarge(color: AppColors.warning),
                  ),
                ),
              ],
            ),
          ),
          // Code block
          Padding(
            padding: const EdgeInsets.all(16),
            child: CodeHighlight(
              code: example.code,
              language: 'cpp',
              showLineNumbers: true,
              fontSize: 13,
            ),
          ),
          // Description and expected output
          if (example.description.isNotEmpty || example.output != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (example.description.isNotEmpty) ...[
                    Text(
                      example.description,
                      style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (example.output != null && example.output!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: AppColors.warning, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                '期望输出',
                                style: AppFonts.labelMedium(
                                    color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            example.output!,
                            style: GoogleFonts.firaCode(
                              fontSize: 12,
                              color: AppColors.success,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom builder for code blocks in markdown
class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final code = element.textContent;
    if (code.isEmpty) return null;

    // Try to detect language from class attribute
    String language = 'text';
    final attributes = element.attributes;
    if (attributes.containsKey('class')) {
      final classValue = attributes['class']!;
      // Extract language from class like "language-dart"
      if (classValue.startsWith('language-')) {
        language = classValue.substring(9);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.code, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  language.toUpperCase(),
                  style: AppFonts.labelMedium(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          // Code content
          Padding(
            padding: const EdgeInsets.all(16),
            child: CodeHighlight(
              code: code,
              language: language,
              showLineNumbers: true,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
