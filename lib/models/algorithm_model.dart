// Algorithm Model - Sorting Algorithm Demo Data Models

import '../design/visualization/array_bar.dart';

/// Types of operations during sorting visualization
enum SortStepType {
  compare('比较'),
  swap('交换'),
  complete('完成'),
  setPivot('设置基准'),
  overwrite('覆盖');

  const SortStepType(this.label);
  final String label;
}

/// A single step in the sorting algorithm visualization
class SortStep {
  final List<int> arrayState;
  final List<BarState> barStates;
  final int? comparingI;
  final int? comparingJ;
  final int? pivotIndex;
  final SortStepType type;
  final String description;
  final int codeLine;

  const SortStep({
    required this.arrayState,
    required this.barStates,
    this.comparingI,
    this.comparingJ,
    this.pivotIndex,
    required this.type,
    required this.description,
    required this.codeLine,
  });
}

/// Supported sorting algorithms
enum SortingAlgorithm {
  bubbleSort('冒泡排序', 'O(n²)', '最基础的排序算法，通过相邻元素比较和交换将最大元素"冒泡"到序列末端。'),
  selectionSort('选择排序', 'O(n²)', '每次从未排序部分选择最小元素放到已排序部分末尾。'),
  insertionSort('插入排序', 'O(n²)', '将元素逐个插入已排序序列，像整理扑克牌一样。'),
  quickSort('快速排序', 'O(n log n)', '采用分治策略，选择基准元素将数组分区后递归排序。'),
  mergeSort('归并排序', 'O(n log n)', '分治思想，将数组递归拆分后合并，适合大规模数据。'),
  heapSort('堆排序', 'O(n log n)', '基于二叉堆数据结构，稳定 O(n log n) 时间复杂度，原地排序。');

  const SortingAlgorithm(this.name, this.complexity, this.description);
  final String name;
  final String complexity;
  final String description;
}

/// Generates all steps for a given sorting algorithm
class SortAlgorithmGenerator {
  static List<SortStep> generate(SortingAlgorithm algorithm, List<int> inputArray) {
    switch (algorithm) {
      case SortingAlgorithm.bubbleSort:
        return _generateBubbleSort(List.from(inputArray));
      case SortingAlgorithm.selectionSort:
        return _generateSelectionSort(List.from(inputArray));
      case SortingAlgorithm.insertionSort:
        return _generateInsertionSort(List.from(inputArray));
      case SortingAlgorithm.quickSort:
        return _generateQuickSort(List.from(inputArray));
      case SortingAlgorithm.mergeSort:
        return _generateMergeSort(List.from(inputArray));
      case SortingAlgorithm.heapSort:
        return _generateHeapSort(List.from(inputArray));
    }
  }

  static List<SortStep> _makeStates(
    List<int> arr,
    SortStepType type,
    String desc,
    int codeLine, {
    int? i,
    int? j,
    int? pivot,
  }) {
    final states = List<BarState>.filled(arr.length, BarState.defaultState);
    if (i != null) states[i] = BarState.comparing;
    if (j != null) states[j] = BarState.comparing;
    if (pivot != null) states[pivot] = BarState.pivot;
    if (type == SortStepType.swap) {
      if (i != null) states[i] = BarState.swapping;
      if (j != null) states[j] = BarState.swapping;
    }
    if (type == SortStepType.complete) {
      for (int k = 0; k < arr.length; k++) {
        states[k] = BarState.sorted;
      }
    }
    return [
      SortStep(
        arrayState: List.from(arr),
        barStates: List.from(states),
        comparingI: i,
        comparingJ: j,
        pivotIndex: pivot,
        type: type,
        description: desc,
        codeLine: codeLine,
      ),
    ];
  }

  static List<SortStep> _generateBubbleSort(List<int> arr) {
    final steps = <SortStep>[];
    final n = arr.length;

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始冒泡排序，外层循环 i=0', 1));

    for (int i = 0; i < n - 1; i++) {
      steps.addAll(_makeStates(arr, SortStepType.compare, '第 ${i + 1} 轮冒泡，内层循环 j=0', 2));

      for (int j = 0; j < n - i - 1; j++) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.compare,
          '比较 arr[$j]=${arr[j]} 和 arr[${j + 1}]=${arr[j + 1]}',
          3,
          i: j,
          j: j + 1,
        ));

        if (arr[j] > arr[j + 1]) {
          steps.addAll(_makeStates(
            arr,
            SortStepType.swap,
            '交换：${arr[j]} > ${arr[j + 1]}，执行 swap(arr[$j], arr[${j + 1}])',
            4,
            i: j,
            j: j + 1,
          ));
          final tmp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = tmp;
          steps.addAll(_makeStates(arr, SortStepType.swap, '交换完成', 5, i: j, j: j + 1));
        }
      }
    }

    steps.addAll(_makeStates(arr, SortStepType.complete, '冒泡排序完成！', 6));
    return steps;
  }

  static List<SortStep> _generateSelectionSort(List<int> arr) {
    final steps = <SortStep>[];
    final n = arr.length;

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始选择排序', 1));

    for (int i = 0; i < n - 1; i++) {
      int minIdx = i;
      steps.addAll(_makeStates(
        arr,
        SortStepType.compare,
        '第 ${i + 1} 轮：假设最小值在 index $minIdx (值为 ${arr[minIdx]})',
        2,
        i: i,
        j: minIdx,
      ));

      for (int j = i + 1; j < n; j++) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.compare,
          '比较 arr[$minIdx]=${arr[minIdx]} 和 arr[$j]=${arr[j]}',
          3,
          i: minIdx,
          j: j,
        ));

        if (arr[j] < arr[minIdx]) {
          minIdx = j;
          steps.addAll(_makeStates(
            arr,
            SortStepType.compare,
            '发现更小值 ${arr[minIdx]}，更新 minIdx=$minIdx',
            4,
            i: i,
            j: minIdx,
          ));
        }
      }

      if (minIdx != i) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.swap,
          '交换 arr[$i]=${arr[i]} 和 arr[$minIdx]=${arr[minIdx]}',
          5,
          i: i,
          j: minIdx,
        ));
        final tmp = arr[i];
        arr[i] = arr[minIdx];
        arr[minIdx] = tmp;
        steps.addAll(_makeStates(arr, SortStepType.swap, '交换完成', 6, i: i, j: minIdx));
      }
    }

    steps.addAll(_makeStates(arr, SortStepType.complete, '选择排序完成！', 7));
    return steps;
  }

  static List<SortStep> _generateInsertionSort(List<int> arr) {
    final steps = <SortStep>[];
    final n = arr.length;

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始插入排序，第一个元素已排好序', 1));

    for (int i = 1; i < n; i++) {
      int key = arr[i];
      int j = i - 1;

      steps.addAll(_makeStates(
        arr,
        SortStepType.compare,
        '取出 arr[$i]=$key，插入已排序序列 [0..${i - 1}]',
        2,
        i: i,
      ));

      while (j >= 0 && arr[j] > key) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.compare,
          '比较 arr[$j]=${arr[j]} > key=$key，向右移动',
          3,
          i: j,
          j: j + 1,
        ));

        arr[j + 1] = arr[j];
        steps.addAll(_makeStates(
          arr,
          SortStepType.overwrite,
          '移动 arr[$j] → arr[${j + 1}]',
          4,
          i: j,
          j: j + 1,
        ));
        j--;
      }

      arr[j + 1] = key;
      steps.addAll(_makeStates(
        arr,
        SortStepType.complete,
        '插入 key=$key 到位置 ${j + 1}',
        5,
        i: j + 1,
      ));
    }

    steps.addAll(_makeStates(arr, SortStepType.complete, '插入排序完成！', 6));
    return steps;
  }

  static List<SortStep> _generateQuickSort(List<int> arr) {
    final steps = <SortStep>[];

    void quickSortHelper(int low, int high) {
      if (low >= high) {
        if (low == high) {
          steps.addAll(_makeStates(
            arr,
            SortStepType.complete,
            '单个元素 arr[$low]=${arr[low]} 已排好序',
            1,
            i: low,
          ));
        }
        return;
      }

      int pivot = arr[high];
      steps.addAll(_makeStates(
        arr,
        SortStepType.setPivot,
        '选择 arr[$high]=$pivot 作为基准值',
        2,
        pivot: high,
      ));

      int i = low - 1;

      for (int j = low; j < high; j++) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.compare,
          '比较 arr[$j]=${arr[j]} 和 pivot=$pivot',
          3,
          i: j,
          pivot: high,
        ));

        if (arr[j] <= pivot) {
          i++;
          if (i != j) {
            steps.addAll(_makeStates(
              arr,
              SortStepType.swap,
              '${arr[j]} <= $pivot，交换 arr[$i] 和 arr[$j]',
              4,
              i: i,
              j: j,
            ));
            final tmp = arr[i];
            arr[i] = arr[j];
            arr[j] = tmp;
            steps.addAll(_makeStates(arr, SortStepType.swap, '交换完成', 5, i: i, j: j));
          }
        }
      }

      final pivotPos = i + 1;
      if (pivotPos != high) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.swap,
          '将基准 $pivot 放到正确位置 arr[$pivotPos]',
          6,
          i: pivotPos,
          pivot: high,
        ));
        final tmp = arr[pivotPos];
        arr[pivotPos] = arr[high];
        arr[high] = tmp;
        steps.addAll(_makeStates(arr, SortStepType.swap, '基准放置完成', 7, i: pivotPos, pivot: pivotPos));
      } else {
        steps.addAll(_makeStates(
          arr,
          SortStepType.complete,
          '基准 $pivot 已在正确位置',
          7,
          i: pivotPos,
        ));
      }

      quickSortHelper(low, pivotPos - 1);
      quickSortHelper(pivotPos + 1, high);
    }

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始快速排序', 0));
    quickSortHelper(0, arr.length - 1);
    steps.addAll(_makeStates(arr, SortStepType.complete, '快速排序完成！', 8));

    return steps;
  }

  static List<SortStep> _generateMergeSort(List<int> arr) {
    final steps = <SortStep>[];

    void mergeSortHelper(int left, int right) {
      if (left >= right) return;

      final mid = left + (right - left) ~/ 2;
      steps.addAll(_makeStates(
        arr,
        SortStepType.compare,
        '分割 [${left}..$mid] 和 [${mid + 1}..$right]',
        1,
        i: left,
        j: right,
      ));

      mergeSortHelper(left, mid);
      mergeSortHelper(mid + 1, right);

      // Merge
      final temp = List<int>.from(arr.sublist(left, right + 1));
      int i = 0, j = mid - left + 1, k = left;

      while (i <= mid - left && j <= right - left) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.compare,
          '合并：比较 temp[$i]=${temp[i]} 和 temp[$j]=${temp[j]}',
          2,
          i: k,
        ));

        if (temp[i] <= temp[j]) {
          arr[k] = temp[i++];
        } else {
          arr[k] = temp[j++];
        }
        steps.addAll(_makeStates(
          arr,
          SortStepType.overwrite,
          '写入 arr[$k]=${arr[k]}',
          3,
          i: k,
        ));
        k++;
      }

      while (i <= mid - left) {
        arr[k] = temp[i++];
        steps.addAll(_makeStates(
          arr,
          SortStepType.overwrite,
          '写入剩余 arr[$k]=${arr[k]}',
          3,
          i: k,
        ));
        k++;
      }

      while (j <= right - left) {
        arr[k] = temp[j++];
        steps.addAll(_makeStates(
          arr,
          SortStepType.overwrite,
          '写入剩余 arr[$k]=${arr[k]}',
          3,
          i: k,
        ));
        k++;
      }

      steps.addAll(_makeStates(
        arr,
        SortStepType.complete,
        '合并 [${left}..$right] 完成',
        4,
      ));
    }

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始归并排序', 0));
    mergeSortHelper(0, arr.length - 1);
    steps.addAll(_makeStates(arr, SortStepType.complete, '归并排序完成！', 5));

    return steps;
  }

  static List<SortStep> _generateHeapSort(List<int> arr) {
    final steps = <SortStep>[];
    final n = arr.length;

    // Heapify helper
    void heapify(int size, int i) {
      int largest = i;
      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < size && arr[left] > arr[largest]) {
        largest = left;
      }
      if (right < size && arr[right] > arr[largest]) {
        largest = right;
      }

      if (largest != i) {
        steps.addAll(_makeStates(
          arr,
          SortStepType.swap,
          '交换 arr[$i]=${arr[i]} 和 arr[$largest]=${arr[largest]}',
          1,
          i: i,
          j: largest,
        ));
        final tmp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = tmp;
        steps.addAll(_makeStates(arr, SortStepType.swap, '交换完成', 2, i: i, j: largest));
        heapify(size, largest);
      }
    }

    steps.addAll(_makeStates(arr, SortStepType.compare, '开始堆排序', 0));

    // Build max heap
    steps.addAll(_makeStates(arr, SortStepType.compare, '构建最大堆', 1));
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      heapify(n, i);
    }
    steps.addAll(_makeStates(arr, SortStepType.complete, '最大堆构建完成', 2));

    // Extract elements from heap
    for (int i = n - 1; i > 0; i--) {
      steps.addAll(_makeStates(
        arr,
        SortStepType.swap,
        '交换堆顶 arr[0]=${arr[0]} 和堆尾 arr[$i]=${arr[i]}',
        3,
        i: 0,
        j: i,
      ));
      final tmp = arr[0];
      arr[0] = arr[i];
      arr[i] = tmp;
      steps.addAll(_makeStates(arr, SortStepType.swap, '交换完成', 4, i: 0, j: i));

      // Mark the sorted position
      final sortedStates = List<BarState>.filled(n, BarState.defaultState);
      for (int k = i + 1; k < n; k++) {
        sortedStates[k] = BarState.sorted;
      }
      steps.add(SortStep(
        arrayState: List.from(arr),
        barStates: List.from(sortedStates),
        type: SortStepType.complete,
        description: '对前 $i 个元素重新调整为最大堆',
        codeLine: 5,
      ));

      heapify(i, 0);
    }

    steps.addAll(_makeStates(arr, SortStepType.complete, '堆排序完成！', 6));
    return steps;
  }
}
