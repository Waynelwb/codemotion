// Visualization State Model - State management for algorithm visualization

import '../design/visualization/array_bar.dart';
import 'algorithm_model.dart';

/// Overall state of the visualization
enum VisualizationStatus {
  idle,     // Not started
  playing,  // Auto-playing
  paused,   // Paused mid-animation
  completed, // Animation finished
}

/// Current state of the algorithm visualization
class VisualizationState {
  final VisualizationStatus status;
  final SortingAlgorithm? algorithm;
  final List<int> originalArray;
  final List<int> currentArray;
  final List<BarState> barStates;
  final List<SortStep> steps;
  final int currentStepIndex;
  final double speed;
  final SortStep? currentStep;

  const VisualizationState({
    this.status = VisualizationStatus.idle,
    this.algorithm,
    this.originalArray = const [],
    this.currentArray = const [],
    this.barStates = const [],
    this.steps = const [],
    this.currentStepIndex = 0,
    this.speed = 1.0,
    this.currentStep,
  });

  VisualizationState copyWith({
    VisualizationStatus? status,
    SortingAlgorithm? algorithm,
    List<int>? originalArray,
    List<int>? currentArray,
    List<BarState>? barStates,
    List<SortStep>? steps,
    int? currentStepIndex,
    double? speed,
    SortStep? currentStep,
  }) {
    return VisualizationState(
      status: status ?? this.status,
      algorithm: algorithm ?? this.algorithm,
      originalArray: originalArray ?? this.originalArray,
      currentArray: currentArray ?? this.currentArray,
      barStates: barStates ?? this.barStates,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      speed: speed ?? this.speed,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  int get totalSteps => steps.length;
  bool get isPlaying => status == VisualizationStatus.playing;
  bool get isPaused => status == VisualizationStatus.paused;
  bool get isCompleted => status == VisualizationStatus.completed;
  bool get canStepForward => currentStepIndex < steps.length - 1;
  bool get canStepBackward => currentStepIndex > 0;
}

/// State notifier for visualization (simple ChangeNotifier alternative)
class VisualizationNotifier {
  VisualizationState _state;

  VisualizationNotifier() : _state = const VisualizationState();

  VisualizationState get state => _state;

  void setAlgorithm(SortingAlgorithm algorithm, List<int> array) {
    final steps = SortAlgorithmGenerator.generate(algorithm, array);
    final firstStep = steps.isNotEmpty ? steps[0] : null;
    _state = VisualizationState(
      status: VisualizationStatus.idle,
      algorithm: algorithm,
      originalArray: List.from(array),
      currentArray: firstStep?.arrayState ?? List.from(array),
      barStates: firstStep?.barStates ?? List.filled(array.length, BarState.defaultState),
      steps: steps,
      currentStepIndex: 0,
      speed: _state.speed,
      currentStep: firstStep,
    );
  }

  void play() {
    if (_state.steps.isEmpty) return;
    if (_state.isCompleted) reset();
    _state = _state.copyWith(status: VisualizationStatus.playing);
  }

  void pause() {
    if (!_state.isPlaying) return;
    _state = _state.copyWith(status: VisualizationStatus.paused);
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
      status: VisualizationStatus.paused,
    );
  }

  void _advanceStep() {
    final nextIndex = _state.currentStepIndex + 1;
    if (nextIndex >= _state.steps.length) {
      // At the end, show the final step's state
      final lastStep = _state.steps.isNotEmpty ? _state.steps.last : null;
      _state = _state.copyWith(
        status: VisualizationStatus.completed,
        currentStepIndex: _state.steps.length - 1,
        currentArray: lastStep?.arrayState ?? _state.currentArray,
        barStates: lastStep?.barStates ?? _state.barStates,
        currentStep: lastStep,
      );
      return;
    }
    final step = _state.steps[nextIndex];
    final isLast = nextIndex == _state.steps.length - 1;
    _state = _state.copyWith(
      currentStepIndex: nextIndex,
      currentArray: step.arrayState,
      barStates: step.barStates,
      currentStep: step,
      status: isLast ? VisualizationStatus.completed : (_state.isPlaying ? VisualizationStatus.playing : VisualizationStatus.paused),
    );
  }

  void setSpeed(double speed) {
    _state = _state.copyWith(speed: speed);
  }

  void reset() {
    if (_state.algorithm == null) return;
    final steps = SortAlgorithmGenerator.generate(_state.algorithm!, _state.originalArray);
    final firstStep = steps.isNotEmpty ? steps[0] : null;
    _state = VisualizationState(
      status: VisualizationStatus.idle,
      algorithm: _state.algorithm,
      originalArray: _state.originalArray,
      currentArray: firstStep?.arrayState ?? List.from(_state.originalArray),
      barStates: firstStep?.barStates ?? List.filled(_state.originalArray.length, BarState.defaultState),
      steps: steps,
      currentStepIndex: 0,
      speed: _state.speed,
      currentStep: firstStep,
    );
  }

  /// Called by timer to advance to next step
  bool tick() {
    if (!_state.isPlaying) return false;
    if (_state.currentStepIndex >= _state.steps.length - 1) {
      // Already at last step, just mark as completed
      final lastStep = _state.steps.isNotEmpty ? _state.steps.last : null;
      _state = _state.copyWith(
        status: VisualizationStatus.completed,
        currentArray: lastStep?.arrayState ?? _state.currentArray,
        barStates: lastStep?.barStates ?? _state.barStates,
        currentStep: lastStep,
      );
      return false;
    }
    _advanceStep();
    return true;
  }
}
