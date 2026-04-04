// Sorting Algorithms Course Content
import '../course_data.dart';

/// Sorting Algorithms Chapter
const chapterSortAlgorithms = CourseChapter(
  id: 'algorithms_sorting',
  title: '排序算法',
  description: '学习各种排序算法，从基础的冒泡排序到高效的快速排序和归并排序。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    // Bubble Sort
    CourseLesson(
      id: 'sorting_bubble',
      title: '冒泡排序 (Bubble Sort)',
      content: '''# 冒泡排序 (Bubble Sort)

冒泡排序是最简单直观的排序算法，通过反复比较相邻元素并在必要时交换位置，将最大（或最小）的元素逐步"冒泡"到序列一端。

## 算法原理

从序列开头开始，依次比较相邻的两个元素，如果顺序错误就交换。通过多轮遍历，最终使序列有序。

## 算法步骤

对于数组 [5, 3, 8, 4, 2]：

**第 1 轮冒泡：**
- 比较 (5, 3)：5 > 3，交换 → [3, 5, 8, 4, 2]
- 比较 (5, 8)：5 < 8，不交换 → [3, 5, 8, 4, 2]
- 比较 (8, 4)：8 > 4，交换 → [3, 5, 4, 8, 2]
- 比较 (8, 2)：8 > 2，交换 → [3, 5, 4, 2, 8]

**第 2 轮冒泡：**
- 比较 (3, 5)：不交换
- 比较 (5, 4)：交换 → [3, 4, 5, 2, 8]
- 比较 (5, 2)：交换 → [3, 4, 2, 5, 8]

**第 3 轮冒泡：**
- 比较 (3, 4)：不交换
- 比较 (4, 2)：交换 → [3, 2, 4, 5, 8]

**第 4 轮冒泡：**
- 比较 (3, 2)：交换 → [2, 3, 4, 5, 8]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n) — 已排序时，一趟遍历即可发现无交换 |
| 最坏 | O(n²) — 逆序时每次都要交换 |
| 平均 | O(n²) |

- **空间复杂度**：O(1) — 原地排序
- **稳定性**：稳定 — 相等元素不交换

## 特点

- 实现简单，逻辑清晰
- 适合小规模数据或基本有序的数据
- 代码简短，易于理解和调试
''',
      codeExamples: [
        CodeExample(
          title: '冒泡排序基础实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        bool swapped = false;
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
                swapped = true;
            }
        }
        // 如果没有交换，说明已经有序
        if (!swapped) break;
    }
}

int main() {
    vector<int> arr = {64, 34, 25, 12, 22, 11, 90};
    bubbleSort(arr);
    for (int x : arr) cout << x << " ";
    // 输出: 11 12 22 25 34 64 90
}''',
          description: '带优化（提前终止）的冒泡排序。',
          output: '11 12 22 25 34 64 90',
        ),
      ],
      keyPoints: [
        '每轮冒泡将当前最大元素移到序列末端',
        '可以通过 swapped 标志提前终止优化',
        '时间复杂度 O(n²)，适合小规模数据',
        '稳定排序，相等元素保持原有顺序',
      ],
    ),

    // Selection Sort
    CourseLesson(
      id: 'sorting_selection',
      title: '选择排序 (Selection Sort)',
      content: '''# 选择排序 (Selection Sort)

选择排序的工作原理：首先在未排序序列中找到最小（或最大）元素，存放到排序序列的起始位置，然后继续从剩余未排序元素中寻找最小（或最大）元素，放到已排序序列的末尾。

## 算法原理

每轮遍历未排序部分，选择最小元素，与未排序部分的第一个元素交换。重复直到所有元素排序完成。

## 算法步骤

对于数组 [64, 25, 12, 22, 11]：

**第 1 轮：** 在 [64, 25, 12, 22, 11] 中找最小值 11，与 arr[0] 交换
→ [11, 25, 12, 22, 64]

**第 2 轮：** 在 [25, 12, 22, 64] 中找最小值 12，与 arr[1] 交换
→ [11, 12, 25, 22, 64]

**第 3 轮：** 在 [25, 22, 64] 中找最小值 22，与 arr[2] 交换
→ [11, 12, 22, 25, 64]

**第 4 轮：** 在 [25, 64] 中找最小值 25，与 arr[3] 交换
→ [11, 12, 22, 25, 64]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n²) |
| 最坏 | O(n²) |
| 平均 | O(n²) |

- **空间复杂度**：O(1)
- **稳定性**：不稳定 — 相等元素可能改变相对位置

## 特点

- 交换次数最少（最多 n-1 次）
- 时间复杂度始终为 O(n²)
- 不适合大规模数据
''',
      codeExamples: [
        CodeExample(
          title: '选择排序实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void selectionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        if (minIdx != i) {
            swap(arr[i], arr[minIdx]);
        }
    }
}

int main() {
    vector<int> arr = {64, 25, 12, 22, 11};
    selectionSort(arr);
    for (int x : arr) cout << x << " ";
    // 输出: 11 12 22 25 64
}''',
          description: '标准选择排序，找出最小元素进行交换。',
          output: '11 12 22 25 64',
        ),
      ],
      keyPoints: [
        '每轮选择未排序部分的最小元素',
        '最多进行 n-1 次交换',
        '不稳定排序',
        '时间复杂度恒为 O(n²)',
      ],
    ),

    // Insertion Sort
    CourseLesson(
      id: 'sorting_insertion',
      title: '插入排序 (Insertion Sort)',
      content: '''# 插入排序 (Insertion Sort)

插入排序类似于整理扑克牌：将每张牌插入到手中已排序部分的正确位置。对于数组，从第二个元素开始，将它插入到前面已排序子数组的正确位置。

## 算法原理

将数组分为已排序部分和未排序部分。初始时，已排序部分只有第一个元素。然后逐个将未排序部分的元素插入到已排序部分的正确位置。

## 算法步骤

对于数组 [12, 11, 13, 5, 6]：

**初始：** [12 | 11, 13, 5, 6] — 已排序 | 未排序

**处理 11：** 将 11 插入已排序 [12]
→ [11, 12 | 13, 5, 6]

**处理 13：** 将 13 插入已排序 [11, 12]
→ [11, 12, 13 | 5, 6]

**处理 5：** 将 5 插入已排序 [11, 12, 13]
→ [5, 11, 12, 13 | 6]

**处理 6：** 将 6 插入已排序 [5, 11, 12, 13]
→ [5, 6, 11, 12, 13]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n) — 已排序时，只需比较一次 |
| 最坏 | O(n²) — 逆序时 |
| 平均 | O(n²) |

- **空间复杂度**：O(1)
- **稳定性**：稳定

## 特点

- 对基本有序的数据效率很高
- 适合在线排序（实时数据）
- 简单高效，小规模数据首选
''',
      codeExamples: [
        CodeExample(
          title: '插入排序实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void insertionSort(vector<int>& arr) {
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
}

int main() {
    vector<int> arr = {12, 11, 13, 5, 6};
    insertionSort(arr);
    for (int x : arr) cout << x << " ";
    // 输出: 5 6 11 12 13
}''',
          description: '标准插入排序，像整理扑克牌一样。',
          output: '5 6 11 12 13',
        ),
      ],
      keyPoints: [
        '像整理扑克牌一样将元素插入已排序序列',
        '对基本有序数据接近 O(n)',
        '稳定排序',
        '适合小规模或基本有序的数据',
      ],
    ),

    // Quick Sort
    CourseLesson(
      id: 'sorting_quick',
      title: '快速排序 (Quick Sort)',
      content: '''# 快速排序 (Quick Sort)

快速排序是最高效的排序算法之一，采用分治策略：通过选择一个"基准"（pivot）元素，将数组分为两部分，小于基准的在左边，大于基准的在右边，然后递归排序两部分。

## 算法原理

1. 选择一个基准元素（通常选择第一个、最后一个或中间元素）
2. 分区（partition）：将数组重新排列，使得左侧元素都 ≤ 基准，右侧元素都 ≥ 基准
3. 递归对左右两部分进行快速排序

## 算法步骤

对于数组 [10, 7, 8, 9, 1, 5]，选择 pivot = 10（最后一个元素）：

**分区过程：**
- i = -1，遍历 j = 0 到 4
- j=0: 7 < 10 → i=0，交换 arr[0]↔arr[0] → [10, 7, 8, 9, 1, 5]
- j=1: 8 < 10 → i=1，交换 arr[1]↔arr[1] → [10, 7, 8, 9, 1, 5]
- j=2: 9 < 10 → i=2，交换 arr[2]↔arr[2] → [10, 7, 8, 9, 1, 5]
- j=3: 1 < 10 → i=3，交换 arr[3]↔arr[3] → [10, 7, 8, 9, 1, 5]
- j=4: 1 < 10 → i=4，交换 arr[4]↔arr[4] → [10, 7, 8, 9, 1, 5]
- 最后将 pivot 放到位置 i+1=5 → [1, 7, 8, 9, 10, 5]

**递归排序 [1, 7, 8, 9] 和 [5]**
→ [1, 7, 8, 9] → pivot=9 → [1, 7, 8]
→ [1] 递归基，[7, 8] → pivot=8 → [7]
→ 最终合并：[1, 5, 7, 8, 9, 10]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n log n) — 每次 pivot 正好在中间 |
| 最坏 | O(n²) — pivot 始终在最左或最右 |
| 平均 | O(n log n) |

- **空间复杂度**：O(log n) — 递归栈深度
- **稳定性**：不稳定

## 特点

- 平均性能最优，实际应用中速度最快
- 不稳定排序
- 递归深度最坏情况可能达到 O(n)
''',
      codeExamples: [
        CodeExample(
          title: '快速排序实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

int main() {
    vector<int> arr = {10, 7, 8, 9, 1, 5};
    quickSort(arr, 0, arr.size() - 1);
    for (int x : arr) cout << x << " ";
    // 输出: 1 5 7 8 9 10
}''',
          description: '标准快速排序，以最后一个元素为基准。',
          output: '1 5 7 8 9 10',
        ),
      ],
      keyPoints: [
        '分治策略，选择基准元素分区',
        '平均时间复杂度 O(n log n)',
        '不稳定排序',
        '不适合已逆向排序的数据（可随机化基准优化）',
      ],
    ),

    // Merge Sort
    CourseLesson(
      id: 'sorting_merge',
      title: '归并排序 (Merge Sort)',
      content: '''# 归并排序 (Merge Sort)

归并排序是典型的分治算法，将数组递归地分成两半，分别排序后再合并成一个完整的有序数组。

## 算法原理

1. **分解**：将数组递归地分成两半，直到每个子数组只有一个元素
2. **合并**：将两个已排序的子数组合并成一个有序数组

## 算法步骤

对于数组 [38, 27, 43, 3, 9, 82, 10]：

**分解过程：**
[38, 27, 43, 3, 9, 82, 10]
→ [38, 27, 43, 3] 和 [9, 82, 10]
→ [38, 27] 和 [43, 3] 和 [9, 82] 和 [10]
→ [38] [27] [43] [3] [9] [82] [10]

**合并过程：**
[27, 38] ← 合并 | [3, 43] ← 合并 | [9, 82] ← 合并 | [10]
[3, 27, 38, 43] ← 合并 | [9, 10, 82] ← 合并
[3, 9, 10, 27, 38, 43, 82] ← 合并

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n log n) |
| 最坏 | O(n log n) |
| 平均 | O(n log n) |

- **空间复杂度**：O(n) — 需要额外存储空间
- **稳定性**：稳定

## 特点

- 时间复杂度稳定 O(n log n)
- 需要额外 O(n) 空间
- 稳定排序
- 适合链表排序（不需要随机访问）
''',
      codeExamples: [
        CodeExample(
          title: '归并排序实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void merge(vector<int>& arr, int left, int mid, int right) {
    vector<int> L(arr.begin() + left, arr.begin() + mid + 1);
    vector<int> R(arr.begin() + mid + 1, arr.begin() + right + 1);

    int i = 0, j = 0, k = left;
    while (i < L.size() && j < R.size()) {
        if (L[i] <= R[j]) arr[k++] = L[i++];
        else arr[k++] = R[j++];
    }
    while (i < L.size()) arr[k++] = L[i++];
    while (j < R.size()) arr[k++] = R[j++];
}

void mergeSort(vector<int>& arr, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

int main() {
    vector<int> arr = {38, 27, 43, 3, 9, 82, 10};
    mergeSort(arr, 0, arr.size() - 1);
    for (int x : arr) cout << x << " ";
    // 输出: 3 9 10 27 38 43 82
}''',
          description: '归并排序的递归实现。',
          output: '3 9 10 27 38 43 82',
        ),
      ],
      keyPoints: [
        '分治策略，先分解后合并',
        '时间复杂度稳定 O(n log n)',
        '稳定排序',
        '需要额外 O(n) 空间，不是原地排序',
      ],
    ),
  ],
);
