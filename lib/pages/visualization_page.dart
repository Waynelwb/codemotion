// Visualization Page - Sorting Algorithm Visualization Demo with enhanced UI
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/design_system.dart';
import '../design/responsive.dart';
import '../design/visualization/array_bar.dart';
import '../design/visualization/visualization_controls.dart';
import '../design/visualization/code_highlight.dart';
import '../design/visualization/step_indicator.dart';
import '../models/algorithm_model.dart';
import '../models/visualization_state.dart';

class VisualizationPage extends StatefulWidget {
  const VisualizationPage({super.key});

  @override
  State<VisualizationPage> createState() => _VisualizationPageState();
}

class _VisualizationPageState extends State<VisualizationPage>
    with TickerProviderStateMixin {
  final VisualizationNotifier _notifier = VisualizationNotifier();
  Timer? _timer;
  SortingAlgorithm _selectedAlgorithm = SortingAlgorithm.bubbleSort;
  List<int> _initialArray = [64, 34, 25, 12, 22, 11, 90];

  // Step description animation
  String? _currentStepDescription;
  late AnimationController _stepDescController;
  late Animation<double> _stepDescFadeAnimation;

  // Loading state for buttons
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _stepDescController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _stepDescFadeAnimation = CurvedAnimation(
      parent: _stepDescController,
      curve: Curves.easeInOut,
    );
    _initializeAlgorithm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stepDescController.dispose();
    super.dispose();
  }

  void _initializeAlgorithm() {
    _notifier.setAlgorithm(_selectedAlgorithm, List.from(_initialArray));
  }

  void _startTimer() {
    _timer?.cancel();
    final interval = Duration(milliseconds: (500 / _notifier.state.speed).round());
    _timer = Timer.periodic(interval, (_) {
      if (!_notifier.tick()) {
        _timer?.cancel();
      }
      if (mounted) {
        _updateStepDescription();
        setState(() {});
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _updateStepDescription() {
    final step = _notifier.state.currentStep;
    if (step != null && step.description != _currentStepDescription) {
      _currentStepDescription = step.description;
      _stepDescController.forward(from: 0.0);
    }
  }

  void _onPlay() {
    _notifier.play();
    _startTimer();
    setState(() {});
  }

  void _onPause() {
    _notifier.pause();
    _stopTimer();
    setState(() {});
  }

  void _onStepForward() {
    _stopTimer();
    _notifier.stepForward();
    _updateStepDescription();
    setState(() {});
  }

  void _onStepBackward() {
    _stopTimer();
    _notifier.stepBackward();
    _updateStepDescription();
    setState(() {});
  }

  void _onReset() {
    setState(() => _isResetting = true);
    _stopTimer();
    _notifier.reset();
    _currentStepDescription = null;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isResetting = false);
        _showToast('重置成功');
      }
    });
  }

  void _onSpeedChanged(double speed) {
    _notifier.setSpeed(speed);
    if (_notifier.state.isPlaying) {
      _stopTimer();
      _startTimer();
    }
    setState(() {});
  }

  void _onAlgorithmChanged(SortingAlgorithm? algorithm) {
    if (algorithm == null) return;
    _stopTimer();
    setState(() {
      _selectedAlgorithm = algorithm;
    });
    _notifier.setAlgorithm(algorithm, List.from(_initialArray));
    _currentStepDescription = null;
  }

  void _onShuffleArray() {
    _stopTimer();
    final shuffled = List<int>.from(_initialArray)..shuffle();
    setState(() {
      _initialArray = shuffled;
    });
    _notifier.setAlgorithm(_selectedAlgorithm, shuffled);
    _showToast('数组已随机');
  }

  void _showCustomArrayDialog() {
    final controller = TextEditingController(
      text: _initialArray.join(', '),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          '自定义数组',
          style: AppFonts.titleLarge(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '输入以逗号分隔的整数：',
              style: AppFonts.bodyMedium(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: AppFonts.codeMedium(color: Colors.white),
              decoration: InputDecoration(
                hintText: '例如: 64, 34, 25, 12, 22',
                hintStyle: AppFonts.codeMedium(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.codeBackground,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.borderSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.borderSm,
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: AppFonts.labelLarge(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              try {
                final numbers = text
                    .split(RegExp(r'[,\s]+'))
                    .where((s) => s.isNotEmpty)
                    .map((s) => int.parse(s))
                    .toList();

                if (numbers.isEmpty || numbers.length > 15) {
                  _showToast('请输入1-15个整数');
                  return;
                }

                Navigator.pop(context);
                _stopTimer();
                setState(() {
                  _initialArray = numbers;
                });
                _notifier.setAlgorithm(_selectedAlgorithm, List.from(_initialArray));
                _currentStepDescription = null;
                _showToast('自定义数组已应用');
              } catch (e) {
                _showToast('输入格式错误');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderSm,
              ),
            ),
            child: Text('应用', style: AppFonts.labelLarge(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final hp = Responsive.horizontalPadding(context);
    final vp = Responsive.verticalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hp, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAlgorithmSelector(),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildVisualizationArea(state),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildControls(state),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildCodePanel(state),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildStepInfo(state),
                  SizedBox(height: Responsive.isMobile(context) ? 40 : 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final hp = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hp, vertical: isMobile ? 16 : 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            if (!isMobile) _buildNavLinks(context),
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
        _navLink('课程', isActive: false),
        const SizedBox(width: 32),
        _navLink('可视化', isActive: true),
        const SizedBox(width: 32),
        _navLink('关于', isActive: false),
      ],
    );
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

  Widget _buildAlgorithmSelector() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择排序算法',
            style: AppFonts.titleMedium(color: Colors.white),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Wrap(
            spacing: isMobile ? 8 : 12,
            runSpacing: isMobile ? 8 : 12,
            children: SortingAlgorithm.values.map((algo) {
              final isSelected = algo == _selectedAlgorithm;
              return GestureDetector(
                onTap: () => _onAlgorithmChanged(algo),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: AppRadius.borderSm,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        algo.name,
                        style: AppFonts.labelLarge(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        algo.complexity,
                        style: AppFonts.bodySmall(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            _selectedAlgorithm.description,
            style: AppFonts.bodyMedium(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationArea(VisualizationState state) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 32.0;
    final chartHeight = isMobile ? 200.0 : 280.0;
    final barWidth = isMobile ? 28.0 : 44.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '可视化演示',
                  style: AppFonts.titleMedium(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showCustomArrayDialog,
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text('自定义'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onShuffleArray,
                        icon: const Icon(Icons.shuffle, size: 14),
                        label: const Text('随机'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceElevated,
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '可视化演示',
                  style: AppFonts.titleMedium(color: Colors.white),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _showCustomArrayDialog,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('自定义数组'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _onShuffleArray,
                      icon: const Icon(Icons.shuffle, size: 16),
                      label: const Text('重新随机'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceElevated,
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: isMobile ? 16 : 32),
          SizedBox(
            height: chartHeight,
            child: ArrayBarChart(
              values: state.currentArray,
              states: state.barStates,
              barWidth: barWidth,
              showLabels: true,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(AppColors.vizDefault, '默认'),
        const SizedBox(width: 24),
        _legendItem(AppColors.vizComparing, '比较中'),
        const SizedBox(width: 24),
        _legendItem(AppColors.vizSwapping, '交换中'),
        const SizedBox(width: 24),
        _legendItem(AppColors.vizPivot, '基准'),
        const SizedBox(width: 24),
        _legendItem(AppColors.vizSorted, '已完成'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppFonts.labelMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildControls(VisualizationState state) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          // Speed display
          if (state.isPlaying)
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.speed, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '当前速度: ${state.speed}x',
                    style: AppFonts.labelMedium(color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(播放中无法调节)',
                    style: AppFonts.bodySmall(color: AppColors.textDisabled),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: VisualizationControls(
                  isPlaying: state.isPlaying,
                  onPlay: _onPlay,
                  onPause: _onPause,
                  onStepForward: state.canStepForward ? _onStepForward : null,
                  onStepBackward: state.canStepBackward ? _onStepBackward : null,
                  onReset: _isResetting ? null : _onReset,
                  speed: state.speed,
                  onSpeedChanged: state.isPlaying ? null : _onSpeedChanged,
                  showSpeedControl: true,
                  showStepControls: true,
                  isStepForwardEnabled: state.canStepForward,
                  isStepBackwardEnabled: state.canStepBackward,
                ),
              ),
            ],
          ),
          // Speed slider (only when not playing)
          if (!state.isPlaying) ...[
            SizedBox(height: isMobile ? 12 : 16),
            _buildSpeedSlider(state),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeedSlider(VisualizationState state) {
    return Row(
      children: [
        const Icon(Icons.speed, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 12),
        Text(
          '速度调节',
          style: AppFonts.labelMedium(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: state.speed,
              min: 0.25,
              max: 2.0,
              divisions: 7,
              onChanged: state.isPlaying ? null : _onSpeedChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppRadius.borderXs,
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '${state.speed}x',
            style: AppFonts.labelMedium(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCodePanel(VisualizationState state) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 12.0 : 16.0;
    final fontSize = isMobile ? 11.0 : 13.0;

    return Container(
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                const Icon(Icons.code, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  '算法代码 - ${_selectedAlgorithm.name}',
                  style: AppFonts.titleMedium(color: Colors.white),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: CodeHighlight(
                code: _getAlgorithmCode(_selectedAlgorithm),
                highlightedLine: state.currentStep?.codeLine,
                showLineNumbers: true,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepInfo(VisualizationState state) {
    final step = state.currentStep;
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          StepIndicator(
            currentStep: state.currentStepIndex + 1,
            totalSteps: state.totalSteps,
            labelFormat: StepLabelFormat.fraction,
          ),
          if (step != null) ...[
            SizedBox(height: isMobile ? 12 : 16),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStepTypeColor(step.type).withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderXs,
                      border: Border.all(
                        color: _getStepTypeColor(step.type).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      step.type.label,
                      style: AppFonts.labelMedium(
                        color: _getStepTypeColor(step.type),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _stepDescFadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _stepDescFadeAnimation,
                        child: Text(
                          step.description,
                          style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStepTypeColor(step.type).withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderXs,
                      border: Border.all(
                        color: _getStepTypeColor(step.type).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      step.type.label,
                      style: AppFonts.labelMedium(
                        color: _getStepTypeColor(step.type),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _stepDescFadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _stepDescFadeAnimation,
                          child: Text(
                            step.description,
                            style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Color _getStepTypeColor(SortStepType type) {
    switch (type) {
      case SortStepType.compare:
        return AppColors.vizComparing;
      case SortStepType.swap:
        return AppColors.vizSwapping;
      case SortStepType.complete:
        return AppColors.vizSorted;
      case SortStepType.setPivot:
        return AppColors.vizPivot;
      case SortStepType.overwrite:
        return AppColors.vizHighlight;
    }
  }

  String _getAlgorithmCode(SortingAlgorithm algo) {
    switch (algo) {
      case SortingAlgorithm.bubbleSort:
        return '''void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}''';
      case SortingAlgorithm.selectionSort:
        return '''void selectionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        swap(arr[i], arr[minIdx]);
    }
}''';
      case SortingAlgorithm.insertionSort:
        return '''void insertionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}''';
      case SortingAlgorithm.quickSort:
        return '''void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        int pivot = arr[high];
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                swap(arr[i], arr[j]);
            }
        }
        swap(arr[i + 1], arr[high]);
        int pi = i + 1;
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}''';
      case SortingAlgorithm.mergeSort:
        return '''void merge(vector<int>& arr, int l, int m, int r) {
    vector<int> left(arr.begin() + l, arr.begin() + m + 1);
    vector<int> right(arr.begin() + m + 1, arr.begin() + r + 1);
    int i = 0, j = 0, k = l;
    while (i < left.size() && j < right.size()) {
        arr[k++] = (left[i] <= right[j]) ? left[i++] : right[j++];
    }
    while (i < left.size()) arr[k++] = left[i++];
    while (j < right.size()) arr[k++] = right[j++];
}

void mergeSort(vector<int>& arr, int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;
        mergeSort(arr, l, m);
        mergeSort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}''';
    }
  }
}

/// Toast notification widget
class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 32,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.message,
                    style: AppFonts.labelLarge(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========== SORT ARRAY BAR CHART WITH VALUE LABELS ==========

class _SortArrayBarChart extends StatelessWidget {
  const _SortArrayBarChart({required this.values, required this.states, this.comparingI, this.comparingJ, this.pivotIndex, required this.animationDuration});
  final List<int> values;
  final List<BarState> states;
  final int? comparingI, comparingJ, pivotIndex;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.codeBlock(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final state = index < states.length ? states[index] : BarState.defaultState;
          final isComparing = index == comparingI || index == comparingJ;
          final isPivot = index == pivotIndex;
          return Padding(padding: const EdgeInsets.only(left: 4, right: 4),
            child: _AnimatedSortBar(value: values[index], maxValue: maxValue, state: state, isComparing: isComparing, isPivot: isPivot, animationDuration: animationDuration));
        }),
      ),
    );
  }
}

class _AnimatedSortBar extends StatelessWidget {
  const _AnimatedSortBar({required this.value, required this.maxValue, required this.state, required this.isComparing, required this.isPivot, required this.animationDuration});
  final int value, maxValue;
  final BarState state;
  final bool isComparing, isPivot;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final heightFraction = maxValue > 0 ? value / maxValue : 0.0;
    final barColor = _getBarColor();
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text('$value', style: AppFonts.codeSmall(color: AppColors.textSecondary)),
      const SizedBox(height: 4),
      TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: heightFraction),
        duration: animationDuration, curve: Curves.easeInOut,
        builder: (context, fraction, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: fraction * 220 + 10,
            decoration: BoxDecoration(
              color: barColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              boxShadow: isComparing || state == BarState.swapping ? [BoxShadow(color: barColor.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)] : null,
            ),
          );
        }),
    ]);
  }

  Color _getBarColor() {
    if (isComparing) return AppColors.vizComparing;
    if (isPivot || state == BarState.pivot) return AppColors.vizPivot;
    switch (state) {
      case BarState.defaultState: return AppColors.vizDefault;
      case BarState.comparing: return AppColors.vizComparing;
      case BarState.swapping: return AppColors.vizSwapping;
      case BarState.sorted: return AppColors.vizSorted;
      case BarState.pivot: return AppColors.vizPivot;
      case BarState.highlighted: return AppColors.vizHighlight;
    }
  }
}

// ========== SEARCH ARRAY BAR CHART WITH POINTERS ==========
