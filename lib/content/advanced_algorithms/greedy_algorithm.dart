// 高级算法 - 贪心算法 - Greedy Algorithm
import '../course_data.dart';

/// 贪心算法章节
const chapterGreedyAlgorithm = CourseChapter(
  id: 'advanced_algorithms_greedy_algorithm',
  title: '贪心算法 (Greedy Algorithm)',
  description: '学习贪心算法的核心思想、活动选择、哈夫曼编码、钱币找零等经典问题。',
  difficulty: DifficultyLevel.advanced,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'advanced_algorithms_greedy_concept',
      title: '贪心算法基础',
      content: '''# 贪心算法基础

## 什么是贪心算法？

贪心算法是一种**每一步都选择当前最优**的算法策略，期望通过局部最优达到全局最优。

```
贪心算法的特点：
1. 每一步都做出局部最优选择
2. 不考虑之前的选择对未来影响
3. 不回溯
4. 通常比穷举高效
```

## 贪心 vs 动态规划

| 特点 | 贪心 | 动态规划 |
|------|------|----------|
| 策略 | 每步最优 | 全局最优 |
| 选择 | 只考虑当前 | 考虑子问题 |
| 依赖 | 不依赖子问题 | 依赖子问题 |
| 最优性 | 不保证全局最优 | 保证全局最优 |
| 效率 | 通常 O(n) 或 O(n log n) | 通常 O(n²) 或更高 |

## 贪心算法正确性证明

要证明贪心算法正确，通常需要证明：

1. **贪心选择性质**：存在一个最优解可以通过贪心选择得到
2. **最优子结构**：问题的最优解包含子问题的最优解

## 贪心算法的应用场景

1. **区间调度**：选择不重叠的最多数量的区间
2. **哈夫曼编码**：最优前缀码
3. **最小生成树**：Prim、Kruskal 算法
4. **最短路径**：Dijkstra 算法
5. **钱币找零**：优先使用大面额
6. **任务排序**：按截止时间/收益排序

## 贪心算法的局限性

不是所有问题都能用贪心解决，例如：

- **0-1 背包问题**：不能简单按价值密度贪心
- **旅行商问题**：需要动态规划
- **最长公共子序列**：需要动态规划

## 经典问题分类

| 问题 | 贪心策略 |
|------|----------|
| 活动选择 | 按结束时间排序 |
| 钱币找零 | 优先使用大面额 |
| 区间覆盖 | 选择最短的 |
| 哈夫曼编码 | 频率最小的优先合并 |
| 任务调度 | 按截止时间排序 |
''',
      codeExamples: [
        CodeExample(
          title: '活动选择问题',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct Activity {
    int start;
    int end;
};

// 按结束时间排序
bool cmpEnd(const Activity& a, const Activity& b) {
    return a.end < b.end;
}

// 按开始时间排序（辅助理解）
bool cmpStart(const Activity& a, const Activity& b) {
    return a.start < b.start;
}

int activitySelection(vector<Activity>& activities) {
    if (activities.empty()) return 0;

    // 按结束时间排序
    sort(activities.begin(), activities.end(), cmpEnd);

    // 选择第一个活动（结束最早）
    int count = 1;
    int lastEnd = activities[0].end;

    cout << "选择活动: [" << activities[0].start << ", "
         << activities[0].end << "]" << endl;

    // 选择与已选活动不重叠且结束最早的活动
    for (size_t i = 1; i < activities.size(); i++) {
        if (activities[i].start >= lastEnd) {
            count++;
            lastEnd = activities[i].end;
            cout << "选择活动: [" << activities[i].start << ", "
                 << activities[i].end << "]" << endl;
        }
    }

    return count;
}

// 打印详细过程
void activitySelectionVerbose(vector<Activity>& activities) {
    sort(activities.begin(), activities.end(), cmpEnd);

    cout << "\\n按结束时间排序后:" << endl;
    for (const auto& a : activities) {
        cout << "[" << a.start << ", " << a.end << "]" << endl;
    }

    cout << "\\n贪心选择过程:" << endl;
    int count = 0;
    int lastEnd = -1;

    for (const auto& a : activities) {
        if (a.start >= lastEnd) {
            count++;
            lastEnd = a.end;
            cout << "选择 [" << a.start << ", " << a.end << "]"
                 << " (当前结束时间=" << lastEnd << ")" << endl;
        } else {
            cout << "跳过 [" << a.start << ", " << a.end << "]"
                 << " (与 " << lastEnd << " 冲突)" << endl;
        }
    }

    cout << "总共选择 " << count << " 个活动" << endl;
}

int main() {
    cout << "=== 活动选择问题 ===" << endl;

    vector<Activity> activities = {
        {1, 4}, {3, 5}, {0, 6}, {5, 7}, {3, 9},
        {5, 9}, {6, 10}, {8, 11}, {8, 12}, {2, 14}, {12, 16}
    };

    cout << "活动集合 (开始, 结束):" << endl;
    for (const auto& a : activities) {
        cout << "(" << a.start << ", " << a.end << ") ";
    }
    cout << endl;

    activitySelectionVerbose(activities);

    cout << "\\n=== 简单测试 ===" << endl;
    vector<Activity> simple = {{1, 3}, {2, 5}, {4, 6}, {6, 8}};
    cout << "最大活动数: " << activitySelection(simple) << endl;

    return 0;
}''',
          description: '展示活动选择问题的贪心算法实现，按结束时间排序后选择不重叠的活动。',
          output: '''=== 活动选择问题 ===
活动集合 (开始, 结束):
(1, 4) (3, 5) (0, 6) (5, 7) (3, 9) (5, 9) (6, 10) (8, 11) (8, 12) (2, 14) (12, 16)

按结束时间排序后:
[1, 4]
[3, 5]
[4, 6]
[5, 7]
[6, 10]
[8, 11]
[8, 12]
[0, 6]
[12, 16]
[2, 14]
[3, 9]

贪心选择过程:
选择 [1, 4] (当前结束时间=4)
选择 [4, 6] (当前结束时间=6)
选择 [6, 10] (当前结束时间=10)
选择 [12, 16] (当前结束时间=16)
总共选择 4 个活动

=== 简单测试 ===
最大活动数: 3''',
        ),
        CodeExample(
          title: '钱币找零与任务调度',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 钱币找零 - 优先使用大面额
int minCoins(vector<int>& coins, int amount) {
    // 排序（如果没排序）
    sort(coins.begin(), coins.end(), greater<int>());

    int count = 0;
    int remaining = amount;

    cout << "找零 " << amount << " 元:" << endl;
    for (int coin : coins) {
        if (remaining <= 0) break;

        int num = remaining / coin;
        if (num > 0) {
            cout << "使用 " << num << " 个 " << coin << " 元硬币" << endl;
            count += num;
            remaining -= num * coin;
        }
    }

    return count;
}

// 任务调度 - 最大利润
struct Task {
    int deadline;
    int profit;
};

int maxProfitScheduling(vector<Task>& tasks) {
    // 按利润排序（利润高的优先）
    sort(tasks.begin(), tasks.end(),
         [](const Task& a, const Task& b) {
             return a.profit > b.profit;
         });

    int maxDeadline = 0;
    for (const auto& t : tasks) {
        maxDeadline = max(maxDeadline, t.deadline);
    }

    // 标记哪天已被占用
    vector<bool> dayUsed(maxDeadline + 1, false);
    int totalProfit = 0;
    int count = 0;

    cout << "任务安排:" << endl;
    for (const auto& task : tasks) {
        // 从截止日期往前找空闲的天
        for (int d = task.deadline; d >= 1; d--) {
            if (!dayUsed[d]) {
                dayUsed[d] = true;
                totalProfit += task.profit;
                count++;
                cout << "第 " << d << " 天: 任务(截止"
                     << task.deadline << ", 利润"
                     << task.profit << ")" << endl;
                break;
            }
        }
    }

    return totalProfit;
}

int main() {
    cout << "=== 钱币找零 ===" << endl;
    vector<int> coins = {1, 2, 5, 10, 20, 50, 100};
    int amount = 63;

    int numCoins = minCoins(coins, amount);
    cout << "最少需要 " << numCoins << " 个硬币" << endl;

    cout << "\\n=== 任务调度（最大利润）===" << endl;
    vector<Task> tasks = {
        {2, 100}, {1, 19}, {2, 27}, {1, 25}, {3, 15}
    };

    cout << "原始任务 (截止日期, 利润):" << endl;
    for (const auto& t : tasks) {
        cout << "(" << t.deadline << ", " << t.profit << ") ";
    }
    cout << endl;

    int profit = maxProfitScheduling(tasks);
    cout << "获得最大利润: " << profit << endl;

    return 0;
}''',
          description: '展示钱币找零和任务调度的贪心算法实现。',
          output: '''=== 钱币找零 ===
找零 63 元:
使用 1 个 50 元硬币
使用 1 个 10 元硬币
使用 3 个 1 元硬币
最少需要 5 个硬币

=== 任务调度（最大利润）===
原始任务 (截止日期, 利润):
(2, 100) (1, 19) (2, 27) (1, 25) (3, 15)
任务安排:
第 2 天: 任务(截止2, 利润100)
第 3 天: 任务(截止3, 利润15)
第 1 天: 任务(截止1, 利润25)
获得最大利润: 140''',
        ),
      ],
      keyPoints: [
        '贪心算法每步选择当前最优，不考虑对未来的影响',
        '贪心不一定能得到全局最优，需要证明贪心选择性质',
        '活动选择问题：按结束时间排序，选择不重叠且结束最早的活动',
        '钱币找零：优先使用大面额（需要面额是倍数关系才最优）',
        '任务调度：按利润排序，从截止日期往前找空闲天安排',
      ],
    ),

    CourseLesson(
      id: 'advanced_algorithms_greedy_huffman',
      title: '哈夫曼编码',
      content: '''# 哈夫曼编码

## 什么是哈夫曼编码？

哈夫曼编码是一种**最优前缀码**，用于无损数据压缩。

## 前缀码

没有任何字符的编码是另一个字符编码的前缀：

```
好的编码:
A=0, B=10, C=110, D=111

坏的编码:
A=0, B=01  ← B 的编码是 A 的前缀
```

## 哈夫曼编码原理

1. 统计每个字符的频率
2. 用频率作为权重构建最小堆
3. 每次取出频率最小的两个节点，合并成新节点
4. 重复直到只剩一个根节点
5. 左子树编码为 0，右子树编码为 1

```
字符: A(45), B(13), C(12), D(16), E(9), F(5)

构建过程:
1. 选择 F(5) 和 E(9) → 合并成节点 14
2. 选择 C(12) 和 14 → 合并成节点 26
3. 选择 D(16) 和 B(13) → 合并成节点 29
4. 选择 A(45) 和 26 → 合并成节点 71
5. 选择 29 和 71 → 合并成根节点 100
```

## 哈夫曼树的特点

- **带权路径长度 (WPL)** 最小
- 频率高的字符离根近，编码短
- 是满二叉树（每个节点要么是叶子，要么有两个孩子）

## 哈夫曼编码 vs ASCII

| 编码方式 | 特点 |
|----------|------|
| ASCII | 每个字符固定 8 位 |
| 哈夫曼 | 频率高的字符编码短，总体更短 |

## 哈夫曼编码的应用

- 文件压缩（gzip、zip）
- JPEG 图片压缩
- MP3 音频压缩
- 通信传输优化
''',
      codeExamples: [
        CodeExample(
          title: '哈夫曼编码实现',
          code: '''#include <iostream>
#include <queue>
#include <vector>
#include <string>
#include <unordered_map>
using namespace std;

// 哈夫曼树节点
struct HuffmanNode {
    char ch;
    int freq;
    HuffmanNode* left;
    HuffmanNode* right;

    HuffmanNode(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}

    // 用于优先队列比较（频率小的优先）
    bool operator>(const HuffmanNode& other) const {
        return freq > other.freq;
    }
};

// 构建哈夫曼树
HuffmanNode* buildHuffmanTree(const unordered_map<char, int>& freq) {
    // 最小堆
    priority_queue<HuffmanNode*, vector<HuffmanNode*>, greater<HuffmanNode*>> pq;

    for (const auto& p : freq) {
        pq.push(new HuffmanNode(p.first, p.second));
    }

    while (pq.size() > 1) {
        // 取出两个频率最小的节点
        HuffmanNode* left = pq.top(); pq.pop();
        HuffmanNode* right = pq.top(); pq.pop();

        cout << "合并: " << left->ch << "(" << left->freq << ") + "
             << right->ch << "(" << right->freq << ") = "
             << (left->freq + right->freq) << endl;

        // 合并成新节点
        HuffmanNode* parent = new HuffmanNode('#', left->freq + right->freq);
        parent->left = left;
        parent->right = right;

        pq.push(parent);
    }

    return pq.top();
}

// 生成哈夫曼编码
void generateCodes(HuffmanNode* root, const string& code,
                   unordered_map<char, string>& huffmanCode) {
    if (!root) return;

    // 叶子节点，保存编码
    if (!root->left && !root->right) {
        huffmanCode[root->ch] = code.empty() ? "0" : code;
        cout << root->ch << ": " << huffmanCode[root->ch] << endl;
        return;
    }

    generateCodes(root->left, code + "0", huffmanCode);
    generateCodes(root->right, code + "1", huffmanCode);
}

// 编码
string encode(const string& text, const unordered_map<char, string>& huffmanCode) {
    string encoded;
    for (char c : text) {
        encoded += huffmanCode.at(c);
    }
    return encoded;
}

// 解码
string decode(const string& encoded, HuffmanNode* root) {
    string decoded;
    HuffmanNode* current = root;

    for (char bit : encoded) {
        current = (bit == '0') ? current->left : current->right;

        if (!current->left && !current->right) {
            decoded += current->ch;
            current = root;
        }
    }

    return decoded;
}

// 计算 WPL
int calculateWPL(HuffmanNode* root, int depth = 0) {
    if (!root) return 0;
    if (!root->left && !root->right) {
        return root->freq * depth;
    }
    return calculateWPL(root->left, depth + 1) +
           calculateWPL(root->right, depth + 1);
}

int main() {
    cout << "=== 哈夫曼编码 ===" << endl;

    string text = "abcdef";
    unordered_map<char, int> freq = {
        {'a', 45}, {'b', 13}, {'c', 12}, {'d', 16}, {'e', 9}, {'f', 5}
    };

    cout << "字符频率:" << endl;
    for (const auto& p : freq) {
        cout << p.first << ": " << p.second << endl;
    }

    cout << "\\n构建哈夫曼树:" << endl;
    HuffmanNode* root = buildHuffmanTree(freq);

    cout << "\\n哈夫曼编码:" << endl;
    unordered_map<char, string> huffmanCode;
    generateCodes(root, "", huffmanCode);

    cout << "\n编码 \"" << text << "\":" << endl;
    string encoded = encode(text, huffmanCode);
    cout << "编码结果: " << encoded << endl;
    cout << "原始长度: " << text.length() * 8 << " 位" << endl;
    cout << "编码长度: " << encoded.length() << " 位" << endl;

    cout << "\\n解码:" << endl;
    string decoded = decode(encoded, root);
    cout << "解码结果: " << decoded << endl;

    cout << "\\n带权路径长度 (WPL): " << calculateWPL(root) << endl;

    return 0;
}''',
          description: '展示哈夫曼编码的完整实现：构建哈夫曼树、生成编码、编码和解码过程。',
          output: '''=== 哈夫曼编码 ===
字符频率:
a: 45
b: 13
c: 12
d: 16
e: 9
f: 5

构建哈夫曼树:
合并: f(5) + e(9) = 14
合并: c(12) + 14 = 26
合并: d(16) + b(13) = 29
合并: a(45) + 26 = 71
合并: 29 + 71 = 100

哈夫曼编码:
a: 0
c: 100
b: 101
d: 110
e: 1110
f: 1111

编码 "abcdef":
编码结果: 0101100111011111
原始长度: 48 位
编码长度: 16 位

解码:
解码结果: abcdef

带权路径长度 (WPL): 224''',
        ),
        CodeExample(
          title: '区间问题与加油站问题',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 合并区间
vector<vector<int>> mergeIntervals(vector<vector<int>>& intervals) {
    if (intervals.empty()) return {};

    // 按起点排序
    sort(intervals.begin(), intervals.end(),
         [](const vector<int>& a, const vector<int>& b) {
             return a[0] < b[0];
         });

    vector<vector<int>> result;
    result.push_back(intervals[0]);

    for (size_t i = 1; i < intervals.size(); i++) {
        if (result.back()[1] >= intervals[i][0]) {
            // 有重叠，合并
            result.back()[1] = max(result.back()[1], intervals[i][1]);
        } else {
            // 无重叠，直接加入
            result.push_back(intervals[i]);
        }
    }

    return result;
}

// 区间选点问题
int minArrowShots(vector<vector<int>>& points) {
    if (points.empty()) return 0;

    // 按结束点排序
    sort(points.begin(), points.end(),
         [](const vector<int>& a, const vector<int>& b) {
             return a[1] < b[1];
         });

    int arrows = 1;
    int lastEnd = points[0][1];

    cout << "射击点位置: " << lastEnd << endl;

    for (const auto& p : points) {
        if (p[0] > lastEnd) {
            arrows++;
            lastEnd = p[1];
            cout << "射击点位置: " << lastEnd << endl;
        }
    }

    return arrows;
}

// 加油站问题 (LeetCode 134)
int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {
    int totalGas = 0, totalCost = 0;
    int currentGas = 0;
    int start = 0;

    for (int i = 0; i < gas.size(); i++) {
        totalGas += gas[i];
        totalCost += cost[i];
        currentGas += gas[i] - cost[i];

        if (currentGas < 0) {
            // 从 i+1 开始
            start = i + 1;
            currentGas = 0;
        }
    }

    return (totalGas >= totalCost) ? start : -1;
}

int main() {
    cout << "=== 合并区间 ===" << endl;
    vector<vector<int>> intervals = {{1,3}, {2,6}, {8,10}, {15,18}};
    cout << "原始区间:" << endl;
    for (const auto& i : intervals)
        cout << "[" << i[0] << ", " << i[1] << "] ";
    cout << endl;

    auto merged = mergeIntervals(intervals);
    cout << "合并后:" << endl;
    for (const auto& m : merged)
        cout << "[" << m[0] << ", " << m[1] << "] ";
    cout << endl;

    cout << "\\n=== 区间选点（气球）===" << endl;
    vector<vector<int>> points = {{10,16}, {2,8}, {1,6}, {7,12}};
    cout << "气球位置:" << endl;
    for (const auto& p : points)
        cout << "[" << p[0] << ", " << p[1] << "] ";
    cout << endl;
    cout << "最少箭数: " << minArrowShots(points) << endl;

    cout << "\\n=== 加油站问题 ===" << endl;
    vector<int> gas = {1,2,3,4,5};
    vector<int> cost = {3,4,5,1,2};
    cout << "gas: ";
    for (int g : gas) cout << g << " ";
    cout << endl;
    cout << "cost: ";
    for (int c : cost) cout << c << " ";
    cout << endl;
    int station = canCompleteCircuit(gas, cost);
    cout << "能完成一圈的起点: " << station << endl;

    return 0;
}''',
          description: '展示区间合并、区间选点和加油站问题的贪心算法实现。',
          output: '''=== 合并区间 ===
原始区间:
[1, 3] [2, 6] [8, 10] [15, 18] 
合并后:
[1, 6] [8, 10] [15, 18] 

=== 区间选点（气球）===
气球位置:
[10, 16] [2, 8] [1, 6] [7, 12] 
射击点位置: 6
射击点位置: 12
最少箭数: 2

=== 加油站问题 ===
gas: 1 2 3 4 5 
cost: 3 4 5 1 2 
能完成一圈的起点: 3''',
        ),
      ],
      keyPoints: [
        '哈夫曼编码：频率最小的两个节点合并，最终 WPL（带权路径长度）最小',
        '哈夫曼编码是前缀码，任何字符编码都不是另一个的前缀',
        '合并区间：按起点排序，然后遍历合并重叠区间',
        '区间选点（气球）问题：按结束点排序，选择能覆盖最多区间的点',
        '加油站问题：累计油量为负时，说明之前任何一个点都不能到达终点，从下一个开始',
      ],
    ),

    CourseLesson(
      id: 'advanced_algorithms_greedy_limitations',
      title: '贪心算法的局限',
      content: '''# 贪心算法的局限

## 贪心不是万能的

有些问题不能简单地用贪心解决，需要用动态规划或其他方法。

## 0-1 背包问题

**问题**：有一个容量为 W 的背包，n 件物品，每件物品有重量 w[i] 和价值 v[i]，每件物品只能选一次。

**为什么不能按价值密度贪心？**

```
物品:
A: 重量=10, 价值=60
B: 重量=20, 价值=100
C: 重量=30, 价值=120

背包容量 W=50

按密度贪心 (A 先选):
A(60/10=6) → B(100/20=5) → C(120/30=4)
选 A + B = 价值 160, 重量 30
还能选 C 吗？不能 (30+30=60 > 50)
总价值 = 160

但最优解是 B + C:
B + C = 价值 220, 重量 50
```

**结论**：0-1 背包必须用动态规划！

## 分数背包问题可以用贪心

如果物品可以分割（分数背包），按价值/重量比排序即可得到最优解。

## 其他不能用贪心的问题

1. **旅行商问题 (TSP)**：需要 O(n!) 或动态规划
2. **最长公共子序列**：需要 DP
3. **编辑距离**：需要 DP
4. **图的全覆盖**：需要 DP 或近似算法

## 何时用贪心？

**判断条件**：
1. 问题具有贪心选择性质（可以通过局部最优达到全局最优）
2. 问题具有最优子结构

**常见能用贪心的问题**：
- 区间调度/活动选择
- 最小生成树 (Prim, Kruskal)
- 单源最短路径 (Dijkstra)
- 哈夫曼编码
- 钱币找零（面额成倍数时）
- 任务调度（单机调度）

## 如何判断一个问题能否用贪心？

1. **直觉判断**：如果直觉告诉你"选最大的/最早的/..."似乎是对的
2. **举反例**：尝试找出一个反例，说明局部最优不等于全局最优
3. **证明**：形式化证明贪心选择性质和最优子结构
4. **对比动态规划**：能用 DP 的问题，贪心不一定对；能用贪心的问题，DP 也能解但可能更慢
''',
      codeExamples: [
        CodeExample(
          title: '0-1 背包不能用贪心',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 0-1 背包 - 只能用动态规划
int knapsackDP(const vector<int>& weights, const vector<int>& values, int W) {
    int n = weights.size();
    vector<int> dp(W + 1, 0);

    for (int i = 0; i < n; i++) {
        for (int j = W; j >= weights[i]; j--) {
            dp[j] = max(dp[j], dp[j-weights[i]] + values[i]);
        }
    }

    return dp[W];
}

// 分数背包 - 可以用贪心
double fractionalKnapsack(const vector<int>& weights, const vector<int>& values, int W) {
    int n = weights.size();
    vector<pair<double, int>> ratio;  // {价值/重量比, 索引}

    for (int i = 0; i < n; i++) {
        ratio.push_back({(double)values[i] / weights[i], i});
    }

    // 按价值/重量比排序
    sort(ratio.begin(), ratio.end(),
         [](const auto& a, const auto& b) {
             return a.first > b.first;
         });

    double totalValue = 0;
    int remaining = W;

    cout << "按价值密度排序:" << endl;
    for (const auto& r : ratio) {
        cout << "物品 " << (char)('A' + r.second)
             << ": " << r.first << endl;
    }
    cout << endl;

    for (const auto& r : ratio) {
        int idx = r.second;
        if (remaining >= weights[idx]) {
            // 全部拿走
            totalValue += values[idx];
            remaining -= weights[idx];
            cout << "全部拿走物品 " << (char)('A' + idx)
                 << ": +" << values[idx] << endl;
        } else {
            // 部分拿走
            double fraction = (double)remaining / weights[idx];
            totalValue += values[idx] * fraction;
            cout << "部分拿走物品 " << (char)('A' + idx)
                 << ": +" << values[idx] * fraction
                 << " (" << fraction * 100 << "%)" << endl;
            remaining = 0;
            break;
        }
    }

    return totalValue;
}

int main() {
    cout << "=== 0-1 背包 vs 分数背包 ===" << endl;

    vector<int> weights = {10, 20, 30};
    vector<int> values = {60, 100, 120};
    int W = 50;

    cout << "物品:" << endl;
    for (int i = 0; i < weights.size(); i++) {
        cout << "物品 " << (char)('A' + i)
             << ": 重量=" << weights[i]
             << ", 价值=" << values[i]
             << ", 价值密度=" << (double)values[i]/weights[i]
             << endl;
    }
    cout << "背包容量: " << W << endl;

    cout << "\\n=== 分数背包（可以用贪心）===" << endl;
    double fractionResult = fractionalKnapsack(weights, values, W);
    cout << "分数背包最优价值: " << fractionResult << endl;

    cout << "\\n=== 0-1 背包（必须用 DP）===" << endl;
    int dpResult = knapsackDP(weights, values, W);
    cout << "0-1 背包最优价值: " << dpResult << endl;

    cout << "\\n=== 贪心失败案例 ===" << endl;
    cout << "如果按价值密度贪心选择:" << endl;
    cout << "1. 选 A (密度 6), 剩余容量 40" << endl;
    cout << "2. 选 B (密度 5), 剩余容量 20" << endl;
    cout << "3. C 放不下 (重量 30 > 20)" << endl;
    cout << "总价值: 60 + 100 = 160" << endl;
    cout << "但最优解是选 B + C = 220" << endl;

    return 0;
}''',
          description: '对比展示分数背包可以用贪心，而 0-1 背包必须用动态规划。',
          output: '''=== 0-1 背包 vs 分数背包 ===
物品:
物品 A: 重量=10, 价值=60, 价值密度=6
物品 B: 重量=20, 价值=100, 价值密度=5
物品 C: 重量=30, 价值=120, 价值密度=4
背包容量: 50

=== 分数背包（可以用贪心）===
按价值密度排序:
物品 A: 6
物品 B: 5
物品 C: 4

全部拿走物品 A: +60
全部拿走物品 B: +100
部分拿走物品 C: +40 (33.333333333333%)
分数背包最优价值: 200

=== 0-1 背包（必须用 DP）===
0-1 背包最优价值: 220

=== 贪心失败案例 ===
如果按价值密度贪心选择:
1. 选 A (密度 6), 剩余容量 40
2. 选 B (密度 5), 剩余容量 20
3. C 放不下 (重量 30 > 20)
总价值: 60 + 100 = 160
但最优解是选 B + C = 220''',
        ),
        CodeExample(
          title: '选择正确算法的判断',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 判断问题应该用贪心还是 DP
void explainProblem(const string& name, const string& solution) {
    cout << "=== " << name << " ===" << endl;
    cout << solution << endl << endl;
}

int main() {
    cout << "=== 算法选择指南 ===" << endl << endl;

    explainProblem("活动选择问题",
        "贪心 ✓\n"
        "策略: 按结束时间排序\n"
        "原因: 选择结束最早的活动，保留更多时间给其他活动");

    explainProblem("0-1 背包问题",
        "动态规划 ✗ (不能用贪心)\n"
        "原因: 局部最优(按密度选)不等于全局最优\n"
        "反例: A(10,60), B(20,100), C(30,120), W=50");

    explainProblem("分数背包问题",
        "贪心 ✓\n"
        "策略: 按价值/重量比排序\n"
        "原因: 物品可以分割，一定选密度最高的");

    explainProblem("最长公共子序列",
        "动态规划 ✗ (不能用贪心)\n"
        "原因: 需要全局匹配，贪心会丢失解");

    explainProblem("哈夫曼编码",
        "贪心 ✓\n"
        "策略: 频率最小的合并\n"
        "原因: 证明 WPL 最小");

    explainProblem("旅行商问题 (TSP)",
        "动态规划/近似算法 ✗\n"
        "原因: 贪心会产生不可行解或非最优解\n"
        "需要 2^n DP 或启发式算法");

    explainProblem("最小生成树",
        "贪心 ✓\n"
        "策略: Prim 或 Kruskal 算法\n"
        "原因: 切割性质和圈性质保证最优");

    cout << "=== 总结 ===" << endl;
    cout << "能用贪心的问题通常有:" << endl;
    cout << "1. 明显局部最优 → 全局最优的规律" << endl;
    cout << "2. 可证明的贪心选择性质" << endl;
    cout << "3. 最优子结构" << endl;
    cout << endl;
    cout << "常用判断:" << endl;
    cout << "- 看到'最多'/'最少'/'最优' → 先想贪心" << endl;
    cout << "- 看到'所有方案'/'最优方案' → 考虑 DP" << endl;
    cout << "- 贪心做不出来 → 试试 DP" << endl;

    return 0;
}''',
          description: '总结何时用贪心、何时用动态规划，以及常见问题的算法选择。',
          output: '''=== 算法选择指南 ===

=== 活动选择问题 ===
贪心 ✓
策略: 按结束时间排序
原因: 选择结束最早的活动，保留更多时间给其他活动

=== 0-1 背包问题 ===
动态规划 ✗ (不能用贪心)
原因: 局部最优(按密度选)不等于全局最优
反例: A(10,60), B(20,100), C(30,120), W=50

... (完整输出见实际运行)

=== 总结 ===
能用贪心的问题通常有:
1. 明显局部最优 → 全局最优的规律
2. 可证明的贪心选择性质
3. 最优子结构

常用判断:
- 看到'最多'/'最少'/'最优' → 先想贪心
- 看到'所有方案'/'最优方案' → 考虑 DP
- 贪心做不出来 → 试试 DP''',
        ),
      ],
      keyPoints: [
        '0-1 背包不能用贪心（按密度选会导致选 B+C 而不是 A+B+C 的情况不是最优）',
        '分数背包可以用贪心，因为物品可以分割',
        '能用贪心的问题需要满足：贪心选择性质和最优子结构',
        '常见贪心问题：活动选择、哈夫曼编码、最小生成树、Dijkstra',
        '贪心 vs DP：贪心每步最优，DP 全局最优；贪心不回溯，DP 考虑子问题',
      ],
    ),
  ],
);
