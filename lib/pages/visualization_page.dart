// Visualization Page - Sorting and Searching Algorithm Visualization
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/design_system.dart';
import '../design/responsive.dart';
import '../design/visualization/array_bar.dart';
import '../design/visualization/search_bar.dart';
import '../design/visualization/visualization_controls.dart';
import '../design/visualization/code_highlight.dart';
import '../design/visualization/step_indicator.dart';
import '../models/algorithm_model.dart';
import '../models/visualization_state.dart';
import '../content/algorithms/searching.dart';
import '../app_router.dart';
import 'course_detail_page.dart';

/// Visualization mode enum
enum VisualizationMode {
  sorting('排序算法'),
  searching('查找算法');

  const VisualizationMode(this.label);
  final String label;
}

/// Search visualization state
class SearchVisualizationState {
  final SearchAlgorithm? algorithm;
  final List<int> originalArray;
  final List<int> currentArray;
  final List<SearchBarState> barStates;
  final List<SearchStep> steps;
  final int currentStepIndex;
  final double speed;
  final SearchStep? currentStep;
  final int? target;

  const SearchVisualizationState({
    this.algorithm,
    this.originalArray = const [],
    this.currentArray = const [],
    this.barStates = const [],
    this.steps = const [],
    this.currentStepIndex = 0,
    this.speed = 1.0,
    this.currentStep,
    this.target,
  });

  int get totalSteps => steps.length;
  bool get canStepForward => currentStepIndex < steps.length - 1;
  bool get canStepBackward => currentStepIndex > 0;
  int? get leftIndex => currentStep?.left;
  int? get rightIndex => currentStep?.right;
  int? get midIndex => currentStep?.mid;
}

/// Search visualization notifier
class SearchVisualizationNotifier {
  SearchVisualizationState _state = const SearchVisualizationState();

  SearchVisualizationState get state => _state;

  void setAlgorithm(SearchAlgorithm algorithm, List<int> array, int target) {
    final steps = algorithm == SearchAlgorithm.sequentialSearch
        ? generateSequentialSearch(array, target)
        : generateBinarySearch(array, target);
    final firstStep = steps.isNotEmpty ? steps[0] : null;
    _state = SearchVisualizationState(
      algorithm: algorithm,
      originalArray: List.from(array),
      currentArray: firstStep?.arrayState ?? List.from(array),
      barStates: firstStep?.barStates ?? List.filled(array.length, SearchBarState.defaultState),
      steps: steps,
      currentStepIndex: 0,
      speed: _state.speed,
      currentStep: firstStep,
      target: target,
    );
  }

  void play() {
    if (_state.steps.isEmpty) return;
    _state = _state;
  }

  void pause() {
    _state = _state;
  }

  void stepForward() {
    if (_state.currentStepIndex >= _state.steps.length - 1) return;
    _advanceStep();
  }

  void stepBackward() {
    if (_state.currentStepIndex <= 0) return;
    final newIndex = _state.currentStepIndex - 1;
    final step = _state.steps[newIndex];
    _state = _state.copyWith(
      currentStepIndex: newIndex,
      currentArray: step.arrayState,
      barStates: step.barStates,
      currentStep: step,
    );
  }

  void _advanceStep() {
    final nextIndex = _state.currentStepIndex + 1;
    if (nextIndex >= _state.steps.length) return;
    final step = _state.steps[nextIndex];
    _state = _state.copyWith(
      currentStepIndex: nextIndex,
      currentArray: step.arrayState,
      barStates: step.barStates,
      currentStep: step,
    );
  }

  void setSpeed(double speed) {
    _state = SearchVisualizationState(
      algorithm: _state.algorithm,
      originalArray: _state.originalArray,
      currentArray: _state.currentArray,
      barStates: _state.barStates,
      steps: _state.steps,
      currentStepIndex: _state.currentStepIndex,
      speed: speed,
      currentStep: _state.currentStep,
      target: _state.target,
    );
  }

  void reset() {
    if (_state.algorithm == null) return;
    final steps = _state.algorithm == SearchAlgorithm.sequentialSearch
        ? generateSequentialSearch(_state.originalArray, _state.target ?? 0)
        : generateBinarySearch(_state.originalArray, _state.target ?? 0);
    final firstStep = steps.isNotEmpty ? steps[0] : null;
    _state = SearchVisualizationState(
      algorithm: _state.algorithm,
      originalArray: _state.originalArray,
      currentArray: firstStep?.arrayState ?? List.from(_state.originalArray),
      barStates: firstStep?.barStates ?? List.filled(_state.originalArray.length, SearchBarState.defaultState),
      steps: steps,
      currentStepIndex: 0,
      speed: _state.speed,
      currentStep: firstStep,
      target: _state.target,
    );
  }

  bool tick() {
    if (_state.currentStepIndex >= _state.steps.length - 1) return false;
    _advanceStep();
    return true;
  }
}

extension on SearchVisualizationState {
  SearchVisualizationState copyWith({
    SearchAlgorithm? algorithm,
    List<int>? originalArray,
    List<int>? currentArray,
    List<SearchBarState>? barStates,
    List<SearchStep>? steps,
    int? currentStepIndex,
    double? speed,
    SearchStep? currentStep,
    int? target,
  }) {
    return SearchVisualizationState(
      algorithm: algorithm ?? this.algorithm,
      originalArray: originalArray ?? this.originalArray,
      currentArray: currentArray ?? this.currentArray,
      barStates: barStates ?? this.barStates,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      speed: speed ?? this.speed,
      currentStep: currentStep ?? this.currentStep,
      target: target ?? this.target,
    );
  }
}

class VisualizationPage extends StatefulWidget {
  const VisualizationPage({super.key});

  @override
  State<VisualizationPage> createState() => _VisualizationPageState();
}

class _VisualizationPageState extends State<VisualizationPage>
    with TickerProviderStateMixin {
  // Visualization mode
  VisualizationMode _mode = VisualizationMode.sorting;

  // Sorting state
  final VisualizationNotifier _sortNotifier = VisualizationNotifier();
  Timer? _timer;
  SortingAlgorithm _selectedSortAlgorithm = SortingAlgorithm.bubbleSort;
  List<int> _initialArray = [64, 34, 25, 12, 22, 11, 90];

  // Search state
  final SearchVisualizationNotifier _searchNotifier = SearchVisualizationNotifier();
  SearchAlgorithm _selectedSearchAlgorithm = SearchAlgorithm.sequentialSearch;
  int _searchTarget = 25;

  // Animation
  String? _currentStepDescription;
  late AnimationController _stepDescController;
  late Animation<double> _stepDescFadeAnimation;
  late AnimationController _shuffleAnimController;
  late Animation<double> _shuffleScaleAnimation;

  // Loading state
  bool _isResetting = false;
  bool _isPlaying = false;

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
    _shuffleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shuffleScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 0.97), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.97, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shuffleAnimController,
      curve: Curves.easeInOut,
    ));
    _initializeAlgorithm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stepDescController.dispose();
    _shuffleAnimController.dispose();
    super.dispose();
  }

  void _initializeAlgorithm() {
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.setAlgorithm(_selectedSortAlgorithm, List.from(_initialArray));
    } else {
      _searchNotifier.setAlgorithm(_selectedSearchAlgorithm, List.from(_initialArray), _searchTarget);
    }
  }

  void _onModeChanged(VisualizationMode mode) {
    if (mode == _mode) return;
    _stopTimer();
    setState(() {
      _mode = mode;
    });
    _initializeAlgorithm();
  }

  void _startTimer() {
    _timer?.cancel();
    final speed = _mode == VisualizationMode.sorting
        ? _sortNotifier.state.speed
        : _searchNotifier.state.speed;
    final interval = Duration(milliseconds: (500 / speed).round());
    _timer = Timer.periodic(interval, (_) {
      bool hasNext;
      if (_mode == VisualizationMode.sorting) {
        hasNext = _sortNotifier.tick();
      } else {
        hasNext = _searchNotifier.tick();
      }
      if (!hasNext) {
        _timer?.cancel();
        setState(() => _isPlaying = false);
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
    String? newDesc;
    if (_mode == VisualizationMode.sorting) {
      newDesc = _sortNotifier.state.currentStep?.description;
    } else {
      newDesc = _searchNotifier.state.currentStep?.description;
    }
    if (newDesc != null && newDesc != _currentStepDescription) {
      _currentStepDescription = newDesc;
      _stepDescController.forward(from: 0.0);
    }
  }

  void _onPlay() {
    setState(() => _isPlaying = true);
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.play();
    } else {
      _searchNotifier.play();
    }
    _startTimer();
  }

  void _onPause() {
    _stopTimer();
    setState(() => _isPlaying = false);
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.pause();
    } else {
      _searchNotifier.pause();
    }
  }

  void _onStepForward() {
    _stopTimer();
    setState(() => _isPlaying = false);
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.stepForward();
    } else {
      _searchNotifier.stepForward();
    }
    _updateStepDescription();
    setState(() {});
  }

  void _onStepBackward() {
    _stopTimer();
    setState(() => _isPlaying = false);
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.stepBackward();
    } else {
      _searchNotifier.stepBackward();
    }
    _updateStepDescription();
    setState(() {});
  }

  void _onReset() {
    setState(() {
      _isResetting = true;
      _isPlaying = false;
    });
    _stopTimer();
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.reset();
    } else {
      _searchNotifier.reset();
    }
    _currentStepDescription = null;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isResetting = false);
        _showToast('重置成功');
      }
    });
  }

  void _onSpeedChanged(double speed) {
    if (_mode == VisualizationMode.sorting) {
      _sortNotifier.setSpeed(speed);
    } else {
      _searchNotifier.setSpeed(speed);
    }
    if (_isPlaying) {
      _stopTimer();
      _startTimer();
    }
    setState(() {});
  }

  void _onSortAlgorithmChanged(SortingAlgorithm? algorithm) {
    if (algorithm == null) return;
    _stopTimer();
    setState(() {
      _selectedSortAlgorithm = algorithm;
    });
    _sortNotifier.setAlgorithm(algorithm, List.from(_initialArray));
    _currentStepDescription = null;
  }

  void _onSearchAlgorithmChanged(SearchAlgorithm? algorithm) {
    if (algorithm == null) return;
    _stopTimer();
    setState(() {
      _selectedSearchAlgorithm = algorithm;
    });
    _searchNotifier.setAlgorithm(algorithm, List.from(_initialArray), _searchTarget);
    _currentStepDescription = null;
  }

  void _onShuffleArray() {
    _stopTimer();
    setState(() => _isPlaying = false);
    final shuffled = List<int>.from(_initialArray)..shuffle();
    _shuffleAnimController.forward(from: 0);
    setState(() {
      _initialArray = shuffled;
    });
    _initializeAlgorithm();
    _showToast('数组已随机');
  }

  void _onTargetChanged(int target) {
    _stopTimer();
    setState(() {
      _searchTarget = target;
    });
    _searchNotifier.setAlgorithm(_selectedSearchAlgorithm, List.from(_initialArray), target);
    _currentStepDescription = null;
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
                _initializeAlgorithm();
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

  void _showSearchTargetDialog() {
    final controller = TextEditingController(text: '$_searchTarget');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          '设置查找目标',
          style: AppFonts.titleLarge(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '输入要查找的目标值：',
              style: AppFonts.bodyMedium(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: AppFonts.codeMedium(color: Colors.white),
              decoration: InputDecoration(
                hintText: '例如: 25',
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
              keyboardType: TextInputType.number,
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
                final target = int.parse(text);
                Navigator.pop(context);
                _onTargetChanged(target);
                _showToast('目标值已设为 $target');
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

  // Get current speed from appropriate notifier
  double get _currentSpeed {
    return _mode == VisualizationMode.sorting
        ? _sortNotifier.state.speed
        : _searchNotifier.state.speed;
  }

  // Get current step info
  int get _currentStepIndex {
    return _mode == VisualizationMode.sorting
        ? _sortNotifier.state.currentStepIndex
        : _searchNotifier.state.currentStepIndex;
  }

  int get _totalSteps {
    return _mode == VisualizationMode.sorting
        ? _sortNotifier.state.totalSteps
        : _searchNotifier.state.totalSteps;
  }

  bool get _canStepForward {
    return _mode == VisualizationMode.sorting
        ? _sortNotifier.state.canStepForward
        : _searchNotifier.state.canStepForward;
  }

  bool get _canStepBackward {
    return _mode == VisualizationMode.sorting
        ? _sortNotifier.state.canStepBackward
        : _searchNotifier.state.canStepBackward;
  }

  @override
  Widget build(BuildContext context) {
    final hp = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hp, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildModeSelector(),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _mode == VisualizationMode.sorting
                        ? KeyedSubtree(key: const ValueKey('sort'), child: _buildSortAlgorithmSelector())
                        : KeyedSubtree(key: const ValueKey('search'), child: _buildSearchAlgorithmSelector()),
                  ),
                  SizedBox(height: Responsive.isMobile(context) ? 16 : 20),
                  _buildRelatedCourse(),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildVisualizationArea(),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildControls(),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildCodePanel(),
                  SizedBox(height: Responsive.isMobile(context) ? 24 : 32),
                  _buildStepInfo(),
                  SizedBox(height: Responsive.isMobile(context) ? 40 : 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 4 : 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: VisualizationMode.values.map((mode) {
          final isSelected = mode == _mode;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              _onModeChanged(mode);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 32,
                vertical: isMobile ? 10 : 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: AppRadius.borderMd,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                mode.label,
                style: AppFonts.labelLarge(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSortAlgorithmSelector() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '选择排序算法',
            style: AppFonts.titleMedium(color: Colors.white),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 8 : 12,
            runSpacing: isMobile ? 8 : 12,
            children: SortingAlgorithm.values.map((algo) {
              final isSelected = algo == _selectedSortAlgorithm;
              return _SortAlgoCard(
                name: algo.name,
                complexity: algo.complexity,
                isSelected: isSelected,
                onTap: () => _onSortAlgorithmChanged(algo),
              );
            }).toList(),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            _selectedSortAlgorithm.description,
            style: AppFonts.bodyMedium(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAlgorithmSelector() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '选择查找算法',
            style: AppFonts.titleMedium(color: Colors.white),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 8 : 12,
            runSpacing: isMobile ? 8 : 12,
            children: SearchAlgorithm.values.map((algo) {
              final isSelected = algo == _selectedSearchAlgorithm;
              return _SortAlgoCard(
                name: algo.name,
                complexity: algo.complexity,
                isSelected: isSelected,
                onTap: () => _onSearchAlgorithmChanged(algo),
              );
            }).toList(),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            _selectedSearchAlgorithm.description,
            style: AppFonts.bodyMedium(color: AppColors.textSecondary),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          _buildTargetInput(),
        ],
      ),
    );
  }

  Widget _buildTargetInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '目标值: ',
          style: AppFonts.labelLarge(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppRadius.borderSm,
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '$_searchTarget',
            style: AppFonts.codeMedium(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _showSearchTargetDialog,
          icon: const Icon(Icons.edit, size: 14),
          label: const Text('修改'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedCourse() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 20.0;

    final courseId = _mode == VisualizationMode.sorting
        ? 'algorithms_sorting'
        : 'algorithms_searching';
    final courseName = _mode == VisualizationMode.sorting
        ? '排序算法'
        : '查找算法';
    final courseIcon = _mode == VisualizationMode.sorting
        ? Icons.sort
        : Icons.search;
    final heroTag = 'course-hero-$courseName';

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: heroTag,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(courseIcon, color: AppColors.warning, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '关联课程',
                  style: AppFonts.labelMedium(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  courseName,
                  style: AppFonts.labelLarge(color: Colors.white),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return CourseDetailPage(
                      courseId: courseId,
                      heroIcon: courseIcon,
                      heroTitle: courseName,
                    );
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutQuart,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
                        alignment: Alignment.topCenter,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        ),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '查看课程',
                    style: AppFonts.labelMedium(color: AppColors.warning),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: AppColors.warning, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationArea() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 32.0;
    final chartHeight = isMobile ? 200.0 : 280.0;
    final barWidth = isMobile ? 28.0 : 44.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '可视化演示',
                  style: AppFonts.titleMedium(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: AnimatedBuilder(
              animation: _shuffleScaleAnimation,
              builder: (context, chartChild) {
                return Transform.scale(
                  scale: _shuffleScaleAnimation.value,
                  child: _mode == VisualizationMode.sorting
                      ? KeyedSubtree(key: const ValueKey('sort-chart'), child: _buildSortingChart(chartHeight, barWidth))
                      : KeyedSubtree(key: const ValueKey('search-chart'), child: _buildSearchChart(chartHeight, barWidth)),
                );
              },
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildSortingChart(double chartHeight, double barWidth) {
    final state = _sortNotifier.state;
    return SizedBox(
      height: chartHeight,
      child: ArrayBarChart(
        values: state.currentArray,
        states: state.barStates,
        barWidth: barWidth,
        showLabels: true,
      ),
    );
  }

  Widget _buildSearchChart(double chartHeight, double barWidth) {
    final state = _searchNotifier.state;
    final stepDuration = state.currentStep?.animationDurationMs ?? 200;
    return SizedBox(
      height: chartHeight,
      child: SearchBarChart(
        values: state.currentArray,
        barStates: state.barStates,
        barWidth: barWidth,
        showLabels: true,
        animationDuration: Duration(milliseconds: stepDuration),
        leftIndex: state.leftIndex,
        rightIndex: state.rightIndex,
        midIndex: state.midIndex,
      ),
    );
  }

  Widget _buildLegend() {
    final isMobile = Responsive.isMobile(context);
    if (_mode == VisualizationMode.sorting) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: isMobile ? 12 : 24,
        runSpacing: isMobile ? 8 : 0,
        children: [
          _legendItem(AppColors.vizDefault, '默认'),
          _legendItem(AppColors.vizComparing, '比较中'),
          _legendItem(AppColors.vizSwapping, '交换中'),
          _legendItem(AppColors.vizPivot, '基准'),
          _legendItem(AppColors.vizSorted, '已完成'),
          _legendItem(AppColors.vizHighlight, '高亮'),
        ],
      );
    } else {
      return const SearchLegend();
    }
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

  Widget _buildControls() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          if (_isPlaying)
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.speed, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '当前速度: ${_currentSpeed}x',
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
                  isPlaying: _isPlaying,
                  onPlay: _onPlay,
                  onPause: _onPause,
                  onStepForward: _canStepForward ? _onStepForward : null,
                  onStepBackward: _canStepBackward ? _onStepBackward : null,
                  onReset: _isResetting ? null : _onReset,
                  speed: _currentSpeed,
                  onSpeedChanged: _isPlaying ? null : _onSpeedChanged,
                  showSpeedControl: true,
                  showStepControls: true,
                  isStepForwardEnabled: _canStepForward,
                  isStepBackwardEnabled: _canStepBackward,
                ),
              ),
            ],
          ),
          if (!_isPlaying) ...[
            SizedBox(height: isMobile ? 12 : 16),
            _buildSpeedSlider(),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeedSlider() {
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
              value: _currentSpeed,
              min: 0.25,
              max: 2.0,
              divisions: 7,
              onChanged: _isPlaying ? null : _onSpeedChanged,
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
            '${_currentSpeed}x',
            style: AppFonts.labelMedium(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCodePanel() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 12.0 : 16.0;
    final fontSize = isMobile ? 11.0 : 13.0;

    return Container(
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.code, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  _mode == VisualizationMode.sorting
                      ? '算法代码 - ${_selectedSortAlgorithm.name}'
                      : '算法代码 - ${_selectedSearchAlgorithm.name}',
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
                code: _getAlgorithmCode(),
                highlightedLine: _getHighlightedLine(),
                showLineNumbers: true,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAlgorithmCode() {
    if (_mode == VisualizationMode.sorting) {
      switch (_selectedSortAlgorithm) {
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
        case SortingAlgorithm.heapSort:
          return '''void heapify(vector<int>& arr, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    if (left < n && arr[left] > arr[largest])
        largest = left;
    if (right < n && arr[right] > arr[largest])
        largest = right;
    if (largest != i) {
        swap(arr[i], arr[largest]);
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(arr, n, i);
    for (int i = n - 1; i > 0; i--) {
        swap(arr[0], arr[i]);
        heapify(arr, i, 0);
    }
}''';
      }
    } else {
      switch (_selectedSearchAlgorithm) {
        case SearchAlgorithm.sequentialSearch:
          return '''int sequentialSearch(const vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}''';
        case SearchAlgorithm.binarySearch:
          return '''int binarySearch(const vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}''';
      }
    }
  }

  int? _getHighlightedLine() {
    if (_mode == VisualizationMode.sorting) {
      return _sortNotifier.state.currentStep?.codeLine;
    } else {
      return _searchNotifier.state.currentStep?.codeLine;
    }
  }

  Widget _buildStepInfo() {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StepIndicator(
            currentStep: _currentStepIndex + 1,
            totalSteps: _totalSteps,
            labelFormat: StepLabelFormat.fraction,
          ),
          if (_currentStepDescription != null) ...[
            SizedBox(height: isMobile ? 12 : 16),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStepTypeBadge(),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _stepDescFadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _stepDescFadeAnimation,
                        child: Text(
                          _currentStepDescription!,
                          style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepTypeBadge(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _stepDescFadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _stepDescFadeAnimation,
                          child: Text(
                            _currentStepDescription!,
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

  Widget _buildStepTypeBadge() {
    Color color;
    String label;

    if (_mode == VisualizationMode.sorting) {
      final stepType = _sortNotifier.state.currentStep?.type;
      switch (stepType) {
        case SortStepType.compare:
          color = AppColors.vizComparing;
          label = '比较';
          break;
        case SortStepType.swap:
          color = AppColors.vizSwapping;
          label = '交换';
          break;
        case SortStepType.setPivot:
          color = AppColors.vizPivot;
          label = '设置基准';
          break;
        case SortStepType.overwrite:
          color = AppColors.vizHighlight;
          label = '覆盖';
          break;
        case SortStepType.complete:
          color = AppColors.vizSorted;
          label = '完成';
          break;
        default:
          color = AppColors.textSecondary;
          label = '进行中';
      }
    } else {
      final stepType = _searchNotifier.state.currentStep?.type;
      switch (stepType) {
        case SearchActionType.comparing:
          color = AppColors.vizComparing;
          label = '比较';
          break;
        case SearchActionType.found:
          color = AppColors.vizSorted;
          label = '找到';
          break;
        case SearchActionType.eliminated:
          color = AppColors.textDisabled;
          label = '已排除';
          break;
        case SearchActionType.searching:
          color = AppColors.primary;
          label = '查找中';
          break;
        case null:
          color = AppColors.textSecondary;
          label = '进行中';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderXs,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppFonts.labelMedium(color: color),
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
        _navLink('首页', isActive: false,
            onTap: () => globalNavigator.navigateToHome()),
        const SizedBox(width: 32),
        _navLink('课程', isActive: false,
            onTap: () => globalNavigator.navigateToCourses()),
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
}

/// A card widget for selecting an algorithm with hover effects.
/// Used for both sorting and searching algorithm selection.
class _SortAlgoCard extends StatefulWidget {
  const _SortAlgoCard({
    required this.name,
    required this.complexity,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String complexity;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SortAlgoCard> createState() => _SortAlgoCardState();
}

class _SortAlgoCardState extends State<_SortAlgoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: _isHovered ? 100 : 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : _isHovered
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
            borderRadius: AppRadius.borderSm,
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : _isHovered
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: _isHovered && !widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.03, 1.03, 1.0)
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.name,
                style: AppFonts.labelLarge(
                  color: widget.isSelected
                      ? AppColors.primary
                      : _isHovered
                          ? AppColors.primaryLight
                          : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: _isHovered ? 100 : 200),
                style: AppFonts.bodySmall(
                  color: widget.isSelected
                      ? AppColors.primary.withValues(alpha: 0.8)
                      : AppColors.textTertiary,
                ),
                child: Text(widget.complexity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toast notification widget — shows a brief success/info message overlay.
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
