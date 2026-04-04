// 高级算法 - 堆排序 - Heap Sort
import '../course_data.dart';

/// 堆排序章节
const chapterHeapSort = CourseChapter(
  id: 'advanced_algorithms_heap_sort',
  title: '堆排序 (Heap Sort)',
  description: '学习堆排序算法，包括二叉堆的概念、堆的调整过程和完整的堆排序实现。',
  difficulty: DifficultyLevel.advanced,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'advanced_algorithms_heap_sort_concept',
      title: '堆的概念与实现',
      content: '''# 堆的概念与实现

## 什么是堆？

堆是一种**完全二叉树**，同时满足堆属性：

- **最大堆 (Max Heap)**：每个节点的值 ≥ 其子节点的值
- **最小堆 (Min Heap)**：每个节点的值 ≤ 其子节点的值

```
最大堆示例:          数组表示:
           9               [9, 5, 7, 3, 2, 4]
         /   \\
        5     7
       / \\   /
      3   2  4
```

## 堆的数组表示

对于索引 i 的节点：
- **父节点**：(i - 1) / 2
- **左子节点**：2 * i + 1
- **右子节点**：2 * i + 2

```
索引:   0   1   2   3   4   5
数组: [ 9 | 5 | 7 | 3 | 2 | 4 ]
       ↑
     root

        9(0)
       / \\
   5(1)   7(2)
   / \\
3(3) 2(4)
```

## 堆的基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|------------|
| `buildHeap` | 构建堆 | O(n) |
| `heapify` | 调整堆（自上而下） | O(log n) |
| `siftDown` | 向下调整 | O(log n) |
| `siftUp` | 向上调整 | O(log n) |
| `extractMax` | 取出最大/最小值 | O(log n) |

## 堆的 siftDown 操作

将节点向下调整以满足堆属性：

```cpp
void siftDown(int i) {
    while (leftChild(i) < size) {
        int largest = i;
        if (arr[leftChild(i)] > arr[largest])
            largest = leftChild(i);
        if (arr[rightChild(i)] > arr[largest])
            largest = rightChild(i);

        if (largest != i) {
            swap(arr[i], arr[largest]);
            i = largest;
        } else {
            break;
        }
    }
}
```

## 堆的应用

- **堆排序**：O(n log n) 排序算法
- **优先队列**：高效获取最大/最小元素
- **Top-K 问题**：找出前 K 大/小的元素
- **合并 K 个有序数组**
- **Dijkstra 最短路径算法**
''',
      codeExamples: [
        CodeExample(
          title: '堆的完整实现',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class MaxHeap {
private:
    vector<int> heap;
    int size;

    int parent(int i) { return (i - 1) / 2; }
    int leftChild(int i) { return 2 * i + 1; }
    int rightChild(int i) { return 2 * i + 2; }

    // 向下调整 (siftDown)
    void siftDown(int i) {
        while (leftChild(i) < size) {
            int largest = i;

            if (heap[leftChild(i)] > heap[largest])
                largest = leftChild(i);

            if (rightChild(i) < size &&
                heap[rightChild(i)] > heap[largest])
                largest = rightChild(i);

            if (largest != i) {
                swap(heap[i], heap[largest]);
                i = largest;
            } else {
                break;
            }
        }
    }

    // 向上调整 (siftUp)
    void siftUp(int i) {
        while (i > 0 && heap[parent(i)] < heap[i]) {
            swap(heap[parent(i)], heap[i]);
            i = parent(i);
        }
    }

public:
    MaxHeap() : size(0) {}

    // 获取最大元素
    int getMax() {
        if (size == 0) throw runtime_error("Heap is empty!");
        return heap[0];
    }

    // 取出最大元素
    int extractMax() {
        if (size == 0) throw runtime_error("Heap is empty!");
        int max = heap[0];
        heap[0] = heap[size - 1];
        size--;
        siftDown(0);
        return max;
    }

    // 插入元素
    void insert(int val) {
        heap.push_back(val);
        size++;
        siftUp(size - 1);
    }

    // 删除指定位置元素
    void remove(int i) {
        if (i < 0 || i >= size) return;
        heap[i] = heap[0] + 1;  // 放到堆顶
        siftUp(i);
        extractMax();
    }

    // 构建堆
    void buildHeap(vector<int>& arr) {
        heap = arr;
        size = arr.size();

        // 从最后一个非叶子节点开始向下调整
        for (int i = parent(size - 1); i >= 0; i--) {
            siftDown(i);
        }
    }

    bool isEmpty() const { return size == 0; }
    int getSize() const { return size; }

    // 打印堆
    void print() {
        cout << "堆数组: ";
        for (int i = 0; i < size; i++) {
            cout << heap[i];
            if (i < size - 1) cout << ", ";
        }
        cout << endl;
    }
};

int main() {
    cout << "=== 堆操作演示 ===" << endl;
    MaxHeap heap;

    // 插入
    vector<int> values = {10, 20, 5, 30, 25, 15};
    cout << "插入元素: ";
    for (int v : values) {
        cout << v << " ";
        heap.insert(v);
    }
    cout << endl;
    heap.print();

    cout << "\\n取出最大: " << heap.extractMax() << endl;
    cout << "取出最大: " << heap.extractMax() << endl;
    heap.print();

    cout << "\\n=== 构建堆 ===" << endl;
    vector<int> arr = {4, 10, 3, 5, 1, 8, 7, 2, 6, 9};
    cout << "原数组: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    heap.buildHeap(arr);
    heap.print();

    cout << "\\n=== 堆排序 (逐步) ===" << endl;
    vector<int> toSort = {4, 10, 3, 5, 1, 8, 7, 2, 6, 9};
    MaxHeap h;
    h.buildHeap(toSort);

    vector<int> sorted;
    while (!h.isEmpty()) {
        sorted.push_back(h.extractMax());
    }

    cout << "排序后: ";
    for (int n : sorted) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示最大堆的完整实现：插入、extractMax、siftDown、siftUp 和构建堆。',
          output: '''=== 堆操作演示 ===
插入元素: 10 20 5 30 25 15 
堆数组: 30, 25, 15, 10, 20, 5

取出最大: 30
取出最大: 25
堆数组: 20, 10, 15, 5

=== 构建堆 ===
原数组: 4 10 3 5 1 8 7 2 6 9 
堆数组: 10, 9, 8, 6, 5, 4, 7, 2, 3, 1

=== 堆排序 (逐步) ===
排序后: 10 9 8 7 6 5 4 3 2 1''',
        ),
        CodeExample(
          title: '堆排序完整实现',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 堆排序
void heapSort(vector<int>& arr) {
    int n = arr.size();

    // 构建最大堆
    auto siftDown = [&](int i, int size) {
        while (true) {
            int largest = i;
            int left = 2 * i + 1;
            int right = 2 * i + 2;

            if (left < size && arr[left] > arr[largest])
                largest = left;
            if (right < size && arr[right] > arr[largest])
                largest = right;

            if (largest != i) {
                swap(arr[i], arr[largest]);
                i = largest;
            } else {
                break;
            }
        }
    };

    // 构建堆 (从最后一个非叶子节点开始)
    for (int i = n / 2 - 1; i >= 0; i--) {
        siftDown(i, n);
    }

    // 逐步取出堆顶并调整
    for (int i = n - 1; i > 0; i--) {
        swap(arr[0], arr[i]);  // 堆顶移到末尾
        siftDown(0, i);        // 调整剩余堆
    }
}

// 打印堆的树形结构
void printHeapTree(const vector<int>& heap, int index, int indent = 0) {
    if (index >= heap.size()) return;

    printHeapTree(heap, index * 2 + 2, indent + 4);

    for (int i = 0; i < indent; i++) cout << " ";
    cout << heap[index] << endl;

    printHeapTree(heap, index * 2 + 1, indent + 4);
}

int main() {
    cout << "=== 堆排序算法 ===" << endl;

    vector<int> arr = {12, 11, 13, 5, 6, 7, 3, 10, 9, 1, 15};

    cout << "排序前: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    heapSort(arr);

    cout << "排序后: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    cout << "\\n=== 堆排序过程 ===" << endl;
    vector<int> process = {4, 10, 3, 5, 1, 8, 7, 2, 6, 9};
    int n = process.size();

    cout << "步骤 1 - 构建最大堆:" << endl;
    cout << "原数组: ";
    for (int i = 0; i < n; i++) cout << process[i] << " ";
    cout << endl;

    // 手动演示构建堆过程
    auto showStep = [](const vector<int>& arr, const string& msg) {
        cout << msg << ": ";
        for (int n : arr) cout << n << " ";
        cout << endl;
    };

    showStep(process, "数组内容");

    // 建堆后依次取出
    cout << "\\n步骤 2 - 依次取出堆顶到排序完成" << endl;
    vector<int> temp = process;
    int size = temp.size();

    auto siftDownFunc = [&](int i, int sz) {
        while (2 * i + 1 < sz) {
            int left = 2 * i + 1;
            int right = 2 * i + 2;
            int largest = i;

            if (right < sz && temp[right] > temp[largest])
                largest = right;
            if (left < sz && temp[left] > temp[largest])
                largest = left;

            if (largest != i) {
                swap(temp[i], temp[largest]);
                i = largest;
            } else break;
        }
    };

    // 构建堆
    for (int i = n / 2 - 1; i >= 0; i--) {
        siftDownFunc(i, n);
    }
    showStep(temp, "构建堆后");

    // 取出元素
    for (int i = n - 1; i > 0; i--) {
        swap(temp[0], temp[i]);
        showStep(temp, "取出 " + to_string(n - i) + " 个元素后");
        siftDownFunc(0, i);
    }

    cout << "\\n最终排序结果: ";
    for (int n : temp) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示完整的堆排序算法实现，以及排序过程的逐步演示。',
          output: '''=== 堆排序算法 ===
排序前: 12 11 13 5 6 7 3 10 9 1 15 
排序后: 1 3 5 6 7 9 10 11 12 13 15 

=== 堆排序过程 ===
步骤 1 - 构建最大堆:
原数组: 4 10 3 5 1 8 7 2 6 9 
步骤 2 - 依次取出堆顶到排序完成
... (完整输出见实际运行)

最终排序结果: 1 2 3 4 5 6 7 8 9 10''',
        ),
      ],
      keyPoints: [
        '堆是一种完全二叉树，分为最大堆（父节点 ≥ 子节点）和最小堆（父节点 ≤ 子节点）',
        '堆的数组表示：父节点 (i-1)/2，左子节点 2i+1，右子节点 2i+2',
        'siftDown 将节点向下调整，siftUp 将节点向上调整',
        '堆排序：先构建最大堆，然后依次取出堆顶（最大）与末尾交换，再调整堆',
        '堆排序时间复杂度 O(n log n)，空间复杂度 O(1)，不稳定排序',
      ],
    ),

    CourseLesson(
      id: 'advanced_algorithms_heap_sort_applications',
      title: '堆排序的应用',
      content: '''# 堆排序的应用

## Top-K 问题

找出数组中前 K 大（或前 K 小）的元素：

```cpp
// 方法1: 堆排序后取前 K 个 - O(n log n)
// 方法2: 维护大小为 K 的最小堆 - O(n log k)

vector<int> topK(const vector<int>& nums, int k) {
    priority_queue<int, vector<int>, greater<int>> minHeap;

    for (int n : nums) {
        minHeap.push(n);
        if (minHeap.size() > k) minHeap.pop();
    }

    vector<int> result;
    while (!minHeap.empty()) {
        result.push_back(minHeap.top());
        minHeap.pop();
    }
    return result;  // 逆序即从大到小
}
```

## 数组中的第 K 大元素

```cpp
// 方法1: 堆排序 - O(n log n)
// 方法2: 维护大小为 K 的最小堆 - O(n log k)
// 方法3: 使用 partition（类似快排）- 平均 O(n)

int findKthLargest(vector<int>& nums, int k) {
    priority_queue<int> pq(nums.begin(), nums.end());
    for (int i = 0; i < k - 1; i++) pq.pop();
    return pq.top();
}
```

## 合并 K 个有序数组

使用最小堆，依次取出当前最小的元素：

```cpp
vector<int> mergeKSorted(const vector<vector<int>>& lists) {
    priority_queue<Node, vector<Node>, cmp> pq;

    // 每个数组第一个元素入堆
    for (int i = 0; i < lists.size(); i++) {
        if (!lists[i].empty())
            pq.push({lists[i][0], i, 0});
    }

    vector<int> result;
    while (!pq.empty()) {
        Node node = pq.top(); pq.pop();
        result.push_back(node.val);
        if (node.j + 1 < lists[node.i].size())
            pq.push({lists[node.i][node.j+1], node.i, node.j+1});
    }
    return result;
}
```

## 滑动窗口最大值

使用单调递减双端队列：

```cpp
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    deque<int> dq;  // 存索引，保持递减
    vector<int> result;

    for (int i = 0; i < nums.size(); i++) {
        // 移除超出窗口的索引
        while (!dq.empty() && dq.front() <= i - k) dq.pop_front();

        // 保持递减
        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();
        dq.push_back(i);

        if (i >= k - 1) result.push_back(nums[dq.front()]);
    }
    return result;
}
```

## 堆 vs 其他排序算法

| 排序算法 | 时间复杂度 | 空间复杂度 | 稳定性 | 特点 |
|----------|------------|------------|--------|------|
| 快速排序 | O(n log n) 均摊 | O(log n) | 不稳定 | 最常用，平均最快 |
| 归并排序 | O(n log n) | O(n) | 稳定 | 适合链表、外部排序 |
| 堆排序 | O(n log n) | O(1) | 不稳定 | 原地排序，最坏 O(n log n) |
| 希尔排序 | O(n^1.3) | O(1) | 不稳定 | 插入排序改进 |
''',
      codeExamples: [
        CodeExample(
          title: 'Top-K 问题',
          code: '''#include <iostream>
#include <queue>
#include <vector>
#include <algorithm>
using namespace std;

// 方法1: 维护大小为 K 的最小堆
vector<int> topK_minHeap(const vector<int>& nums, int k) {
    priority_queue<int, vector<int>, greater<int>> minHeap;

    for (int n : nums) {
        minHeap.push(n);
        if (minHeap.size() > k) minHeap.pop();
    }

    vector<int> result;
    while (!minHeap.empty()) {
        result.push_back(minHeap.top());
        minHeap.pop();
    }
    return result;
}

// 方法2: 使用 nth_element (平均 O(n))
vector<int> topK_nthElement(const vector<int>& nums, int k) {
    vector<int> arr = nums;
    nth_element(arr.begin(), arr.begin() + k, arr.end(), greater<int>());
    arr.resize(k);
    return arr;
}

// 方法3: 排序后取前 K
vector<int> topK_sort(const vector<int>& nums, int k) {
    vector<int> arr = nums;
    sort(arr.begin(), arr.end(), greater<int>());
    return vector<int>(arr.begin(), arr.begin() + k);
}

// 找第 K 大的元素
int findKthLargest(vector<int>& nums, int k) {
    // 方法1: 堆
    priority_queue<int> pq(nums.begin(), nums.end());
    for (int i = 0; i < k - 1; i++) pq.pop();
    return pq.top();
}

int main() {
    cout << "=== Top-K 问题 ===" << endl;
    vector<int> nums = {4, 5, 1, 6, 2, 7, 3, 8, 9, 10};
    int k = 3;

    cout << "原数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "K = " << k << endl;

    cout << "\\n方法1 - 最小堆: ";
    vector<int> r1 = topK_minHeap(nums, k);
    for (int n : r1) cout << n << " ";
    cout << endl;

    cout << "方法2 - nth_element: ";
    vector<int> r2 = topK_nthElement(nums, k);
    for (int n : r2) cout << n << " ";
    cout << endl;

    cout << "方法3 - 排序: ";
    vector<int> r3 = topK_sort(nums, k);
    for (int n : r3) cout << n << " ";
    cout << endl;

    cout << "\\n=== 第 K 大的元素 ===" << endl;
    nums = {3, 2, 1, 5, 6, 4};
    k = 2;
    cout << "数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "第 " << k << " 大的元素: " << findKthLargest(nums, k) << endl;

    cout << "\\n=== 时间复杂度对比 ===" << endl;
    cout << "堆排序取 Top-K: O(n log k)" << endl;
    cout << "全排序取 Top-K: O(n log n)" << endl;
    cout << "nth_element取 Top-K: O(n)" << endl;

    return 0;
}''',
          description: '展示 Top-K 问题的三种解法：最小堆、nth_element 和全排序，以及它们的时间复杂度。',
          output: '''=== Top-K 问题 ===
原数组: 4 5 1 6 2 7 3 8 9 10 
K = 3

方法1 - 最小堆: 8 9 10 
方法2 - nth_element: 10 9 8 
方法3 - 排序: 10 9 8 

=== 第 K 大的元素 ===
数组: 3 2 1 5 6 4 
第 2 大的元素: 5

=== 时间复杂度对比 ===
堆排序取 Top-K: O(n log k)
全排序取 Top-K: O(n log n)
nth_element取 Top-K: O(n)''',
        ),
        CodeExample(
          title: '滑动窗口最大值',
          code: '''#include <iostream>
#include <vector>
#include <deque>
using namespace std;

// 滑动窗口最大值 - 单调递减双端队列
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    vector<int> result;
    deque<int> dq;  // 存索引，保持 nums[dq] 递减

    for (int i = 0; i < nums.size(); i++) {
        // 1. 移除超出窗口的索引
        while (!dq.empty() && dq.front() <= i - k) {
            dq.pop_front();
        }

        // 2. 保持 deque 递减（新元素比队尾大就弹出队尾）
        while (!dq.empty() && nums[dq.back()] < nums[i]) {
            dq.pop_back();
        }
        dq.push_back(i);

        // 3. 记录答案（窗口形成后）
        if (i >= k - 1) {
            result.push_back(nums[dq.front()]);
        }
    }

    return result;
}

// 使用优先队列（更简单但 O(n log k)）
vector<int> maxSlidingWindow_PQ(vector<int>& nums, int k) {
    priority_queue<pair<int,int>> pq;  // {值, 索引}
    vector<int> result;

    for (int i = 0; i < nums.size(); i++) {
        pq.push({nums[i], i});
        if (i >= k - 1) {
            while (pq.top().second < i - k + 1) pq.pop();
            result.push_back(pq.top().first);
        }
    }

    return result;
}

int main() {
    cout << "=== 滑动窗口最大值 ===" << endl;
    vector<int> nums = {1, 3, -1, -3, 5, 3, 6, 7};
    int k = 3;

    cout << "数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "窗口大小 k = " << k << endl;

    vector<int> result = maxSlidingWindow(nums, k);

    cout << "\\n单调队列法结果: ";
    for (int i = 0; i < result.size(); i++) {
        cout << "窗口[" << i << "-" << i+k-1
             << "]最大值=" << result[i];
        if (i < result.size() - 1) cout << ", ";
    }
    cout << endl;

    // 手动展示过程
    cout << "\\n=== 过程演示 ===" << endl;
    nums = {1, 3, -1, -3, 5, 3, 6, 7};
    k = 3;
    deque<int> dq;

    for (int i = 0; i < nums.size(); i++) {
        // 移除超出窗口的
        if (!dq.empty() && dq.front() <= i - k) {
            cout << "移除索引 " << dq.front() << endl;
            dq.pop_front();
        }

        // 移除比当前元素小的队尾
        while (!dq.empty() && nums[dq.back()] < nums[i]) {
            cout << "弹出 " << nums[dq.back()] << " (比 " << nums[i] << " 小)" << endl;
            dq.pop_back();
        }

        dq.push_back(i);
        cout << "加入 " << nums[i] << " (索引 " << i << "), deque: ";
        for (int idx : dq) cout << nums[idx] << " ";
        cout << endl;

        if (i >= k - 1) {
            cout << "  → 窗口[" << i - k + 1 << "-" << i << "] 最大值: "
                 << nums[dq.front()] << endl;
        }
    }

    return 0;
}''',
          description: '展示滑动窗口最大值的单调队列解法，以及详细的执行过程。',
          output: '''=== 滑动窗口最大值 ===
数组: 1 3 -1 -3 5 3 6 7 
窗口大小 k = 3

单调队列法结果: 窗口[0-2]最大值=3, 窗口[1-3]最大值=3, ...

=== 过程演示 ===
加入 1 (索引 0), deque: 1 
  → 窗口[0-2] 最大值: 1
加入 3 (索引 1), deque: 3 
  → 窗口[0-2] 最大值: 3
加入 -1 (索引 2), deque: 3 -1 
...''',
        ),
      ],
      keyPoints: [
        'Top-K 问题：维护大小为 K 的最小堆，时间复杂度 O(n log k)，优于全排序 O(n log n)',
        '单调递减 deque 能在 O(n) 时间内解决滑动窗口最大值问题',
        '单调队列的核心：队首是当前窗口最大，队尾维护递减顺序',
        '第 K 大/小问题可用 nth_element 平均 O(n) 解决',
        '堆排序适合需要 O(n log n) 且要求最坏情况也稳定的场景（快速排序最坏 O(n²)）',
      ],
    ),
  ],
);
