// Advanced Sorting Algorithms Course Content
import '../course_data.dart';

/// Advanced Sorting Chapter
const chapterAdvancedSorting = CourseChapter(
  id: 'algorithms_advanced_sorting',
  title: '高级排序算法',
  description: '深入学习堆排序、计数排序、桶排序和基数排序，理解不同排序算法的适用场景。',
  difficulty: DifficultyLevel.advanced,
  category: CourseCategory.algorithms,
  lessons: [
    // Heap Sort
    CourseLesson(
      id: 'advanced_heap_sort',
      title: '堆排序 (Heap Sort)',
      content: '''# 堆排序 (Heap Sort)

堆排序是一种基于"堆"数据结构的排序算法，利用堆的性质进行排序。堆排序的时间复杂度稳定在 O(n log n)，且是原地排序。

## 什么是堆？

**堆（Heap）** 是一种完全二叉树，分为最大堆和最小堆：

**最大堆（Max Heap）**：每个节点的值都大于等于其子节点的值
```
        90
       /  \\
     85    70
    /  \\   / \\
   60  55  65  50
```

**最小堆（Min Heap）**：每个节点的值都小于等于其子节点的值

## 堆的存储

堆可以用数组高效存储（不需要指针）：
- 父节点索引：i
- 左子节点：2i + 1
- 右子节点：2i + 2
- 子节点索引 p，父节点索引：(p - 1) / 2

## 算法原理

1. **构建最大堆**：将数组调整为最大堆结构
2. **堆排序**：将堆顶（最大值）与堆尾交换，然后对剩余 n-1 个元素重新调整为最大堆
3. 重复步骤 2，直到排序完成

## 算法步骤

对于数组 [4, 10, 3, 5, 1]：

**第 1 步：构建最大堆**

初始数组看作完全二叉树：
```
      4(0)
     /
   10(1)
  /
 3(2)
```

构建后：
```
       10
      /  \\
     5    3
    / \\
   4   1
```
数组变为 [10, 5, 3, 4, 1]

**第 2 步：交换堆顶和堆尾，然后调整**

交换 10 和 1：[1, 5, 3, 4, 10]
对 [1, 5, 3, 4] 重新调整：
```
       5
      / \\
     4   3
    /
   1
```
数组：[5, 4, 3, 1, 10]

交换 5 和 1：[1, 4, 3, 5, 10]
调整 [1, 4, 3]：
```
      4
     / \\
    1   3
```
数组：[4, 1, 3, 5, 10]

交换 4 和 3：[3, 1, 4, 5, 10]
调整 [3, 1]：
```
    3
   /
  1
```
数组：[3, 1, 4, 5, 10]

最终：[1, 3, 4, 5, 10]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n log n) |
| 最坏 | O(n log n) |
| 平均 | O(n log n) |

- **空间复杂度**：O(1) — 原地排序
- **稳定性**：不稳定

## 特点

- 时间复杂度稳定 O(n log n)
- 原地排序，空间效率高
- 不稳定排序
- 适合需要稳定最坏情况性能的场景
''',
      codeExamples: [
        CodeExample(
          title: '堆排序实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

class HeapSort {
public:
    static void sort(vector<int>& arr) {
        int n = arr.size();

        // 第 1 步：构建最大堆
        // 从最后一个非叶子节点开始，自底向上调整
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(arr, n, i);
        }

        // 第 2 步：堆排序
        // 依次将堆顶（最大值）与堆尾交换，然后调整
        for (int i = n - 1; i > 0; i--) {
            // 交换堆顶和堆尾
            swap(arr[0], arr[i]);
            // 对剩余 i 个元素重新调整为最大堆
            heapify(arr, i, 0);
        }
    }

private:
    // 将以 i 为根的子树调整为最大堆
    static void heapify(vector<int>& arr, int n, int i) {
        int largest = i;      // 假设根节点最大
        int left = 2 * i + 1;
        int right = 2 * i + 2;

        // 左子节点比根大
        if (left < n && arr[left] > arr[largest]) {
            largest = left;
        }

        // 右子节点比目前最大值大
        if (right < n && arr[right] > arr[largest]) {
            largest = right;
        }

        // 如果最大值不是根节点，需要交换并继续调整
        if (largest != i) {
            swap(arr[i], arr[largest]);
            // 递归调整被影响的子树
            heapify(arr, n, largest);
        }
    }
};

int main() {
    vector<int> arr = {4, 10, 3, 5, 1, 8, 7, 2, 6, 9};

    cout << "排序前: ";
    for (int x : arr) cout << x << " ";
    cout << endl;

    HeapSort::sort(arr);

    cout << "排序后: ";
    for (int x : arr) cout << x << " ";
    cout << endl;

    // 输出: 1 2 3 4 5 6 7 8 9 10
}''',
          description: '堆排序的完整实现，包含 heapify 和主排序逻辑。',
          output: '''排序前: 4 10 3 5 1 8 7 2 6 9
排序后: 1 2 3 4 5 6 7 8 9 10''',
        ),
        CodeExample(
          title: '堆排序可视化分解步骤',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 打印当前堆状态
void printHeap(const vector<int>& arr, int n, int i, const string& action) {
    cout << action << ": ";
    for (int k = 0; k < n; k++) {
        if (k == i) cout << "[" << arr[k] << "] ";
        else cout << arr[k] << " ";
    }
    cout << endl;
}

void heapify(vector<int>& arr, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest])
        largest = left;
    if (right < n && arr[right] > arr[largest])
        largest = right;

    if (largest != i) {
        cout << "  交换 " << arr[i] << " 和 " << arr[largest] << endl;
        swap(arr[i], arr[largest]);
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr) {
    int n = arr.size();

    // 构建最大堆
    cout << "=== 步骤 1: 构建最大堆 ===" << endl;
    for (int i = n / 2 - 1; i >= 0; i--) {
        cout << "调整节点 " << i << " (" << arr[i] << "):" << endl;
        heapify(arr, n, i);
    }
    printHeap(arr, n, -1, "初始最大堆");

    // 堆排序
    cout << "\\n=== 步骤 2: 堆排序 ===" << endl;
    for (int i = n - 1; i > 0; i--) {
        cout << "交换堆顶 " << arr[0] << " 和堆尾 " << arr[i] << endl;
        swap(arr[0], arr[i]);
        printHeap(arr, i, -1, "交换后");

        cout << "对前 " << i << " 个元素重新调整:" << endl;
        heapify(arr, i, 0);
    }
}

int main() {
    vector<int> arr = {4, 10, 3, 5, 1};
    heapSort(arr);
    cout << "\\n最终结果: ";
    for (int x : arr) cout << x << " ";
    // 输出: 1 3 4 5 10
}''',
          description: '展示堆排序每一步的状态变化。',
          output: '''=== 步骤 1: 构建最大堆 ===
调整节点 1 (10):
  交换 10 和 5
调整节点 0 (5):
  交换 10 和 4
初始最大堆: 10 5 3 4 1

=== 步骤 2: 堆排序 ===
交换堆顶 10 和堆尾 1
交换后: 1 5 3 4 [10]
对前 4 个元素重新调整:
  交换 5 和 4
交换堆顶 5 和堆尾 4
交换后: 1 4 3 [5] [10]
对前 3 个元素重新调整:
  交换 4 和 3
交换堆顶 4 和堆尾 3
交换后: 1 3 [4] [5] [10]
对前 2 个元素重新调整:
交换堆顶 3 和堆尾 1
交换后: 1 [3] [4] [5] [10]

最终结果: 1 3 4 5 10''',
        ),
      ],
      exercises: [
        CodeExample(
          title: '练习：实现最小堆',
          code: '''// 实现一个最小堆，支持插入和弹出最小值
#include <iostream>
#include <vector>
using namespace std;

class MinHeap {
private:
    vector<int> heap;
    
    void heapifyUp(int idx) {
        // 补充代码：从 idx 向上调整
    }
    
    void heapifyDown(int idx) {
        // 补充代码：从 idx 向下调整
    }
    
public:
    void insert(int val) {
        heap.push_back(val);
        heapifyUp(heap.size() - 1);
    }
    
    int extractMin() {
        int minVal = heap[0];
        heap[0] = heap.back();
        heap.pop_back();
        heapifyDown(0);
        return minVal;
    }
    
    bool isEmpty() { return heap.empty(); }
    int size() { return heap.size(); }
};

int main() {
    MinHeap h;
    h.insert(5);
    h.insert(3);
    h.insert(8);
    h.insert(1);
    h.insert(9);
    
    while (!h.isEmpty()) {
        cout << h.extractMin() << " ";
    }
    // 期望输出: 1 3 5 8 9
}''',
          description: '实现最小堆的插入和弹出操作。',
          output: '1 3 5 8 9',
        ),
        CodeExample(
          title: '思考：堆排序为什么不稳定？',
          code: '''// 考虑相同值的情况，堆排序如何破坏稳定性？
//
// 示例数组: [5a, 5b, 4]  （5a 在 5b 前面）
//
// 构建最大堆后可能变成: [5b, 5a, 4]
// （取决于堆的具体结构）
//
// 尝试用这个数组测试：
vector<pair<char, int>> arr = {
    {'A', 5}, {'B', 5}, {'C', 4},
    {'D', 3}, {'E', 5}, {'F', 2}
};
//
// 思考：在 heapify 过程中，什么操作会导致相等元素的相对位置改变？''',
          description: '分析堆排序不稳定性的原因。',
        ),
      ],
      keyPoints: [
        '堆排序基于二叉堆数据结构',
        '时间复杂度稳定 O(n log n)，空间复杂度 O(1)',
        '不稳定排序',
        '适合需要稳定最坏情况性能的场景',
      ],
    ),

    // Counting Sort
    CourseLesson(
      id: 'advanced_counting_sort',
      title: '计数排序 (Counting Sort)',
      content: '''# 计数排序 (Counting Sort)

计数排序是一种**非比较排序**，通过统计每个元素出现的次数来排序。它不是基于元素比较，而是基于元素的值进行排序。

## 算法原理

1. 找到待排序数组中的最大值 k
2. 创建一个大小为 k+1 的计数数组，统计每个值出现的次数
3. 根据计数数组，将元素放到正确位置

## 算法步骤

对于数组 [2, 5, 3, 0, 2, 3, 0, 3]：

**第 1 步：统计计数**
最大值 = 5，创建计数数组 [0, 0, 0, 0, 0, 0]
- 2 出现 2 次 → [0, 0, 2, 0, 0, 0]
- 5 出现 1 次 → [0, 0, 2, 0, 0, 1]
- 3 出现 3 次 → [0, 0, 2, 3, 0, 1]
- 0 出现 2 次 → [2, 0, 2, 3, 0, 1]

**第 2 步：累加计数**
- [2, 0, 2, 3, 0, 1] → [2, 2, 4, 7, 7, 8]
含义：值为 i 的元素应该放在输出数组的 [计数[i-1], 计数[i]) 位置

**第 3 步：放置元素（稳定排序）**
逆序遍历原数组：
- 3 → 放到位置 7-1=6 → result[6] = 3，计数[3]-- → 6
- 0 → 放到位置 2-1=1 → result[1] = 0，计数[0]-- → 1
- 3 → 放到位置 6-1=5 → result[5] = 3，计数[3]-- → 5
- 2 → 放到位置 4-1=3 → result[3] = 2，计数[2]-- → 3
- 5 → 放到位置 8-1=7 → result[7] = 5，计数[5]-- → 7
- 2 → 放到位置 3-1=2 → result[2] = 2，计数[2]-- → 2
- 0 → 放到位置 1-1=0 → result[0] = 0，计数[0]-- → 0
- 3 → 放到位置 5-1=4 → result[4] = 3，计数[3]-- → 4

**最终结果**：[0, 0, 2, 2, 3, 3, 3, 5]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n + k) |
| 最坏 | O(n + k) |
| 平均 | O(n + k) |

其中 k 是数据范围（最大值）

- **空间复杂度**：O(k)
- **稳定性**：稳定

## 特点

- 非比较排序，时间复杂度可以低于 O(n log n)
- 数据范围 k 不能太大，否则空间消耗大
- 适合数据范围较小的整数排序
- 稳定排序（保持相同元素的相对顺序）
''',
      codeExamples: [
        CodeExample(
          title: '计数排序实现（稳定版）',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void countingSort(const vector<int>& input, vector<int>& output) {
    if (input.empty()) return;

    // 第 1 步：找到最大值，确定计数数组大小
    int maxVal = input[0];
    for (int x : input) {
        if (x > maxVal) maxVal = x;
    }

    // 第 2 步：创建计数数组并统计每个值出现的次数
    vector<int> count(maxVal + 1, 0);
    for (int x : input) {
        count[x]++;
    }

    // 第 3 步：累加计数（确定每个元素的最终位置）
    for (int i = 1; i <= maxVal; i++) {
        count[i] += count[i - 1];
    }

    // 第 4 步：从后向前遍历，稳定地将元素放到正确位置
    output.resize(input.size());
    for (int i = input.size() - 1; i >= 0; i--) {
        int val = input[i];
        output[count[val] - 1] = val;
        count[val]--;
    }
}

int main() {
    vector<int> input = {2, 5, 3, 0, 2, 3, 0, 3};
    vector<int> output;

    countingSort(input, output);

    cout << "输入: ";
    for (int x : input) cout << x << " ";
    cout << endl;

    cout << "输出: ";
    for (int x : output) cout << x << " ";
    cout << endl;

    // 输出: 0 0 2 2 3 3 3 5
}''',
          description: '稳定版计数排序，支持重复元素的正确排序。',
          output: '''输入: 2 5 3 0 2 3 0 3
输出: 0 0 2 2 3 3 3 5''',
        ),
      ],
      exercises: [
        CodeExample(
          title: '练习：实现不稳定版计数排序',
          code: '''// 实现一个不稳定版本的计数排序
#include <iostream>
#include <vector>
using namespace std;

void unstableCountingSort(const vector<int>& input, vector<int>& output) {
    if (input.empty()) return;
    int maxVal = input[0];
    for (int x : input) if (x > maxVal) maxVal = x;
    vector<int> count(maxVal + 1, 0);
    for (int x : input) count[x]++;
    for (int i = 1; i <= maxVal; i++) count[i] += count[i - 1];
    // 思考：不稳定版本如何修改？提示：不需要从后向前遍历
}

int main() {
    vector<int> input = {2, 5, 3, 0, 2, 3, 0, 3};
    vector<int> output;
    unstableCountingSort(input, output);
    for (int x : output) cout << x << ' ';
    // 期望输出: 0 0 2 2 3 3 3 5
}''',
          description: '将稳定版改为不稳定版本。',
          output: '0 0 2 2 3 3 3 5',
        ),
        CodeExample(
          title: '思考：计数排序的空间优化',
          code: '''// 数据最大值很大但数据量小的情况如何优化？
// 提示：使用 min 值作为偏移基准''',
          description: '思考大数据范围场景下的空间优化策略。',
        ),
      ],
      keyPoints: [
        '计数排序是非比较排序，时间复杂度 O(n + k)',
        '适合数据范围较小的整数排序',
        '稳定排序',
        '空间复杂度取决于数据范围 k',
      ],
    ),

    // Bucket Sort
    CourseLesson(
      id: 'advanced_bucket_sort',
      title: '桶排序 (Bucket Sort)',
      content: '''# 桶排序 (Bucket Sort)

桶排序是计数排序的扩展，将数据分配到多个"桶"中，每个桶内部使用其他排序算法（如插入排序），然后按顺序合并所有桶。

## 算法原理

1. 根据数据范围创建 n 个桶
2. 遍历数据，将元素放入对应的桶
3. 对每个非空桶内部进行排序
4. 按顺序合并所有桶，得到排序结果

## 算法步骤

对数组 [0.78, 0.17, 0.39, 0.26, 0.72, 0.94, 0.21, 0.12, 0.23, 0.68]，使用 10 个桶：

**数据分布**：
- 桶 0：[0.12, 0.17, 0.21, 0.23]（0.0-0.3）
- 桶 1：[0.26]（0.3-0.4）
- 桶 2：[]（0.4-0.5）
- 桶 3：[]（0.5-0.6）
- 桶 4：[0.39, 0.41?]（0.3-0.4）
- 桶 5：[0.5?]（0.5-0.6）
- 桶 6：[0.68, 0.62?]（0.6-0.7）
- 桶 7：[0.72, 0.78]（0.7-0.8）
- 桶 8：[0.83?]（0.8-0.9）
- 桶 9：[0.94]（0.9-1.0）

**对每个桶排序后合并**：[0.12, 0.17, 0.21, 0.23, 0.26, 0.39, 0.68, 0.72, 0.78, 0.94]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(n + k) |
| 最坏 | O(n²)（所有元素都在一个桶）|
| 平均 | O(n + k) |

k 是桶的数量

- **空间复杂度**：O(n + k)
- **稳定性**：取决于桶内排序算法
- **稳定性**：取决于桶内使用的排序算法

## 特点

- 适合均匀分布的数据
- 对输入数据有一定假设
- 可以配合任何桶内排序算法
- 常用于浮点数排序
''',
      codeExamples: [
        CodeExample(
          title: '桶排序实现',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

void bucketSort(vector<double>& arr) {
    if (arr.empty()) return;

    // 第 1 步：创建桶
    int n = arr.size();
    vector<vector<double>> buckets(n);

    // 第 2 步：将元素分配到对应的桶
    for (double val : arr) {
        int bucketIdx = int(val * n);  // 假设元素在 [0, 1) 范围
        buckets[bucketIdx].push_back(val);
    }

    // 第 3 步：对每个桶内部排序（使用插入排序）
    for (int i = 0; i < n; i++) {
        if (!buckets[i].empty()) {
            sort(buckets[i].begin(), buckets[i].end());
        }
    }

    // 第 4 步：合并所有桶
    int idx = 0;
    for (int i = 0; i < n; i++) {
        for (double val : buckets[i]) {
            arr[idx++] = val;
        }
    }
}

int main() {
    vector<double> arr = {0.78, 0.17, 0.39, 0.26, 0.72,
                          0.94, 0.21, 0.12, 0.23, 0.68};

    cout << "排序前: ";
    for (double x : arr) cout << x << " ";
    cout << endl;

    bucketSort(arr);

    cout << "排序后: ";
    for (double x : arr) cout << x << " ";
    cout << endl;

    // 输出: 0.12 0.17 0.21 0.23 0.26 0.39 0.68 0.72 0.78 0.94
}''',
          description: '桶排序的完整实现，使用插入排序处理桶内元素。',
          output: '''排序前: 0.78 0.17 0.39 0.26 0.72 0.94 0.21 0.12 0.23 0.68
排序后: 0.12 0.17 0.21 0.23 0.26 0.39 0.68 0.72 0.78 0.94''',
        ),
      ],
      exercises: [
        CodeExample(
          title: '练习：实现支持任意范围的桶排序',
          code: '''// 桶排序默认假设数据在 [0, 1) 范围内
// 实现支持任意 [min, max] 范围的版本
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int getBucketIndex(double val, double minVal, double maxVal, int bucketCount) {
    if (maxVal == minVal) return 0;
    // 补充代码：计算 val 应该放入哪个桶
}

void bucketSortGeneral(vector<double>& arr) {
    if (arr.empty()) return;
    int n = arr.size();
    double minVal = *min_element(arr.begin(), arr.end());
    double maxVal = *max_element(arr.begin(), arr.end());
    vector<vector<double>> buckets(n);
    
    for (double val : arr) {
        int idx = getBucketIndex(val, minVal, maxVal, n);
        buckets[idx].push_back(val);
    }
    
    for (int i = 0; i < n; i++) {
        if (!buckets[i].empty()) sort(buckets[i].begin(), buckets[i].end());
    }
    
    int idx = 0;
    for (int i = 0; i < n; i++) {
        for (double val : buckets[i]) arr[idx++] = val;
    }
}

int main() {
    vector<double> arr = {-2.5, -1.0, 0.5, 2.0, 5.5, 8.0};
    bucketSortGeneral(arr);
    for (double x : arr) cout << x << ' ';
    // 期望输出: -2.5 -1 0.5 2 5.5 8
}''',
          description: '扩展桶排序以支持任意范围的数据。',
          output: '-2.5 -1 0.5 2 5.5 8',
        ),
      ],
      keyPoints: [
        '桶排序将数据分散到多个桶中',
        '适合均匀分布的数据',
        '平均时间复杂度 O(n + k)',
        '桶内排序算法决定整体稳定性',
      ],
    ),

    // Radix Sort
    CourseLesson(
      id: 'advanced_radix_sort',
      title: '基数排序 (Radix Sort)',
      content: '''# 基数排序 (Radix Sort)

基数排序是一种**非比较排序**，按照数字的每一位进行排序，从低位到高位（或从高位到低位），逐轮处理所有位数。

## 算法原理

基数排序有两种方式：
- **LSD（Least Significant Digit）**：从最低位开始，逐位排序
- **MSD（Most Significant Digit）**：从最高位开始，逐位排序

**LSD 基数排序步骤**：
1. 按个位数字分组并排序
2. 按十位数字分组并排序
3. 按百位数字分组并排序
4. ...直到最高位

## 算法步骤

对数组 [170, 45, 75, 90, 802, 24, 2, 66]：

**第 1 轮（按个位）**：
- 桶分配：0:[170,90], 1:[], 2:[802,2], 3:[], 4:[24], 5:[45,75], 6:[66], 7:[], 8:[], 9:[]
- 收集：[170, 90, 802, 2, 24, 45, 75, 66]

**第 2 轮（按十位）**：
- 桶分配：0:[802], 1:[], 2:[24,2], 3:[], 4:[45], 5:[66,75], 6:[170], 7:[], 8:[90], 9:[]
- 收集：[802, 24, 2, 45, 66, 75, 170, 90]

**第 3 轮（按百位）**：
- 桶分配：0:[2,24,45,66,75,90], 1:[170], 2:[802], others:[]
- 收集：[2, 24, 45, 66, 75, 90, 170, 802]

**最终结果**：[2, 24, 45, 66, 75, 90, 170, 802]

## 复杂度分析

| 情况 | 时间复杂度 |
|------|-----------|
| 最好 | O(d × (n + k)) |
| 最坏 | O(d × (n + k)) |
| 平均 | O(d × (n + k)) |

其中 d 是数字位数，k 是进制（本例中 k = 10）

- **空间复杂度**：O(n + k)
- **稳定性**：稳定

## 特点

- 非比较排序
- 适合整数或字符串排序
- 时间复杂度与数据位数线性相关
- 稳定排序
''',
      codeExamples: [
        CodeExample(
          title: '基数排序（LSD）实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 获取数字的第 d 位（从右往左，d 从 1 开始）
int getDigit(int num, int d) {
    int div = 1;
    for (int i = 1; i < d; i++) div *= 10;
    return (num / div) % 10;
}

// 找到数字的最大位数
int maxDigits(const vector<int>& arr) {
    int maxVal = arr[0];
    for (int x : arr) {
        if (x > maxVal) maxVal = x;
    }
    int digits = 0;
    while (maxVal > 0) {
        digits++;
        maxVal /= 10;
    }
    return digits;
}

void countingSortByDigit(vector<int>& arr, int digit) {
    int n = arr.size();
    vector<int> output(n);
    vector<int> count(10, 0);  // 0-9 十个桶

    // 统计每个桶的元素个数
    for (int x : arr) {
        int d = getDigit(x, digit);
        count[d]++;
    }

    // 累加计数
    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }

    // 从后向前遍历，保持稳定
    for (int i = n - 1; i >= 0; i--) {
        int d = getDigit(arr[i], digit);
        output[count[d] - 1] = arr[i];
        count[d]--;
    }

    arr = output;
}

void radixSort(vector<int>& arr) {
    if (arr.empty()) return;

    int digits = maxDigits(arr);
    cout << "最大位数: " << digits << endl;

    for (int d = 1; d <= digits; d++) {
        cout << "第 " << d << " 轮排序（按第 " << d << " 位）: ";
        countingSortByDigit(arr, d);
        for (int x : arr) cout << x << " ";
        cout << endl;
    }
}

int main() {
    vector<int> arr = {170, 45, 75, 90, 802, 24, 2, 66};

    cout << "排序前: ";
    for (int x : arr) cout << x << " ";
    cout << endl << endl;

    radixSort(arr);

    cout << endl << "最终结果: ";
    for (int x : arr) cout << x << " ";
    cout << endl;

    // 输出: 2 24 45 66 75 90 170 802
}''',
          description: 'LSD 基数排序，使用计数排序作为按位排序的核心。',
          output: '''排序前: 170 45 75 90 802 24 2 66

最大位数: 3
第 1 轮排序（按第 1 位）: 170 90 802 2 24 45 75 66
第 2 轮排序（按第 2 位）: 802 2 24 45 66 170 75 90
第 3 轮排序（按第 3 位）: 2 24 45 66 75 90 170 802

最终结果: 2 24 45 66 75 90 170 802''',
        ),
      ],
      exercises: [
        CodeExample(
          title: '练习：实现 MSD 基数排序',
          code: '''// 实现 MSD（最高位优先）基数排序
// MSD 更适合字符串排序
#include <iostream>
#include <vector>
#include <string>
using namespace std;

int getCharAt(const string& s, int d) {
    if (d >= (int)s.length()) return -1;
    return s[d];
}

void msdRadixSort(vector<string>& arr, int high) {
    // 补充代码：实现 MSD 基数排序
    // 如果 high - low <= 1，递归终止
}

int main() {
    vector<string> arr = {"apple", "apricot", "banana", "blueberry"};
    msdRadixSort(arr, arr.size());
    for (const string& s : arr) cout << s << ' ';
    // 期望输出: apple apricot banana blueberry
}''',
          description: '实现最高位优先的基数排序。',
          output: 'apple apricot banana blueberry',
        ),
        CodeExample(
          title: '思考：基数排序 vs 比较排序',
          code: '''// 基数排序时间复杂度 O(d × (n + k))
// 比较排序最快 O(n log n)
//
// 思考题：
// 1. 当 n=1000000, d=5, k=10 时谁更快？
// 2. 位数 d 很大时（如身份证18位）还合适吗？
// 3. 什么情况下比较排序反而更快？
// 4. 基数排序和桶排序的关系是什么？''',
          description: '比较基数排序和比较排序的适用场景。',
        ),
      ],
      keyPoints: [
        '基数排序按数字的每一位进行排序',
        'LSD 从低位到高位，MSD 从高位到低位',
        '时间复杂度 O(d × (n + k))',
        '稳定排序，适合整数排序',
      ],
    ),
  ],
);
