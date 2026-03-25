import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_router.dart';
import 'design/responsive.dart';

void main() {
  runApp(const CodeMotionApp());
}

class CodeMotionApp extends StatefulWidget {
  const CodeMotionApp({super.key});

  @override
  State<CodeMotionApp> createState() => _CodeMotionAppState();
}

class _CodeMotionAppState extends State<CodeMotionApp> {
  late final AppRouterDelegate _routerDelegate;
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  void initState() {
    super.initState();
    _routerDelegate = AppRouterDelegate(AppNavigator.instance);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CodeMotion - C++ 可视化学习',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

// ============================================================================
// HomePage - Landing Page with responsive design
// ============================================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hp = Responsive.horizontalPadding(context);
    final vp = Responsive.verticalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      endDrawer: Responsive.isMobile(context)
          ? _buildMobileDrawer(context, colorScheme)
          : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildNavBar(context, colorScheme, hp),
          ),
          SliverToBoxAdapter(
            child: _buildHero(context, colorScheme, hp, vp),
          ),
          SliverToBoxAdapter(
            child: _buildFeatures(context, colorScheme, hp, vp),
          ),
          SliverToBoxAdapter(
            child: _buildLearningPath(context, colorScheme, hp, vp),
          ),
          SliverToBoxAdapter(
            child: _buildFooter(context, colorScheme, hp),
          ),
        ],
      ),
    );
  }

  Drawer _buildMobileDrawer(BuildContext context, ColorScheme colorScheme) {
    return Drawer(
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
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ),
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
          leading: const Icon(Icons.home, color: Colors.white),
          title: const Text('首页',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          onTap: () {
            Navigator.pop(context);
            globalNavigator.navigateToHome();
          },
        ),
        ListTile(
          leading: const Icon(Icons.school_outlined, color: Colors.white60),
          title: const Text('课程', style: TextStyle(color: Colors.white60)),
          onTap: () {
            Navigator.pop(context);
            globalNavigator.navigateToCourses();
          },
        ),
        ListTile(
          leading: const Icon(Icons.play_circle_outline, color: Colors.white60),
          title: const Text('可视化', style: TextStyle(color: Colors.white60)),
          onTap: () {
            Navigator.pop(context);
            globalNavigator.navigateToVisualize();
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.white60),
          title: const Text('关于', style: TextStyle(color: Colors.white60)),
          onTap: () => Navigator.pop(context),
        ),
      ]),
    );
  }

  Widget _buildNavBar(
      BuildContext context, ColorScheme colorScheme, double hp) {
    final isMobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hp, vertical: isMobile ? 16 : 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ),
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
          ),

          if (isMobile)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white70),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: _navLink('首页', isActive: true,
                    onTap: () => globalNavigator.navigateToHome())),
                Flexible(child: _navLink('课程',
                    onTap: () => globalNavigator.navigateToCourses())),
                Flexible(child: _navLink('可视化',
                    onTap: () => globalNavigator.navigateToVisualize())),
                Flexible(child: _navLink('关于')),
                const SizedBox(width: 24),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => globalNavigator.navigateToCourses(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('开始学习', overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _navLink(String text, {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildHero(
      BuildContext context, ColorScheme colorScheme, double hp, double vp) {
    final titleSize = Responsive.heroTitleSize(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: vp, horizontal: hp),
      child: Column(
        children: [
          // 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'C++ 学习，从这里开始',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            '优雅地掌握\nC++ 编程之美',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            '通过交互式可视化演示，直观理解算法原理\n从基础语法到高级特性，循序渐进地提升你的编程能力',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 15 : 18,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 48),

          // 按钮组（响应式换行）
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => globalNavigator.navigateToCourses(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('立即开始学习',
                    style: TextStyle(fontSize: 16)),
              ),
              OutlinedButton(
                onPressed: () => globalNavigator.navigateToCourses(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('查看课程大纲',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),

          const SizedBox(height: 80),

          // 代码预览卡片（响应式宽度）
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 360 : 700),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF16161D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 12, height: 12,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFF5F57),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Container(width: 12, height: 12,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFBD2E),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Container(width: 12, height: 12,
                          decoration: const BoxDecoration(
                              color: Color(0xFF28CA41),
                              shape: BoxShape.circle)),
                      const Spacer(),
                      Text('main.cpp',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCodeBlock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.firaCode(fontSize: 15, height: 1.7),
        children: const [
          TextSpan(text: '#include ', style: TextStyle(color: Color(0xFFA78BFA))),
          TextSpan(text: '<iostream>\n', style: TextStyle(color: Color(0xFF60A5FA))),
          TextSpan(text: '\nint ', style: TextStyle(color: Color(0xFFA78BFA))),
          TextSpan(text: 'main', style: TextStyle(color: Color(0xFFF472B6))),
          TextSpan(text: '() {\n', style: TextStyle(color: Colors.white)),
          TextSpan(text: '    ', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'std', style: TextStyle(color: Color(0xFF60A5FA))),
          TextSpan(text: '::', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'cout', style: TextStyle(color: Color(0xFFF472B6))),
          TextSpan(text: ' << ', style: TextStyle(color: Colors.white)),
          TextSpan(text: '"Hello, CodeMotion!"', style: TextStyle(color: Color(0xFF34D399))),
          TextSpan(text: ' << ', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'std', style: TextStyle(color: Color(0xFF60A5FA))),
          TextSpan(text: '::', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'endl', style: TextStyle(color: Color(0xFFF472B6))),
          TextSpan(text: ';\n', style: TextStyle(color: Colors.white)),
          TextSpan(text: '    ', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'return ', style: TextStyle(color: Color(0xFFA78BFA))),
          TextSpan(text: '0', style: TextStyle(color: Color(0xFF34D399))),
          TextSpan(text: ';\n}', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFeatures(
      BuildContext context, ColorScheme colorScheme, double hp, double vp) {
    final titleSize = Responsive.sectionTitleSize(context);
    final features = [
      {'icon': Icons.school_outlined, 'title': '系统化课程',
          'desc': '从零基础到进阶，循序渐进的学习路径'},
      {'icon': Icons.play_circle_outline, 'title': '可视化演示',
          'desc': '动态展示算法执行过程，直观理解原理'},
      {'icon': Icons.code, 'title': '交互式代码',
          'desc': '边学边练，在线编写和运行代码'},
      {'icon': Icons.psychology_outlined, 'title': '思维提升',
          'desc': '培养编程思维和解决问题的能力'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: vp, horizontal: hp),
      child: Column(
        children: [
          Text(
            '为什么选择 CodeMotion？',
            style: GoogleFonts.spaceGrotesk(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '我们为你提供最优质的学习体验',
            style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 15 : 18,
                color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 48),
          _buildFeatureGrid(context, colorScheme, features),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, ColorScheme colorScheme,
      List<Map<String, dynamic>> features) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hp = Responsive.horizontalPadding(context);
    final availableWidth = screenWidth - hp * 2;

    // Responsive breakpoints: < 600px → 1 col, 600-900px → 2 cols, > 900px → 4 cols
    int cardsPerRow;
    if (screenWidth < 600) {
      cardsPerRow = 1;
    } else if (screenWidth < 900) {
      cardsPerRow = 2;
    } else {
      cardsPerRow = 4;
    }

    final spacing = 16.0;
    final totalSpacing = spacing * (cardsPerRow - 1);
    final cardWidth = (availableWidth - totalSpacing) / cardsPerRow;

    // Build rows of cards
    final rows = <Widget>[];
    for (int i = 0; i < features.length; i += cardsPerRow) {
      final rowCards = features.skip(i).take(cardsPerRow).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + cardsPerRow < features.length ? spacing : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowCards.asMap().entries.map((entry) {
              final idx = entry.key;
              final f = entry.value;
              return SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.only(right: idx < rowCards.length - 1 ? spacing : 0),
                  child: _buildFeatureCard(context, colorScheme, f),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildFeatureCard(BuildContext context, ColorScheme colorScheme,
      Map<String, dynamic> feature) {
    return AnimatedFeatureCard(
      colorScheme: colorScheme,
      feature: feature,
    );
  }

  Widget _buildLearningPath(
      BuildContext context, ColorScheme colorScheme, double hp, double vp) {
    final titleSize = Responsive.sectionTitleSize(context);
    final stages = [
      {'num': '01', 'title': '基础语法', 'desc': '变量、数据类型、控制流',
          'color': const Color(0xFF6366F1)},
      {'num': '02', 'title': '面向对象', 'desc': '类、对象、继承、多态',
          'color': const Color(0xFFEC4899)},
      {'num': '03', 'title': 'STL 容器', 'desc': 'vector、map、set、算法',
          'color': const Color(0xFF14B8A6)},
      {'num': '04', 'title': '算法进阶', 'desc': '排序、查找、动态规划',
          'color': const Color(0xFFF59E0B)},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: vp, horizontal: hp),
      child: Column(
        children: [
          Text(
            '学习路径',
            style: GoogleFonts.spaceGrotesk(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '四个阶段，全面掌握 C++',
            style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 15 : 18,
                color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 48),
          _buildPathGrid(context, stages),
        ],
      ),
    );
  }

  Widget _buildPathGrid(
      BuildContext context, List<Map<String, dynamic>> stages) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hp = Responsive.horizontalPadding(context);
    final availableWidth = screenWidth - hp * 2;

    // Responsive breakpoints: < 600px → 1 col, 600-900px → 2 cols, > 900px → 4 cols
    int cardsPerRow;
    if (screenWidth < 600) {
      cardsPerRow = 1;
    } else if (screenWidth < 900) {
      cardsPerRow = 2;
    } else {
      cardsPerRow = 4;
    }

    final spacing = 16.0;
    final totalSpacing = spacing * (cardsPerRow - 1);
    final cardWidth = (availableWidth - totalSpacing) / cardsPerRow;

    // Build rows of cards
    final rows = <Widget>[];
    for (int i = 0; i < stages.length; i += cardsPerRow) {
      final rowStages = stages.skip(i).take(cardsPerRow).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + cardsPerRow < stages.length ? spacing : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowStages.asMap().entries.map((entry) {
              final idx = entry.key;
              final stage = entry.value;
              return SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.only(right: idx < rowStages.length - 1 ? spacing : 0),
                  child: _buildPathStage(context, stage, idx, rowStages.length),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildPathStage(BuildContext context,
      Map<String, dynamic> stage, int index, int total) {
    return AnimatedPathStage(stage: stage);
  }

  Widget _buildFooter(
      BuildContext context, ColorScheme colorScheme, double hp) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: hp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'CodeMotion',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© 2026 CodeMotion. Made with ❤️ by Wayne.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Animated Feature Card with hover effects
// ============================================================================
class AnimatedFeatureCard extends StatefulWidget {
  const AnimatedFeatureCard({
    super.key,
    required this.colorScheme,
    required this.feature,
  });

  final ColorScheme colorScheme;
  final Map<String, dynamic> feature;

  @override
  State<AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<AnimatedFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    final feature = widget.feature;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 200,
          clipBehavior: Clip.hardEdge,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? colorScheme.primary.withValues(alpha: 0.25)
                      : colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(feature['icon'],
                    color: colorScheme.primary, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                feature['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 13,
                  color: _isHovered
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.5),
                ),
                child: Text(
                  feature['desc'],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Animated Path Stage with hover effects
// ============================================================================
class AnimatedPathStage extends StatefulWidget {
  const AnimatedPathStage({super.key, required this.stage});

  final Map<String, dynamic> stage;

  @override
  State<AnimatedPathStage> createState() => _AnimatedPathStageState();
}

class _AnimatedPathStageState extends State<AnimatedPathStage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final stage = widget.stage;
    final stageColor = stage['color'] as Color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 200,
        clipBehavior: Clip.hardEdge,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? stageColor.withValues(alpha: 0.7)
                : stageColor.withValues(alpha: 0.3),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: stageColor.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: _isHovered
                    ? stageColor.withValues(alpha: 1.0)
                    : stageColor.withValues(alpha: 0.7),
              ),
              child: Text(stage['num']),
            ),
            const SizedBox(height: 8),
            Text(
              stage['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13,
                color: _isHovered
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.5),
              ),
              child: Text(
                stage['desc'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
