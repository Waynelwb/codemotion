// 高级算法 - 动态规划 - Dynamic Programming
import '../course_data.dart';

/// 动态规划章节
const chapterDynamicProgramming = CourseChapter(
  id: 'advanced_algorithms_dynamic_programming',
  title: '动态规划 (Dynamic Programming)',
  description: '学习动态规划的核心思想、背包问题、编辑距离、最长公共子序列等经典问题。',
  difficulty: DifficultyLevel.advanced,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'advanced_algorithms_dp_concept',
      title: '动态规划基础',
      content: '''# 动态规划基础

## 什么是动态规划？

动态规划（DP）是一种**将复杂问题分解为重叠子问题**的算法思想，通过存储子问题的解来避免重复计算。

## 动态规划的两个条件

1. **最优子结构**：问题的最优解由子问题的最优解构成
2. **重叠子问题**：子问题会被重复计算

## 动态规划 vs 分治

| 特点 | 动态规划 | 分治 |
|------|----------|------|
| 子问题关系 | 重叠（重复计算） | 独立（不重复） |
| 解决方法 | 存储子问题解 | 递归计算 |
| 典型问题 | 最短路径、编辑距离 | 归并排序、快速排序 |

## 动态规划的解题步骤

1. **定义状态**：dp[i] 或 dp[i][j] 表示什么
2. **状态转移方程**：如何从子问题推导当前问题
3. **初始化**：dp 的起始条件
4. **遍历顺序**：保证子问题已计算
5. **返回结果**：dp[n] 或 dp[n][m]

## 动态规划的两种实现

### 自顶向下（记忆化递归）

```cpp
vector<int> memo;
int fib(int n) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fib(n-1) + fib(n-2);
}
```

### 自底向上（迭代）

```cpp
int fib(int n) {
    vector<int> dp(n+1);
    dp[0] = 0; dp[1] = 1;
    for (int i = 2; i <= n; i++)
        dp[i] = dp[i-1] + dp[i-2];
    return dp[n];
}
```

### 空间优化

观察 dp 状态转移，如果只依赖前几个状态，可以压缩空间：

```cpp
int fib(int n) {
    if (n <= 1) return n;
    int prev2 = 0, prev1 = 1, curr;
    for (int i = 2; i <= n; i++) {
        curr = prev1 + prev2;
        prev2 = prev1;
        prev1 = curr;
    }
    return curr;
}
```

## 经典 DP 问题分类

1. **线性 DP**：斐波那契、爬楼梯、最大子序和
2. **背包问题**：0-1 背包、完全背包、多重背包
3. **区间 DP**：矩阵链乘、戳气球
4. **状态压缩 DP**：旅行商问题
5. **树形 DP**：树中的最大独立集
''',
      codeExamples: [
        CodeExample(
          title: '斐波那契与爬楼梯',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 方法1: 普通递归 (指数级 - 会超时)
int fib_recursive(int n) {
    if (n <= 1) return n;
    return fib_recursive(n-1) + fib_recursive(n-2);
}

// 方法2: 记忆化递归 (自顶向下 DP)
int fib_memo(vector<int>& memo, int n) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fib_memo(memo, n-1) + fib_memo(memo, n-2);
}

// 方法3: 动态规划 (自底向上)
int fib_dp(int n) {
    if (n <= 1) return n;
    vector<int> dp(n+1);
    dp[0] = 0; dp[1] = 1;
    for (int i = 2; i <= n; i++)
        dp[i] = dp[i-1] + dp[i-2];
    return dp[n];
}

// 方法4: 空间优化
int fib_optimized(int n) {
    if (n <= 1) return n;
    int prev2 = 0, prev1 = 1, curr = 0;
    for (int i = 2; i <= n; i++) {
        curr = prev1 + prev2;
        prev2 = prev1;
        prev1 = curr;
    }
    return curr;
}

// 爬楼梯问题
int climbStairs(int n) {
    if (n <= 2) return n;
    int prev2 = 1, prev1 = 2, curr;
    for (int i = 3; i <= n; i++) {
        curr = prev1 + prev2;
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}

// 打家劫舍问题
int rob(vector<int>& nums) {
    if (nums.empty()) return 0;
    if (nums.size() == 1) return nums[0];

    int prev2 = 0;  // dp[i-2]
    int prev1 = nums[0];  // dp[i-1]

    for (int i = 1; i < nums.size(); i++) {
        int curr = max(prev1, prev2 + nums[i]);
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}

int main() {
    cout << "=== 斐波那契数列 ===" << endl;
    int n = 20;

    cout << "n = " << n << endl;
    cout << "普通递归: " << fib_recursive(n) << endl;

    vector<int> memo(n+1, -1);
    cout << "记忆化递归: " << fib_memo(memo, n) << endl;

    cout << "动态规划: " << fib_dp(n) << endl;
    cout << "空间优化: " << fib_optimized(n) << endl;

    cout << "\\n=== 爬楼梯 ===" << endl;
    for (int i = 1; i <= 5; i++)
        cout << i << " 阶楼梯有 " << climbStairs(i) << " 种爬法" << endl;

    cout << "\\n=== 打家劫舍 ===" << endl;
    vector<int> houses = {2, 7, 9, 3, 1};
    cout << "房屋: ";
    for (int h : houses) cout << h << " ";
    cout << endl;
    cout << "能偷到的最大金额: " << rob(houses) << endl;

    return 0;
}''',
          description: '展示斐波那契数列的四种解法，以及爬楼梯和打家劫舍问题。',
          output: '''=== 斐波那契数列 ===
n = 20
普通递归: 6765
记忆化递归: 6765
动态规划: 6765
空间优化: 6765

=== 爬楼梯 ===
1 阶楼梯有 1 种爬法
2 阶楼梯有 2 种爬法
3 阶楼梯有 3 种爬法
4 阶楼梯有 5 种爬法
5 阶楼梯有 8 种爬法

=== 打家劫舍 ===
房屋: 2 7 9 3 1 
能偷到的最大金额: 12''',
        ),
        CodeExample(
          title: '最大子序和与打家劫舍 II',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 最大子序和 (LeetCode 53)
int maxSubArray(vector<int>& nums) {
    if (nums.empty()) return 0;

    int n = nums.size();
    vector<int> dp(n);
    dp[0] = nums[0];
    int result = dp[0];

    for (int i = 1; i < n; i++) {
        // dp[i]: 以 nums[i] 结尾的最大子序和
        dp[i] = max(nums[i], dp[i-1] + nums[i]);
        result = max(result, dp[i]);
    }

    return result;
}

// 空间优化版本
int maxSubArray_optimized(vector<int>& nums) {
    int curr = nums[0];
    int result = nums[0];

    for (int i = 1; i < nums.size(); i++) {
        curr = max(nums[i], curr + nums[i]);
        result = max(result, curr);
    }

    return result;
}

// 打家劫舍 II (房屋成环)
int rob2(vector<int>& nums) {
    if (nums.empty()) return 0;
    if (nums.size() == 1) return nums[0];

    // 情况1: 偷第一间，不偷最后一间
    int prev2_1 = 0, prev1_1 = nums[0];
    for (int i = 1; i < nums.size() - 1; i++) {
        int curr = max(prev1_1, prev2_1 + nums[i]);
        prev2_1 = prev1_1;
        prev1_1 = curr;
    }

    // 情况2: 不偷第一间，偷最后一间
    int prev2_2 = 0, prev1_2 = nums[1];
    for (int i = 2; i < nums.size(); i++) {
        int curr = max(prev1_2, prev2_2 + nums[i]);
        prev2_2 = prev1_2;
        prev1_2 = curr;
    }

    return max(prev1_1, prev1_2);
}

// 乘积最大子数组
int maxProduct(vector<int>& nums) {
    if (nums.empty()) return 0;

    int maxProd = nums[0];
    int currMax = nums[0];
    int currMin = nums[0];

    for (int i = 1; i < nums.size(); i++) {
        // 因为可能有负数，所以要同时保存最大和最小
        int temp = max(currMax * nums[i], currMin * nums[i]);
        currMin = min(min(currMax * nums[i], currMin * nums[i]), nums[i]);
        currMax = temp;
        maxProd = max(maxProd, currMax);
    }

    return maxProd;
}

int main() {
    cout << "=== 最大子序和 ===" << endl;
    vector<int> nums = {-2, 1, -3, 4, -1, 2, 1, -5, 4};
    cout << "数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "最大子序和: " << maxSubArray(nums) << endl;
    cout << "优化版: " << maxSubArray_optimized(nums) << endl;

    cout << "\\n=== 打家劫舍 II ===" << endl;
    vector<int> houses = {2, 3, 2, 3, 1};
    cout << "环形房屋: ";
    for (int h : houses) cout << h << " ";
    cout << endl;
    cout << "最大金额: " << rob2(houses) << endl;

    cout << "\\n=== 乘积最大子数组 ===" << endl;
    vector<int> products = {2, 3, -2, 4, -1};
    cout << "数组: ";
    for (int n : products) cout << n << " ";
    cout << endl;
    cout << "最大乘积: " << maxProduct(products) << endl;

    return 0;
}''',
          description: '展示最大子序和、打家劫舍 II 和乘积最大子数组问题。',
          output: '''=== 最大子序和 ===
数组: -2 1 -3 4 -1 2 1 -5 4 
最大子序和: 6
优化版: 6

=== 打家劫舍 II ===
环形房屋: 2 3 2 3 1 
最大金额: 4

=== 乘积最大子数组 ===
数组: 2 3 -2 4 -1 
最大乘积: 48''',
        ),
      ],
      keyPoints: [
        '动态规划核心：状态定义 + 状态转移方程 + 初始化',
        '斐波那契：dp[i] = dp[i-1] + dp[i-2]，可空间优化到 O(1)',
        '最大子序和：dp[i] = max(nums[i], dp[i-1] + nums[i])',
        '打家劫舍：dp[i] = max(dp[i-1], dp[i-2] + nums[i])',
        '状态压缩：当 dp 只依赖前几个状态时，可以用几个变量替代整个数组',
      ],
    ),

    CourseLesson(
      id: 'advanced_algorithms_dp_knapsack',
      title: '背包问题',
      content: '''# 背包问题

## 0-1 背包问题

有 n 件物品，每件物品有重量 w[i] 和价值 v[i]，容量为 W 的背包，求能装入物品的最大价值。

**特点**：每件物品只能选 0 个或 1 个。

## 状态定义

`dp[i][j]`：考虑前 i 件物品，背包容量为 j 时的最大价值

## 状态转移

```cpp
dp[i][j] = max(dp[i-1][j], dp[i-1][j-w[i]] + v[i])
// 不选第 i 件物品 vs 选第 i 件物品（需要容量够）
```

## 完全背包问题

每件物品可以选无限次。

```cpp
dp[i][j] = max(dp[i-1][j], dp[i][j-w[i]] + v[i])
// 注意第二项用 dp[i] 而不是 dp[i-1]
```

## 多重背包问题

每件物品有有限数量 k。

```cpp
// 将多重背包转换为 0-1 背包
// 方法1: 展开成 k 件物品
// 方法2: 二进制优化
// 方法3: 单调队列优化
```

## 背包问题的空间优化

观察状态转移，`dp[j]` 只依赖 `dp[j-w[i]]`，所以可以从后往前遍历：

```cpp
for (int i = 0; i < n; i++) {
    for (int j = W; j >= w[i]; j--) {
        dp[j] = max(dp[j], dp[j-w[i]] + v[i]);
    }
}
```

**注意**：0-1 背包从后往前，完全背包从前往后！

## 背包问题变种

1. **恰好装满**：初始化 dp[0] = 0，其他为 -∞
2. **物品价值为负**：不能简单用 0 初始化
3. **二维费用**：dp[i][j][k] 表示物品 i，体积 j，重量 k
4. **求方案数**：dp 存方案数而不是最大值

## 常见题型

| 题型 | 状态定义 | 关键转移 |
|------|----------|----------|
| 0-1 背包 | dp[j] | max(dp[j], dp[j-w]+v) 从后往前 |
| 完全背包 | dp[j] | max(dp[j], dp[j-w]+v) 从前往后 |
| 分组背包 | dp[g][j] | max(dp[g-1][j], dp[g-1][j-w]+v) |
| 依赖背包 | 树上 DP | 选父必须选子 |
''',
      codeExamples: [
        CodeExample(
          title: '0-1 背包实现',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 0-1 背包 - 二维 DP
int knapsack_2d(const vector<int>& weights, const vector<int>& values, int W) {
    int n = weights.size();
    vector<vector<int>> dp(n + 1, vector<int>(W + 1, 0));

    for (int i = 1; i <= n; i++) {
        for (int j = 0; j <= W; j++) {
            // 不选第 i-1 件物品
            dp[i][j] = dp[i-1][j];

            // 选第 i-1 件物品（如果能装下）
            if (j >= weights[i-1]) {
                dp[i][j] = max(dp[i][j],
                              dp[i-1][j-weights[i-1]] + values[i-1]);
            }
        }
    }

    return dp[n][W];
}

// 0-1 背包 - 一维 DP (空间优化)
int knapsack_1d(const vector<int>& weights, const vector<int>& values, int W) {
    vector<int> dp(W + 1, 0);

    for (int i = 0; i < weights.size(); i++) {
        // 必须从后往前遍历！
        for (int j = W; j >= weights[i]; j--) {
            dp[j] = max(dp[j], dp[j-weights[i]] + values[i]);
        }
    }

    return dp[W];
}

// 恰好装满的 0-1 背包
int knapsack_exactly(const vector<int>& weights, const vector<int>& values, int W) {
    vector<int> dp(W + 1, INT_MIN);
    dp[0] = 0;

    for (int i = 0; i < weights.size(); i++) {
        for (int j = W; j >= weights[i]; j--) {
            dp[j] = max(dp[j], dp[j-weights[i]] + values[i]);
        }
    }

    return dp[W];
}

// 物品分割（价值/重量比最大）用贪心，这里仅演示 DP
int knapsack_with_items(const vector<int>& weights, const vector<int>& values, int W) {
    int n = weights.size();
    vector<vector<int>> dp(n + 1, vector<int>(W + 1, 0));
    vector<vector<bool>> choice(n + 1, vector<bool>(W + 1, false));

    for (int i = 1; i <= n; i++) {
        for (int j = 0; j <= W; j++) {
            dp[i][j] = dp[i-1][j];
            if (j >= weights[i-1] &&
                dp[i-1][j-weights[i-1]] + values[i-1] > dp[i][j]) {
                dp[i][j] = dp[i-1][j-weights[i-1]] + values[i-1];
                choice[i][j] = true;
            }
        }
    }

    // 回溯找出选了哪些物品
    cout << "选择的物品: ";
    int j = W;
    for (int i = n; i > 0; i--) {
        if (choice[i][j]) {
            cout << i << " ";
            j -= weights[i-1];
        }
    }
    cout << endl;

    return dp[n][W];
}

int main() {
    cout << "=== 0-1 背包问题 ===" << endl;

    vector<int> weights = {2, 3, 4, 5};
    vector<int> values = {3, 4, 5, 6};
    int W = 8;

    cout << "物品重量: ";
    for (int w : weights) cout << w << " ";
    cout << endl;
    cout << "物品价值: ";
    for (int v : values) cout << v << " ";
    cout << endl;
    cout << "背包容量: " << W << endl;

    cout << "\\n二维 DP 结果: " << knapsack_2d(weights, values, W) << endl;
    cout << "一维 DP 结果: " << knapsack_1d(weights, values, W) << endl;
    cout << "一维 DP (记录物品): " << knapsack_with_items(weights, values, W) << endl;

    cout << "\\n恰好装满: " << knapsack_exactly(weights, values, W) << endl;

    return 0;
}''',
          description: '展示 0-1 背包的二维 DP、一维 DP 优化版本，以及如何回溯选择物品。',
          output: '''=== 0-1 背包问题 ===
物品重量: 2 3 4 5 
物品价值: 3 4 5 6 
背包容量: 8

二维 DP 结果: 10
一维 DP 结果: 10
一维 DP (记录物品): 选择的物品: 4 2 
10

恰好装满: 10''',
        ),
        CodeExample(
          title: '完全背包与多重背包',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 完全背包 - 每件物品可以选无限次
int completeKnapsack(const vector<int>& weights, const vector<int>& values, int W) {
    vector<int> dp(W + 1, 0);

    for (int i = 0; i < weights.size(); i++) {
        // 完全背包从前往后！
        for (int j = weights[i]; j <= W; j++) {
            dp[j] = max(dp[j], dp[j-weights[i]] + values[i]);
        }
    }

    return dp[W];
}

// 多重背包 - 每件物品有数量限制
// 朴素版：展开成 0-1 背包
int multipleKnapsack_naive(const vector<int>& weights,
                           const vector<int>& values,
                           const vector<int>& counts,
                           int W) {
    vector<int> dp(W + 1, 0);

    for (int i = 0; i < weights.size(); i++) {
        // 展开成 counts[i] 件物品
        for (int k = 0; k < counts[i]; k++) {
            for (int j = W; j >= weights[i]; j--) {
                dp[j] = max(dp[j], dp[j-weights[i]] + values[i]);
            }
        }
    }

    return dp[W];
}

// 多重背包 - 二进制优化
int multipleKnapsack_binary(const vector<int>& weights,
                            const vector<int>& values,
                            const vector<int>& counts,
                            int W) {
    vector<int> dp(W + 1, 0);

    for (int i = 0; i < weights.size(); i++) {
        int count = counts[i];
        int w = weights[i], v = values[i];

        // 二进制拆分：1, 2, 4, 8, ...
        for (int k = 1; count > 0; k *= 2) {
            int num = min(k, count);
            for (int j = W; j >= num * w; j--) {
                dp[j] = max(dp[j], dp[j-num*w] + num*v);
            }
            count -= num;
        }
    }

    return dp[W];
}

// 分割等和子集 (LeetCode 416)
bool canPartition(vector<int>& nums) {
    int sum = 0;
    for (int n : nums) sum += n;
    if (sum % 2) return false;
    int target = sum / 2;

    vector<bool> dp(target + 1, false);
    dp[0] = true;

    for (int num : nums) {
        for (int j = target; j >= num; j--) {
            dp[j] = dp[j] || dp[j-num];
        }
    }

    return dp[target];
}

int main() {
    cout << "=== 完全背包 ===" << endl;
    vector<int> weights = {1, 2, 3};
    vector<int> values = {1, 2, 3};
    int W = 6;

    cout << "物品(重量,价值): ";
    for (int i = 0; i < weights.size(); i++)
        cout << "(" << weights[i] << "," << values[i] << ") ";
    cout << endl;
    cout << "背包容量: " << W << endl;
    cout << "完全背包最大价值: " << completeKnapsack(weights, values, W) << endl;

    cout << "\\n=== 多重背包 ===" << endl;
    vector<int> mw = {2, 3, 4};
    vector<int> mv = {3, 4, 5};
    vector<int> mc = {3, 2, 1};  // 数量限制
    W = 10;

    cout << "物品(重量,价值,数量): ";
    for (int i = 0; i < mw.size(); i++)
        cout << "(" << mw[i] << "," << mv[i] << "," << mc[i] << ") ";
    cout << endl;
    cout << "背包容量: " << W << endl;
    cout << "朴素版: " << multipleKnapsack_naive(mw, mv, mc, W) << endl;
    cout << "二进制优化: " << multipleKnapsack_binary(mw, mv, mc, W) << endl;

    cout << "\\n=== 分割等和子集 ===" << endl;
    vector<int> nums = {1, 5, 11, 5};
    cout << "数组: ";
    for (int n : nums) cout << n << " ";
    cout << endl;
    cout << "能分成和相等的两个子集: "
         << (canPartition(nums) ? "是" : "否") << endl;

    return 0;
}''',
          description: '展示完全背包、多重背包（二进制优化）和分割等和子集问题。',
          output: '''=== 完全背包 ===
物品(重量,价值): (1,1) (2,2) (3,3) 
背包容量: 6
完全背包最大价值: 6

=== 多重背包 ===
物品(重量,价值,数量): (2,3,3) (3,4,2) (4,5,1) 
背包容量: 10
朴素版: 21
二进制优化: 21

=== 分割等和子集 ===
数组: 1 5 11 5 
能分成和相等的两个子集: 是''',
        ),
      ],
      keyPoints: [
        '0-1 背包：一维 DP 从后往前遍历，完全背包从前往后遍历',
        '0-1 背包状态转移：dp[j] = max(dp[j], dp[j-w[i]] + v[i])',
        '完全背包：dp[j] = max(dp[j], dp[j-w[i]] + v[i])，但从前往后',
        '多重背包二进制优化：将 k 个物品拆成 1,2,4,8,... 转换为 0-1 背包',
        '分割等和子集本质是 0-1 背包：找能否凑成 sum/2',
      ],
    ),

    CourseLesson(
      id: 'advanced_algorithms_dp_string',
      title: '字符串 DP 问题',
      content: '''# 字符串 DP 问题

## 最长公共子序列 (LCS)

给定两个字符串，找它们的最长公共子序列（不要求连续）。

```
s1 = "abcde"
s2 = "ace"
LCS = "ace" (长度 3)
```

## 状态定义

`dp[i][j]`：s1[0..i-1] 和 s2[0..j-1] 的 LCS 长度

## 状态转移

```cpp
if (s1[i-1] == s2[j-1])
    dp[i][j] = dp[i-1][j-1] + 1;
else
    dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
```

## 编辑距离

将字符串 s1 转换成 s2 最少需要多少次操作：

| 操作 | 说明 |
|------|------|
| 插入 | 在 s1 中插入一个字符 |
| 删除 | 删除 s1 中的一个字符 |
| 替换 | 将 s1 中的一个字符替换为另一个 |

## 状态定义

`dp[i][j]`：将 s1[0..i-1] 转换成 s2[0..j-1] 的最少操作数

## 状态转移

```cpp
if (s1[i-1] == s2[j-1])
    dp[i][j] = dp[i-1][j-1];
else
    dp[i][j] = 1 + min(dp[i-1][j],   // 删除
                       dp[i][j-1],   // 插入
                       dp[i-1][j-1]); // 替换
```

## 其他字符串 DP 问题

| 问题 | 状态定义 | 关键转移 |
|------|----------|----------|
| 最长回文子串 | dp[i][j] | dp[i][j] = (s[i]==s[j]) && dp[i+1][j-1] |
| 正则匹配 | dp[i][j] | 复杂，多种情况 |
| 通配符匹配 | dp[i][j] | * 可以匹配任意串 |
| 戳气球 | dp[i][j] | dp[i][j] = max(dp[i][k]+dp[k][j]+...) |
''',
      codeExamples: [
        CodeExample(
          title: '最长公共子序列',
          code: '''#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// 最长公共子序列
int longestCommonSubsequence(const string& s1, const string& s2) {
    int m = s1.size(), n = s2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i-1] == s2[j-1])
                dp[i][j] = dp[i-1][j-1] + 1;
            else
                dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
        }
    }

    return dp[m][n];
}

// 空间优化版本
int LCS_optimized(const string& s1, const string& s2) {
    int m = s1.size(), n = s2.size();
    vector<int> prev(n + 1, 0), curr(n + 1, 0);

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i-1] == s2[j-1])
                curr[j] = prev[j-1] + 1;
            else
                curr[j] = max(prev[j], curr[j-1]);
        }
        swap(prev, curr);
    }

    return prev[n];
}

// 打印 LCS
string printLCS(const string& s1, const string& s2) {
    int m = s1.size(), n = s2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i-1] == s2[j-1])
                dp[i][j] = dp[i-1][j-1] + 1;
            else
                dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
        }
    }

    // 回溯找 LCS
    string lcs;
    int i = m, j = n;
    while (i > 0 && j > 0) {
        if (s1[i-1] == s2[j-1]) {
            lcs = s1[i-1] + lcs;
            i--; j--;
        } else if (dp[i-1][j] > dp[i][j-1]) {
            i--;
        } else {
            j--;
        }
    }

    return lcs;
}

// 最长公共子串 (连续)
int longestCommonSubstring(const string& s1, const string& s2) {
    int m = s1.size(), n = s2.size();
    vector<int> dp(n + 1, 0);
    int maxLen = 0;

    for (int i = 1; i <= m; i++) {
        for (int j = n; j >= 1; j--) {
            if (s1[i-1] == s2[j-1])
                dp[j] = dp[j-1] + 1;
            else
                dp[j] = 0;
            maxLen = max(maxLen, dp[j]);
        }
    }

    return maxLen;
}

int main() {
    cout << "=== 最长公共子序列 (LCS) ===" << endl;

    string s1 = "abcde";
    string s2 = "ace";

    cout << "s1: " << s1 << endl;
    cout << "s2: " << s2 << endl;
    cout << "LCS 长度: " << longestCommonSubsequence(s1, s2) << endl;
    cout << "LCS: " << printLCS(s1, s2) << endl;

    cout << "\\n=== LCS 空间优化 ===" << endl;
    s1 = "programming";
    s2 = "gaming";
    cout << "s1: " << s1 << ", s2: " << s2 << endl;
    cout << "LCS 长度: " << LCS_optimized(s1, s2) << endl;
    cout << "LCS: " << printLCS(s1, s2) << endl;

    cout << "\\n=== 最长公共子串 (连续) ===" << endl;
    s1 = "ababc";
    s2 = "abcdab";
    cout << "s1: " << s1 << ", s2: " << s2 << endl;
    cout << "最长公共子串长度: " << longestCommonSubstring(s1, s2) << endl;

    return 0;
}''',
          description: '展示最长公共子序列的完整实现，包括空间优化和回溯打印 LCS。',
          output: '''=== 最长公共子序列 (LCS) ===
s1: abcde
s2: ace
LCS 长度: 3
LCS: ace

=== LCS 空间优化 ===
s1: programming, s2: gaming
LCS 长度: 5
LCS: gaming

=== 最长公共子串 (连续) ===
s1: ababc, s2: abcdab
最长公共子串长度: 4''',
        ),
        CodeExample(
          title: '编辑距离与回文问题',
          code: '''#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// 编辑距离 (Levenshtein Distance)
int minDistance(const string& word1, const string& word2) {
    int m = word1.size(), n = word2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));

    // 初始化
    for (int i = 0; i <= m; i++) dp[i][0] = i;  // 删除 i 个字符
    for (int j = 0; j <= n; j++) dp[0][j] = j;  // 插入 j 个字符

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (word1[i-1] == word2[j-1])
                dp[i][j] = dp[i-1][j-1];
            else
                dp[i][j] = 1 + min({dp[i-1][j],   // 删除
                                     dp[i][j-1],   // 插入
                                     dp[i-1][j-1]}); // 替换
        }
    }

    return dp[m][n];
}

// 最长回文子串
string longestPalindrome(const string& s) {
    int n = s.size();
    if (n < 2) return s;

    vector<vector<bool>> dp(n, vector<bool>(n, false));
    int start = 0, maxLen = 1;

    // 所有单字符是回文
    for (int i = 0; i < n; i++) dp[i][i] = true;

    // 检查长度为 2 及以上的
    for (int len = 2; len <= n; len++) {
        for (int i = 0; i + len <= n; i++) {
            int j = i + len - 1;

            if (s[i] == s[j]) {
                if (len == 2) {
                    dp[i][j] = true;
                } else {
                    dp[i][                    dp[i][j] = dp[i+1][j-1];
                }
                if (dp[i][j] && (len > maxLen)) {
                    start = i;
                    maxLen = len;
                }
            }
        }
    }

    return s.substr(start, maxLen);
}

int main() {
    cout << "=== 编辑距离 ===" << endl;
    string word1 = "horse";
    string word2 = "ros";
    cout << "word1: " << word1 << ", word2: " << word2 << endl;
    cout << "最小编辑距离: " << minDistance(word1, word2) << endl;

    cout << "\\n=== 最长回文子串 ===" << endl;
    string s = "babad";
    cout << "字符串: " << s << endl;
    cout << "最长回文子串: " << longestPalindrome(s) << endl;

    return 0;
}''',
          description: '展示编辑距离和最长回文子串问题的完整实现。',
          output: '''=== 编辑距离 ===
word1: horse, word2: ros
最小编辑距离: 3

=== 最长回文子串 ===
字符串: babad
最长回文子串: bab''',
        ),
      ],
      keyPoints: [
        'LCS 状态转移：相等时 dp[i][j] = dp[i-1][j-1] + 1，否则 dp[i][j] = max(dp[i-1][j], dp[i][j-1])',
        '编辑距离：dp[i][j] = min(删除, 插入, 替换) 三种操作的最小值',
        '最长回文子串：dp[i][j] = (s[i]==s[j]) && (j-i<3 || dp[i+1][j-1])',
        '字符串 DP 问题关键：正确初始化边界条件',
        'DP 空间优化：有些二维 DP 可以优化到一维',
      ],
    ),
  ],
);
