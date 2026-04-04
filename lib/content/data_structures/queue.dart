// 数据结构 - 队列 - Queue
import '../course_data.dart';

/// 队列章节
const chapterQueue = CourseChapter(
  id: 'data_structures_queue',
  title: '队列 (Queue)',
  description: '学习 C++ 中队列数据结构的概念、实现和应用场景，包括BFS、广度优先遍历等经典算法。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'data_structures_queue_concept',
      title: '队列的概念与实现',
      content: '''# 队列的概念与实现

## 什么是队列？

队列是一种**先进先出 (FIFO - First In First Out)** 的数据结构。

```
     front                      rear
       │                         │
       ▼                         ▼
     ┌────┬────┬────┬────┬────┐
     │ A  │ B  │ C  │ D  │ E  │
     └────┴────┴────┴────┴────┘
      ↑
      │
    最早进入的元素，最先被取出
```

## 队列的基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|------------|
| `push/enqueue` | 入队，从队尾添加元素 | O(1) |
| `pop/dequeue` | 出队，从队首移除元素 | O(1) |
| `front` | 查看队首元素 | O(1) |
| `back` | 查看队尾元素 | O(1) |
| `empty` | 判断是否为空 | O(1) |
| `size` | 返回元素个数 | O(1) |

## 队列的顺序存储实现（循环队列）

使用数组实现环形队列，避免空间浪费：

```cpp
template<typename T, int MAX_SIZE = 1000>
class Queue {
private:
    T data[MAX_SIZE];
    int front, rear;  // 队首和队尾索引
    int count;        // 元素个数
public:
    Queue() : front(0), rear(0), count(0) {}
    bool push(const T& item);
    void pop();
    T& front();
    bool empty() const { return count == 0; }
};
```

## 循环队列的原理

```
初始状态: front = rear = 0

入队: rear = (rear + 1) % MAX_SIZE
出队: front = (front + 1) % MAX_SIZE

队满: (rear + 1) % MAX_SIZE == front
队空: front == rear
```

## 队列的链式存储实现

使用链表实现，队首在链表头部，队尾在链表尾部：

```cpp
template<typename T>
struct Node {
    T data;
    Node* next;
};

template<typename T>
class LinkedQueue {
private:
    Node<T> *front, *rear;
public:
    void enqueue(const T& item);
    void dequeue();
};
```

## STL 中的队列

`<queue>` 提供了现成的队列：

```cpp
#include <queue>
queue<int> q;
q.push(1);   // 入队
q.pop();     // 出队
q.front();   // 队首
q.back();    // 队尾
```

## 队列的使用场景

- 广度优先搜索 (BFS)
- 任务调度（打印机队列）
- 消息队列
- 滑动窗口
- 缓冲区管理
''',
      codeExamples: [
        CodeExample(
          title: '队列的实现',
          code: '''#include <iostream>
#include <queue>
#include <vector>
#include <stdexcept>
using namespace std;

// 循环队列实现
template<typename T>
class CircularQueue {
private:
    vector<T> data;
    int front;   // 队首索引
    int rear;    // 队尾索引
    int capacity; // 容量

public:
    CircularQueue(int cap = 100) : front(0), rear(0), capacity(cap + 1) {
        data.resize(capacity);
    }

    bool isEmpty() const {
        return front == rear;
    }

    bool isFull() const {
        return (rear + 1) % capacity == front;
    }

    void enqueue(const T& item) {
        if (isFull()) {
            throw overflow_error("Queue is full!");
        }
        data[rear] = item;
        rear = (rear + 1) % capacity;
    }

    void dequeue() {
        if (isEmpty()) {
            throw underflow_error("Queue is empty!");
        }
        front = (front + 1) % capacity;
    }

    T& frontItem() {
        if (isEmpty()) {
            throw underflow_error("Queue is empty!");
        }
        return data[front];
    }

    T& backItem() {
        if (isEmpty()) {
            throw underflow_error("Queue is empty!");
        }
        int lastIndex = (rear - 1 + capacity) % capacity;
        return data[lastIndex];
    }

    int size() const {
        if (rear >= front) {
            return rear - front;
        } else {
            return capacity - front + rear;
        }
    }
};

int main() {
    cout << "=== 自定义循环队列 ===" << endl;
    CircularQueue<int> q(5);  // 最多存5个元素

    cout << "入队: 10, 20, 30, 40" << endl;
    q.enqueue(10);
    q.enqueue(20);
    q.enqueue(30);
    q.enqueue(40);

    cout << "队首: " << q.frontItem() << endl;
    cout << "队尾: " << q.backItem() << endl;
    cout << "大小: " << q.size() << endl;

    cout << "\\n出队两次" << endl;
    q.dequeue();
    q.dequeue();
    cout << "新队首: " << q.frontItem() << endl;
    cout << "大小: " << q.size() << endl;

    cout << "\\n再入队: 50, 60" << endl;
    q.enqueue(50);
    q.enqueue(60);
    cout << "队首: " << q.frontItem() << ", 队尾: " << q.backItem() << endl;

    cout << "\\n=== STL queue ===" << endl;
    queue<int> stlQ;
    stlQ.push(1);
    stlQ.push(2);
    stlQ.push(3);

    cout << "front: " << stlQ.front() << ", back: " << stlQ.back() << endl;
    stlQ.pop();
    cout << "pop 后 front: " << stlQ.front() << endl;

    cout << "\\n=== 队列遍历 ===" << endl;
    while (!stlQ.empty()) {
        cout << stlQ.front() << " ";
        stlQ.pop();
    }
    cout << endl;

    return 0;
}''',
          description: '展示循环队列的原理和 STL queue 的使用。',
          output: '''=== 自定义循环队列 ===
入队: 10, 20, 30, 40
队首: 10
队尾: 40
大小: 4

出队两次
新队首: 30
大小: 2

再入队: 50, 60
队首: 30, 队尾: 60

=== STL queue ===
front: 1, back: 3
pop 后 front: 2

=== 队列遍历 ===
2 3''',
        ),
        CodeExample(
          title: 'BFS 广度优先搜索',
          code: '''#include <iostream>
#include <queue>
#include <vector>
#include <tuple>
using namespace std;

// BFS 迷宫最短路径
struct Position {
    int x, y, dist;
    Position(int px, int py, int d = 0) : x(px), y(py), dist(d) {}
};

bool isValid(int x, int y, int n, int m) {
    return x >= 0 && x < n && y >= 0 && y < m;
}

int bfsMaze(const vector<vector<int>>& maze, Position start, Position end) {
    if (maze[start.x][start.y] == 0 || maze[end.x][end.y] == 0) {
        return -1;  // 起点或终点不可达
    }

    const int dx[] = {-1, 1, 0, 0};
    const int dy[] = {0, 0, -1, 1};

    queue<Position> q;
    vector<vector<bool>> visited(maze.size(), vector<bool>(maze[0].size(), false));

    q.push(start);
    visited[start.x][start.y] = true;

    while (!q.empty()) {
        Position curr = q.front();
        q.pop();

        if (curr.x == end.x && curr.y == end.y) {
            return curr.dist;
        }

        for (int i = 0; i < 4; i++) {
            int nx = curr.x + dx[i];
            int ny = curr.y + dy[i];

            if (isValid(nx, ny, maze.size(), maze[0].size()) &&
                maze[nx][ny] == 1 && !visited[nx][ny]) {
                visited[nx][ny] = true;
                q.push(Position(nx, ny, curr.dist + 1));
            }
        }
    }

    return -1;  // 无法到达
}

// BFS 层序遍历二叉树
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

void levelOrder(TreeNode* root) {
    if (!root) return;

    queue<TreeNode*> q;
    q.push(root);

    while (!q.empty()) {
        int levelSize = q.size();
        for (int i = 0; i < levelSize; i++) {
            TreeNode* node = q.front();
            q.pop();
            cout << node->val << " ";

            if (node->left) q.push(node->left);
            if (node->right) q.push(node->right);
        }
        cout << endl;  // 每层换行
    }
}

int main() {
    cout << "=== BFS 迷宫最短路径 ===" << endl;
    // 1 = 可走, 0 = 墙
    vector<vector<int>> maze = {
        {1, 0, 1, 1, 1},
        {1, 1, 1, 0, 1},
        {0, 0, 1, 0, 1},
        {0, 1, 1, 1, 1},
    };

    Position start(0, 0), end(3, 4);
    int dist = bfsMaze(maze, start, end);
    cout << "从 (" << start.x << "," << start.y << ") 到 ("
         << end.x << "," << end.y << ") 最短距离: " << dist << endl;

    cout << "\\n=== BFS 层序遍历二叉树 ===" << endl;
    // 构建二叉树
    //     1
    //    / \\
    //   2   3
    //  / \\   \\
    // 4   5   6
    TreeNode* root = new TreeNode(1);
    root->left = new TreeNode(2);
    root->right = new TreeNode(3);
    root->left->left = new TreeNode(4);
    root->left->right = new TreeNode(5);
    root->right->right = new TreeNode(6);

    levelOrder(root);

    return 0;
}''',
          description: '展示 BFS 在迷宫最短路径和二叉树层序遍历中的应用。',
          output: '''=== BFS 迷宫最短路径 ===
从 (0,0) 到 (3,4) 最短距离: 7

=== BFS 层序遍历二叉树 ===
1 
2 3 
4 5 6''',
        ),
      ],
      keyPoints: [
        '队列是先进先出 (FIFO) 的数据结构，队首出队，队尾入队',
        '循环队列利用数组的环形索引，避免普通队列的假溢出问题',
        '队满条件：(rear + 1) % capacity == front，队空条件：front == rear',
        'BFS 使用队列实现，适合寻找最短路径和层序遍历',
        '二叉树层序遍历使用队列，每层处理完后再处理下一层',
      ],
    ),

    CourseLesson(
      id: 'data_structures_queue_advanced',
      title: '双端队列与优先队列',
      content: '''# 双端队列与优先队列

## 双端队列 (Deque)

双端队列是一种可以在两端进行插入和删除操作的数据结构。

```
       push_front      push_back
            │              │
            ▼              ▼
     ┌────┬────┬────┬────┬────┐
     │ A  │ B  │ C  │ D  │ E  │
     └────┴────┴────┴────┴────┘
            ▲              ▲
            │              │
       pop_front       pop_back
```

## Deque 的操作

| 操作 | 说明 |
|------|------|
| `push_front` | 头部插入 |
| `push_back` | 尾部插入 |
| `pop_front` | 头部删除 |
| `pop_back` | 尾部删除 |
| `front` | 访问头部 |
| `back` | 访问尾部 |

## Deque vs Vector

| 特性 | Deque | Vector |
|------|-------|--------|
| 头部插入 | O(1) | O(n) |
| 尾部插入 | O(1) | O(1) 均摊 |
| 随机访问 | O(1) | O(1) |
| 内存连续性 | 不保证连续 | 连续 |
| 迭代器稳定性 | 中间插入可能失效 | 中间插入可能失效 |

## 优先队列 (Priority Queue)

优先队列是元素按优先级排序的队列，高优先级元素先出队。

### 底层实现

- **二叉堆 (Binary Heap)**：最常用，O(log n) 的插入和删除
- **配对堆 (Pairing Heap)**
- **斐波那契堆 (Fibonacci Heap)**

### STL 优先队列

```cpp
#include <queue>
priority_queue<int> pq;           // 默认最大堆
priority_queue<int, vector<int>, greater<int>> minPQ;  // 最小堆
```

### 自定义比较

```cpp
struct Student {
    string name;
    int score;
};

// 按分数降序（分数高的优先级高）
struct cmp {
    bool operator()(const Student& a, const Student& b) {
        return a.score < b.score;  // 返回 true 表示 a 优先级低于 b
    }
};

priority_queue<Student, vector<Student>, cmp> pq;
```

## 优先队列的应用

- Dijkstra 最短路径算法
- Huffman 编码
- 任务调度（按优先级）
- Top-K 问题
- 合并 K 个有序数组
''',
      codeExamples: [
        CodeExample(
          title: 'STL deque 和优先队列',
          code: '''#include <iostream>
#include <deque>
#include <queue>
#include <vector>
#include <string>
#include <functional>
using namespace std;

int main() {
    cout << "=== STL deque ===" << endl;
    deque<int> dq;

    // 两端操作
    dq.push_back(1);
    dq.push_back(2);
    dq.push_front(0);
    cout << "dq: ";
    for (int n : dq) cout << n << " ";
    cout << endl;

    dq.pop_front();
    dq.pop_back();
    cout << "pop 后: ";
    for (int n : dq) cout << n << " ";
    cout << endl;

    cout << "\\n=== 最大堆 (priority_queue) ===" << endl;
    priority_queue<int> maxPQ;

    vector<int> nums = {10, 30, 20, 50, 40};
    for (int n : nums) {
        maxPQ.push(n);
        cout << "push " << n << ", top=" << maxPQ.top() << endl;
    }

    cout << "\\n弹出所有元素: ";
    while (!maxPQ.empty()) {
        cout << maxPQ.top() << " ";
        maxPQ.pop();
    }
    cout << endl;

    cout << "\\n=== 最小堆 (greater<int>) ===" << endl;
    priority_queue<int, vector<int>, greater<int>> minPQ(nums.begin(), nums.end());

    cout << "最小堆元素: ";
    while (!minPQ.empty()) {
        cout << minPQ.top() << " ";
        minPQ.pop();
    }
    cout << endl;

    cout << "\\n=== 自定义类型优先队列 ===" << endl;
    struct Task {
        string name;
        int priority;
    };

    struct TaskCmp {
        bool operator()(const Task& a, const Task& b) const {
            return a.priority < b.priority;  // 优先级高的先出
        }
    };

    priority_queue<Task, vector<Task>, TaskCmp> taskPQ;
    taskPQ.push({"紧急bug修复", 100});
    taskPQ.push({"功能开发", 50});
    taskPQ.push({"代码优化", 30});

    cout << "任务执行顺序 (按优先级):" << endl;
    while (!taskPQ.empty()) {
        cout << "执行: " << taskPQ.top().name
             << " (优先级=" << taskPQ.top().priority << ")" << endl;
        taskPQ.pop();
    }

    return 0;
}''',
          description: '展示 STL deque 的两端操作，以及最大堆和最小堆 priority_queue 的使用。',
          output: '''=== STL deque ===
dq: 0 1 2 
pop 后: 1

=== 最大堆 (priority_queue) ===
push 10, top=10
push 30, top=30
push 20, top=30
push 50, top=50
push 40, top=50

弹出所有元素: 50 40 30 20 10 

=== 最小堆 (greater<int>) ===
最小堆元素: 10 20 30 40 50 

=== 自定义类型优先队列 ===
任务执行顺序 (按优先级):
执行: 紧急bug修复 (优先级=100)
执行: 功能开发 (优先级=50)
执行: 代码优化 (优先级=30)''',
        ),
        CodeExample(
          title: 'Top-K 与滑动窗口',
          code: '''#include <iostream>
#include <queue>
#include <vector>
#include <deque>
using namespace std;

// Top-K 问题：找出前 K 大的元素
vector<int> topK(const vector<int>& nums, int k) {
    priority_queue<int> pq;
    for (int n : nums) {
        pq.push(n);
    }

    vector<int> result;
    for (int i = 0; i < k && !pq.empty(); i++) {
        result.push_back(pq.top());
        pq.pop();
    }
    return result;
}

// 滑动窗口最大值 (使用单调递减 deque)
vector<int> maxSlidingWindow(const vector<int>& nums, int k) {
    vector<int> result;
    deque<int> dq;  // 存索引，保持递减

    for (int i = 0; i < nums.size(); i++) {
        // 移除超出窗口的索引
        while (!dq.empty() && dq.front() <= i - k) {
            dq.pop_front();
        }

        // 保持 deque 递减（队首是当前最大）
        while (!dq.empty() && nums[dq.back()] < nums[i]) {
            dq.pop_back();
        }
        dq.push_back(i);

        // 记录结果
        if (i >= k - 1) {
            result.push_back(nums[dq.front()]);
        }
    }

    return result;
}

// 合并 K 个有序数组
struct ListNode {
    int val;
    int listIdx;  // 来自哪个数组
    ListNode(int v, int idx) : val(v), listIdx(idx) {}
};

struct ListNodeCmp {
    bool operator()(const ListNode& a, const ListNode& b) const {
        return a.val > b.val;  // 最小堆
    }
};

vector<int> mergeKSorted(const vector<vector<int>>& lists) {
    priority_queue<ListNode, vector<ListNode>, ListNodeCmp> pq;

    // 每个数组第一个元素入堆
    for (int i = 0; i < lists.size(); i++) {
        if (!lists[i].empty()) {
            pq.push(ListNode(lists[i][0], i));
        }
    }

    vector<int> result;
    vector<int> indexes(lists.size(), 0);

    while (!pq.empty()) {
        ListNode node = pq.top();
        pq.pop();
        result.push_back(node.val);

        // 同一数组下一个元素入堆
        if (indexes[node.listIdx] + 1 < lists[node.listIdx].size()) {
            indexes[node.listIdx]++;
            pq.push(ListNode(lists[node.listIdx][indexes[node.listIdx]], node.listIdx));
        }
    }

    return result;
}

int main() {
    cout << "=== Top-K 问题 ===" << endl;
    vector<int> nums = {4, 5, 1, 6, 2, 7, 3, 8};
    vector<int> top = topK(nums, 3);
    cout << "原数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "前3大的: ";
    for (int n : top) cout << n << " ";
    cout << endl;

    cout << "\\n=== 滑动窗口最大值 ===" << endl;
    vector<int> window = {1, 3, -1, -3, 5, 3, 6, 7};
    int k = 3;
    vector<int> maxWindow = maxSlidingWindow(window, k);
    cout << "数组: ";
    for (int n : window) cout << n << " ";
    cout << endl;
    cout << "窗口大小 k=" << k << ", 最大值: ";
    for (int n : maxWindow) cout << n << " ";
    cout << endl;

    cout << "\\n=== 合并 K 个有序数组 ===" << endl;
    vector<vector<int>> lists = {
        {1, 4, 7},
        {2, 5, 8},
        {3, 6, 9}
    };
    vector<int> merged = mergeKSorted(lists);
    cout << "合并结果: ";
    for (int n : merged) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示优先队列在 Top-K 问题、滑动窗口最大值和合并 K 个有序数组中的应用。',
          output: '''=== Top-K 问题 ===
原数组: 4 5 1 6 2 7 3 8 
前3大的: 8 7 6 

=== 滑动窗口最大值 ===
数组: 1 3 -1 -3 5 3 6 7 
窗口大小 k=3, 最大值: 3 3 5 5 6 7 

=== 合并 K 个有序数组 ===
合并结果: 1 2 3 4 5 6 7 8 9''',
        ),
      ],
      keyPoints: [
        'deque 支持两端 O(1) 插入删除，头部插入比 vector 高效',
        'priority_queue 默认是最大堆，使用 greater<int> 切换为最小堆',
        '自定义优先队列需要提供比较函数或比较结构体',
        '单调递减 deque 可用于滑动窗口最大值问题，O(n) 时间复杂度',
        '合并 K 个有序数组用最小堆，每次取出当前最小元素',
      ],
    ),
  ],
);
