// Searching Algorithm Content and Visualization Data
import '../course_data.dart';

/// Types of actions in search visualization
enum SearchActionType {
  comparing,
  found,
  eliminated,
  searching,
}

/// A single step in the search algorithm visualization
class SearchStep {
  final List<int> arrayState;
  final List<SearchBarState> barStates;
  final int? currentIndex;
  final int? left;
  final int? right;
  final int? mid;
  final SearchActionType type;
  final String description;
  final int codeLine;
  final int? target;

  const SearchStep({
    required this.arrayState,
    required this.barStates,
    this.currentIndex,
    this.left,
    this.right,
    this.mid,
    required this.type,
    required this.description,
    required this.codeLine,
    this.target,
  });
}

/// Bar states for search visualization
enum SearchBarState {
  defaultState,
  comparing,
  current,
  eliminated,
  found,
  leftPointer,
  rightPointer,
  midPointer,
}

/// Supported search algorithms
enum SearchAlgorithm {
  sequentialSearch('顺序查找', 'O(n)', '从数组第一个元素开始逐个比较，适合小规模数据。'),
  binarySearch('二分查找', 'O(log n)', '在有序数组中每次将范围缩小一半，效率高。');

  const SearchAlgorithm(this.name, this.complexity, this.description);
  final String name;
  final String complexity;
  final String description;
}

/// Sequential search step generator
List<SearchStep> generateSequentialSearch(List<int> arr, int target) {
  final steps = <SearchStep>[];
  final states = List.filled(arr.length, SearchBarState.defaultState);

  steps.add(SearchStep(
    arrayState: List.from(arr),
    barStates: List.from(states),
    type: SearchActionType.searching,
    description: '开始顺序查找，目标值: $target',
    codeLine: 1,
    target: target,
  ));

  for (int i = 0; i < arr.length; i++) {
    final newStates = List<SearchBarState>.from(states);
    newStates[i] = SearchBarState.comparing;
    steps.add(SearchStep(
      arrayState: List.from(arr),
      barStates: List.from(newStates),
      currentIndex: i,
      type: SearchActionType.comparing,
      description: '比较 arr[$i]=${arr[i]} 与目标值 $target',
      codeLine: 3,
      target: target,
    ));

    if (arr[i] == target) {
      final foundStates = List<SearchBarState>.from(newStates);
      foundStates[i] = SearchBarState.found;
      steps.add(SearchStep(
        arrayState: List.from(arr),
        barStates: List.from(foundStates),
        currentIndex: i,
        type: SearchActionType.found,
        description: '找到目标！arr[$i]=${arr[i]} == $target',
        codeLine: 4,
        target: target,
      ));
      return steps;
    }

    newStates[i] = SearchBarState.eliminated;
    steps.add(SearchStep(
      arrayState: List.from(arr),
      barStates: List.from(newStates),
      currentIndex: i,
      type: SearchActionType.eliminated,
      description: 'arr[$i]=${arr[i]} != $target，继续查找',
      codeLine: 6,
      target: target,
    ));
  }

  steps.add(SearchStep(
    arrayState: List.from(arr),
    barStates: List.filled(arr.length, SearchBarState.eliminated),
    type: SearchActionType.eliminated,
    description: '未找到目标值 $target',
    codeLine: 7,
    target: target,
  ));
  return steps;
}

/// Binary search step generator
List<SearchStep> generateBinarySearch(List<int> arr, int target) {
  final steps = <SearchStep>[];
  final sortedArr = List<int>.from(arr)..sort();
  final states = List.filled(sortedArr.length, SearchBarState.defaultState);

  steps.add(SearchStep(
    arrayState: List.from(sortedArr),
    barStates: List.from(states),
    type: SearchActionType.searching,
    description: '开始二分查找，目标值: $target（数组已排序）',
    codeLine: 1,
    target: target,
  ));

  int left = 0, right = sortedArr.length - 1;

  while (left <= right) {
    final newStates = List<SearchBarState>.from(states);
    newStates[left] = SearchBarState.leftPointer;
    newStates[right] = SearchBarState.rightPointer;
    steps.add(SearchStep(
      arrayState: List.from(sortedArr),
      barStates: List.from(newStates),
      left: left,
      right: right,
      type: SearchActionType.searching,
      description: '设置查找区间: left=$left, right=$right',
      codeLine: 3,
      target: target,
    ));

    final mid = left + (right - left) ~/ 2;
    final midStates = List<SearchBarState>.from(newStates);
    midStates[mid] = SearchBarState.midPointer;
    steps.add(SearchStep(
      arrayState: List.from(sortedArr),
      barStates: List.from(midStates),
      left: left,
      right: right,
      mid: mid,
      type: SearchActionType.searching,
      description: '计算中间位置: mid=$mid, arr[$mid]=${sortedArr[mid]}',
      codeLine: 4,
      target: target,
    ));

    midStates[mid] = SearchBarState.comparing;
    steps.add(SearchStep(
      arrayState: List.from(sortedArr),
      barStates: List.from(midStates),
      left: left,
      right: right,
      mid: mid,
      type: SearchActionType.comparing,
      description: '比较 arr[$mid]=${sortedArr[mid]} 与目标值 $target',
      codeLine: 5,
      target: target,
    ));

    if (sortedArr[mid] == target) {
      final foundStates = List<SearchBarState>.from(midStates);
      foundStates[mid] = SearchBarState.found;
      for (int i = 0; i < sortedArr.length; i++) {
        if (i != mid) foundStates[i] = SearchBarState.eliminated;
      }
      steps.add(SearchStep(
        arrayState: List.from(sortedArr),
        barStates: List.from(foundStates),
        left: left,
        right: right,
        mid: mid,
        type: SearchActionType.found,
        description: '找到目标！arr[$mid]=${sortedArr[mid]} == $target',
        codeLine: 6,
        target: target,
      ));
      return steps;
    } else if (sortedArr[mid] < target) {
      for (int i = left; i <= mid; i++) {
        midStates[i] = SearchBarState.eliminated;
      }
      steps.add(SearchStep(
        arrayState: List.from(sortedArr),
        barStates: List.from(midStates),
        left: left,
        right: right,
        mid: mid,
        type: SearchActionType.eliminated,
        description: 'arr[$mid]=${sortedArr[mid]} < $target，排除左半区，搜索右半区',
        codeLine: 8,
        target: target,
      ));
      left = mid + 1;
    } else {
      for (int i = mid; i <= right; i++) {
        midStates[i] = SearchBarState.eliminated;
      }
      steps.add(SearchStep(
        arrayState: List.from(sortedArr),
        barStates: List.from(midStates),
        left: left,
        right: right,
        mid: mid,
        type: SearchActionType.eliminated,
        description: 'arr[$mid]=${sortedArr[mid]} > $target，排除右半区，搜索左半区',
        codeLine: 10,
        target: target,
      ));
      right = mid - 1;
    }
  }

  steps.add(SearchStep(
    arrayState: List.from(sortedArr),
    barStates: List.filled(sortedArr.length, SearchBarState.eliminated),
    type: SearchActionType.eliminated,
    description: '未找到目标值 $target (left=$left > right=$right)',
    codeLine: 12,
    target: target,
  ));
  return steps;
}

/// Searching Algorithms Chapter
const chapterSearchingAlgorithms = CourseChapter(
  id: 'algorithms_searching',
  title: '查找算法',
  description: '学习顺序查找和二分查找算法，理解查找效率的重要性。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'searching_sequential',
      title: '顺序查找',
      content: '# 顺序查找\n\n顺序查找是最简单直观的查找算法，从数组的第一个元素开始逐个比较直到找到目标。\n\n## 复杂度\n\n最好 O(1)，最坏 O(n)，平均 O(n)。空间复杂度 O(1)。',
      codeExamples: [
        CodeExample(
          title: '顺序查找',
          code: '''int sequentialSearch(const vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}''',
          description: '顺序查找实现。',
          output: '2',
        ),
      ],
      keyPoints: ['从第一个元素逐个比较', '时间复杂度 O(n)'],
    ),
    CourseLesson(
      id: 'searching_binary',
      title: '二分查找',
      content: '# 二分查找\n\n二分查找适用于有序数组，每次将搜索范围缩小一半。\n\n## 前提\n\n数组必须有序。\n\n## 复杂度\n\n时间复杂度 O(log n)。',
      codeExamples: [
        CodeExample(
          title: '二分查找',
          code: '''int binarySearch(const vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}''',
          description: '二分查找实现。',
          output: '2',
        ),
      ],
      keyPoints: ['要求数组有序', '时间复杂度 O(log n)'],
    ),
  ],
);
