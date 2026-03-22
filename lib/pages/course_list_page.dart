// Course List Page - Display all course categories with animations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/design_system.dart';
import '../design/animations/fade_slide_transition.dart';
import '../design/animations/pulse_animation.dart';
import '../models/course_model.dart';
import '../design/responsive.dart';
import 'course_detail_page.dart';
import '../app_router.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;

  late AnimationController _tabIndicatorController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tabIndicatorController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabIndicatorController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(int index) {
    if (index == _selectedCategoryIndex) return;
    setState(() => _selectedCategoryIndex = index);
    _tabIndicatorController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final hp = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF12121A),
              child: ListView(padding: EdgeInsets.zero, children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF0A0A0F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.code, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'CodeMotion',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: Colors.white60),
                  title: const Text('首页', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school, color: Color(0xFF6366F1)),
                  title: const Text('课程',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.play_circle_outline, color: Colors.white60),
                  title: const Text('可视化', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.white60),
                  title: const Text('关于', style: TextStyle(color: Colors.white60)),
                  onTap: () => Navigator.pop(context),
                ),
              ]),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context, hp),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hp, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 48),
                  _buildCategoryTabs(context),
                  const SizedBox(height: 32),
                  _buildCurrentCategorySection(context),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, double hp) {
    final isMobile = Responsive.isMobile(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hp, vertical: isMobile ? 16 : 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            if (isMobile)
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white70),
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                ),
              )
            else
              _buildNavLinks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.code, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'CodeMotion',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNavLinks(BuildContext context) {
    return Row(
      children: [
        _navLink('首页', isActive: false, onTap: () => Navigator.of(context).pop()),
        const SizedBox(width: 32),
        _navLink('课程', isActive: true),
        const SizedBox(width: 32),
        _navLink('可视化', isActive: false,
            onTap: () => _navigateToVisualize(context)),
        const SizedBox(width: 32),
        _navLink('关于', isActive: false),
      ],
    );
  }

  void _navigateToVisualize(BuildContext context) {
    globalRouter.navigateToVisualize();
  }

  Widget _navLink(String text, {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white60,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeSlideTransition(
      direction: SlideDirection.bottomToTop,
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '课程目录',
            style: GoogleFonts.spaceGrotesk(
              fontSize: Responsive.sectionTitleSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '从基础语法到高级算法，系统化学习 C++ 编程',
            style: TextStyle(
              fontSize: Responsive.isMobile(context) ? 15 : 18,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    final categories = [
      (CourseCategory.basics, _getBasicsCourses()),
      (CourseCategory.oop, _getOopCourses()),
      (CourseCategory.stl, _getStlCourses()),
      (CourseCategory.algorithms, _getAlgorithmCourses()),
    ];

    return FadeSlideTransition(
      direction: SlideDirection.bottomToTop,
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppColors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / categories.length;
            return Stack(
              children: [
                // Sliding indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: _selectedCategoryIndex * tabWidth,
                  top: 4,
                  bottom: 4,
                  width: tabWidth - 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppRadius.borderSm,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab buttons
                Row(
                  children: List.generate(categories.length, (index) {
                    final (category, _) = categories[index];
                    final isSelected = index == _selectedCategoryIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onCategoryChanged(index),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category.icon,
                                size: 18,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    category.label,
                                    style: AppFonts.labelLarge(
                                      color: isSelected ? Colors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentCategorySection(BuildContext context) {
    final categories = [
      (CourseCategory.basics, _getBasicsCourses()),
      (CourseCategory.oop, _getOopCourses()),
      (CourseCategory.stl, _getStlCourses()),
      (CourseCategory.algorithms, _getAlgorithmCourses()),
    ];

    final (category, courses) = categories[_selectedCategoryIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeSlideTransition(
          direction: SlideDirection.rightToLeft,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
      child: Column(
        key: ValueKey(category),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(category),
          const SizedBox(height: 20),
          _buildCourseGrid(context, courses),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(CourseCategory category) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderMd,
          ),
          child: Icon(category.icon, color: category.color, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.label,
              style: AppFonts.titleLarge(color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              _getCategoryDescription(category),
              style: AppFonts.bodySmall(color: AppColors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseGrid(BuildContext context, List<CourseOverviewModel> courses) {
    final isMobile = Responsive.isMobile(context);
    final hp = Responsive.horizontalPadding(context);
    final availableWidth = MediaQuery.of(context).size.width - hp * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive cross axis count
        int crossAxisCount;
        double childAspectRatio;

        if (isMobile) {
          crossAxisCount = 1;
          childAspectRatio = availableWidth / 180;
        } else if (Responsive.isTablet(context)) {
          crossAxisCount = 2;
          childAspectRatio = (availableWidth - 20) / 2 / 180;
        } else {
          crossAxisCount = (availableWidth / 380).floor().clamp(2, 4);
          childAspectRatio = (availableWidth - 20 * (crossAxisCount - 1)) /
              (crossAxisCount * 180);
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio.clamp(1.5, 3.0),
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return FadeSlideTransition(
              direction: SlideDirection.bottomToTop,
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 * index),
              child: _AnimatedCourseCard(
                title: course.title,
                description: course.description,
                difficulty: _toDifficultyLevel(course.difficulty),
                icon: course.icon,
                progress: course.progress,
                tags: course.tags,
                onTap: () {
                  // Navigate to course detail page
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return _CourseDetailPageWrapper(courseId: course.id);
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.05),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String _getCategoryDescription(CourseCategory category) {
    switch (category) {
      case CourseCategory.basics:
        return '变量、数据类型、控制流、函数等核心概念';
      case CourseCategory.oop:
        return '类、对象、继承、多态等面向对象特性';
      case CourseCategory.stl:
        return 'vector、map、set、算法等标准模板库';
      case CourseCategory.algorithms:
        return '排序、查找、动态规划等算法思想';
    }
  }

  DifficultyLevel _toDifficultyLevel(CourseDifficulty difficulty) {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return DifficultyLevel.beginner;
      case CourseDifficulty.intermediate:
        return DifficultyLevel.intermediate;
      case CourseDifficulty.advanced:
        return DifficultyLevel.advanced;
    }
  }

  List<CourseOverviewModel> _getBasicsCourses() {
    return const [
      CourseOverviewModel(
        id: 'basics_variables',
        title: '变量与数据类型',
        description: '学习整型、浮点型、字符型、布尔型等基本数据类型，以及常量的使用。',
        difficulty: CourseDifficulty.beginner,
        category: CourseCategory.basics,
        icon: Icons.data_object,
        tags: ['变量', '常量', '类型转换'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'basics_operators',
        title: '运算符与表达式',
        description: '掌握算术、关系、逻辑、位运算符，以及运算符优先级。',
        difficulty: CourseDifficulty.beginner,
        category: CourseCategory.basics,
        icon: Icons.calculate,
        tags: ['算术运算', '逻辑运算', '位运算'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'basics_control_flow',
        title: '控制流程',
        description: 'if-else 条件判断、switch 语句、for/while 循环控制。',
        difficulty: CourseDifficulty.beginner,
        category: CourseCategory.basics,
        icon: Icons.account_tree,
        tags: ['条件判断', '循环', '分支'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'basics_functions',
        title: '函数基础',
        description: '学习函数定义、参数传递、返回值、递归函数等核心概念。',
        difficulty: CourseDifficulty.beginner,
        category: CourseCategory.basics,
        icon: Icons.functions,
        tags: ['参数传递', '递归', '函数重载'],
        lessonCount: 3,
      ),
    ];
  }

  List<CourseOverviewModel> _getOopCourses() {
    return const [
      CourseOverviewModel(
        id: 'oop_classes',
        title: '类与对象',
        description: '理解类的定义、对象的创建、成员变量和成员函数。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.oop,
        icon: Icons.class_,
        tags: ['类', '对象', '封装'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'oop_encapsulation',
        title: '封装与访问控制',
        description: '掌握 public、private、protected 访问权限，以及友元函数。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.oop,
        icon: Icons.lock,
        tags: ['访问控制', '友元', 'getter/setter'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'oop_inheritance',
        title: '继承与派生',
        description: '理解类的继承关系，掌握单继承、多继承和虚继承。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.oop,
        icon: Icons.family_restroom,
        tags: ['继承', '派生类', '构造函数'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'oop_polymorphism',
        title: '多态与虚函数',
        description: '掌握运行时多态，纯虚函数，抽象类和接口的设计。',
        difficulty: CourseDifficulty.advanced,
        category: CourseCategory.oop,
        icon: Icons.hub,
        tags: ['虚函数', '多态', '抽象类'],
        lessonCount: 2,
      ),
    ];
  }

  List<CourseOverviewModel> _getStlCourses() {
    return const [
      CourseOverviewModel(
        id: 'stl_vectors',
        title: 'Vector 容器',
        description: '学习 vector 的创建、访问、修改和常用操作。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.stl,
        icon: Icons.science,
        tags: ['vector', '容器', '动态数组'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'stl_maps',
        title: 'Map 容器',
        description: '学习 map 和 unordered_map 键值对容器的使用。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.stl,
        icon: Icons.map,
        tags: ['map', 'unordered_map', '键值对'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'stl_sets',
        title: 'Set 容器',
        description: '学习 set 和 unordered_set 无重复元素集合的操作。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.stl,
        icon: Icons.folder_special,
        tags: ['set', '集合', '去重'],
        lessonCount: 2,
      ),
      CourseOverviewModel(
        id: 'stl_algorithms',
        title: 'STL 算法',
        description: '掌握 sort、find、binary_search 等常用算法的使用。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.stl,
        icon: Icons.auto_fix_high,
        tags: ['sort', 'find', 'binary_search'],
        lessonCount: 3,
      ),
    ];
  }

  List<CourseOverviewModel> _getAlgorithmCourses() {
    return const [
      CourseOverviewModel(
        id: 'algorithms_sorting',
        title: '排序算法',
        description: '冒泡、选择、插入、归并、快速排序的原理与实现。',
        difficulty: CourseDifficulty.intermediate,
        category: CourseCategory.algorithms,
        icon: Icons.sort,
        tags: ['排序', '分治', '递归'],
        lessonCount: 5,
      ),
      CourseOverviewModel(
        id: 'algorithms_searching',
        title: '查找算法',
        description: '顺序查找、二分查找、哈希查找的原理与适用场景。',
        difficulty: CourseDifficulty.beginner,
        category: CourseCategory.algorithms,
        icon: Icons.search,
        tags: ['二分查找', '哈希'],
        lessonCount: 3,
      ),
    ];
  }
}

/// Difficulty level enum used by course card
enum DifficultyLevel {
  beginner('入门', AppColors.success),
  intermediate('进阶', AppColors.warning),
  advanced('高级', AppColors.error);

  const DifficultyLevel(this.label, this.color);
  final String label;
  final Color color;
}

/// Animated course card with hover/click effects
class _AnimatedCourseCard extends StatefulWidget {
  const _AnimatedCourseCard({
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
  final double? progress;
  final VoidCallback? onTap;
  final List<String> tags;

  @override
  State<_AnimatedCourseCard> createState() => _AnimatedCourseCardState();
}

class _AnimatedCourseCardState extends State<_AnimatedCourseCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
              0.0, _isHovered ? -4.0 : (_isPressed ? 2.0 : 0.0), 0.0),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: _isPressed ? 0.98 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildContent()),
                  if (widget.progress != null) ...[
                    const SizedBox(height: 16),
                    _buildProgress(),
                  ],
                  if (widget.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildTags(),
                  ],
                ],
              ),
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
            color: AppColors.primary.withValues(alpha: _isHovered ? 0.25 : 0.15),
            borderRadius: AppRadius.borderMd,
          ),
          child: Icon(
            widget.icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DifficultyBadgeWithPulse(
            difficulty: widget.difficulty,
            isHovered: _isHovered,
          ),
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
        const SizedBox(height: 4),
        Expanded(
          child: Text(
            widget.description,
              style: AppFonts.bodyMedium(color: AppColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
          ),
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
        const SizedBox(height: 6),
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
      spacing: 8,
      runSpacing: 8,
      children: widget.tags.map((tag) => _TagChip(label: tag)).toList(),
    );
  }
}

/// Difficulty badge with pulse animation when hovered
class _DifficultyBadgeWithPulse extends StatelessWidget {
  const _DifficultyBadgeWithPulse({
    required this.difficulty,
    required this.isHovered,
  });

  final DifficultyLevel difficulty;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

    if (isHovered) {
      return PulseAnimation(
        duration: const Duration(milliseconds: 1200),
        scale: 1.1,
        opacity: 0.6,
        child: badge,
      );
    }

    return badge;
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

/// Wrapper for CourseDetailPage to handle navigation
class _CourseDetailPageWrapper extends StatelessWidget {
  const _CourseDetailPageWrapper({required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return CourseDetailPage(courseId: courseId);
  }
}
