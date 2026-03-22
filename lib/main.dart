import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_router.dart';

void main() {
  runApp(const CodeMotionApp());
}

class CodeMotionApp extends StatefulWidget {
  const CodeMotionApp({super.key});

  @override
  State<CodeMotionApp> createState() => _CodeMotionAppState();
}

class _CodeMotionAppState extends State<CodeMotionApp> {
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    setGlobalRouter(_routerDelegate);
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: CustomScrollView(
        slivers: [
          // 导航栏
          SliverToBoxAdapter(
            child: _buildNavBar(context, colorScheme),
          ),
          
          // Hero 区域
          SliverToBoxAdapter(
            child: _buildHero(context, colorScheme),
          ),
          
          // 特性介绍
          SliverToBoxAdapter(
            child: _buildFeatures(context, colorScheme),
          ),
          
          // 学习路径
          SliverToBoxAdapter(
            child: _buildLearningPath(context, colorScheme),
          ),
          
          // 页脚
          SliverToBoxAdapter(
            child: _buildFooter(context, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
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
          
          // 导航链接
          Row(
            children: [
              _navLink('首页', isActive: true, onTap: () => globalRouter.navigateToHome()),
              const SizedBox(width: 32),
              _navLink('课程', onTap: () => globalRouter.navigateToCourses()),
              const SizedBox(width: 32),
              _navLink('可视化', onTap: () => globalRouter.navigateToVisualize()),
              const SizedBox(width: 32),
              _navLink('关于'),
              const SizedBox(width: 48),
              ElevatedButton(
                onPressed: () => globalRouter.navigateToCourses(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('开始学习'),
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

  Widget _buildHero(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
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
          
          // 主标题
          Text(
            '优雅地掌握\nC++ 编程之美',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 副标题
          Text(
            '通过交互式可视化演示，直观理解算法原理\n从基础语法到高级特性，循序渐进地提升你的编程能力',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // 按钮组
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('立即开始学习', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('查看课程大纲', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          
          const SizedBox(height: 80),
          
          // 代码预览卡片
          Container(
            width: 700,
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
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF5F57), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF28CA41), shape: BoxShape.circle)),
                    const Spacer(),
                    Text('main.cpp', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCodeBlock(),
              ],
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

  Widget _buildFeatures(BuildContext context, ColorScheme colorScheme) {
    final features = [
      {'icon': Icons.school_outlined, 'title': '系统化课程', 'desc': '从零基础到进阶，循序渐进的学习路径'},
      {'icon': Icons.play_circle_outline, 'title': '可视化演示', 'desc': '动态展示算法执行过程，直观理解原理'},
      {'icon': Icons.code, 'title': '交互式代码', 'desc': '边学边练，在线编写和运行代码'},
      {'icon': Icons.psychology_outlined, 'title': '思维提升', 'desc': '培养编程思维和解决问题的能力'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      child: Column(
        children: [
          Text(
            '为什么选择 CodeMotion？',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '我们为你提供最优质的学习体验',
            style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: features.map((f) => _buildFeatureCard(context, colorScheme, f)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, ColorScheme colorScheme, Map<String, dynamic> feature) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(feature['icon'], color: colorScheme.primary, size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            feature['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature['desc'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningPath(BuildContext context, ColorScheme colorScheme) {
    final stages = [
      {'num': '01', 'title': '基础语法', 'desc': '变量、数据类型、控制流', 'color': const Color(0xFF6366F1)},
      {'num': '02', 'title': '面向对象', 'desc': '类、对象、继承、多态', 'color': const Color(0xFFEC4899)},
      {'num': '03', 'title': 'STL 容器', 'desc': 'vector、map、set、算法', 'color': const Color(0xFF14B8A6)},
      {'num': '04', 'title': '算法进阶', 'desc': '排序、查找、动态规划', 'color': const Color(0xFFF59E0B)},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      child: Column(
        children: [
          Text(
            '学习路径',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '四个阶段，全面掌握 C++',
            style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              return _buildPathStage(context, stage, index, stages.length);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPathStage(BuildContext context, Map<String, dynamic> stage, int index, int total) {
    return Row(
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (stage['color'] as Color).withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stage['num'],
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: stage['color'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                stage['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stage['desc'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        if (index < total - 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward, color: Colors.white.withValues(alpha: 0.2), size: 24),
          ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
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
