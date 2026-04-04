// ignore_for_file: unnecessary_string_escapes
// Algorithm Design Strategies Course Content
import '../course_data.dart';

/// Algorithm Design Strategies Chapter
const chapterAlgorithmStrategies = CourseChapter(
  id: 'algorithms_design_strategies',
  title: '算法设计思想',
  description: '学习分治法和回溯法两大经典算法设计思想，掌握递归与迭代的技巧。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    // Divide and Conquer
    CourseLesson(
      id: 'strategy_divide_conquer',
      title: '分治法 (Divide and Conquer)',
      content: '''# 分治法 (Divide and Conquer)

分治法是算法设计中最重要也是最常用的策略之一。其核心思想是将一个复杂的问题分解为**两个或多个相同或相似的子问题**，直到子问题简单到可以直接求解，然后**合并**这些子问题的解得到原问题的解。

## 分治法三步曲

1. **分解（Divide）**：将原问题分解为若干个规模较小、相互独立、与原问题形式相同的子问题
2. **解决（Conquer）**：递归地解决所有子问题。如果子问题足够小，则直接求解
3. **合并（Combine）**：将所有子问题的解合并为原问题的解

## 经典应用

### 1. 归并排序
- **分解**：将数组从中间分成两半
- **解决**：递归排序左右两半
- **合并**：将两个有序数组合并

### 2. 快速排序
- **分解**：选择一个基准，将数组分为两部分
- **解决**：递归排序左右两部分
- **合并**：直接拼接（不需要显式合并）

### 3. 二分查找
- **分解**：将有序数组从中间分成两部分
- **解决**：在可能存在目标的那一半继续查找
- **合并**：找到即返回

### 4. 大整数乘法（Strassen 算法）
- 将大整数分成高低两部分
- 递归计算 4 个子乘积
- 用 7 次乘积（而非 8 次）组合出结果

### 5. 最近点对问题
- 将平面上的点按 x 坐标分成两半
- 递归求解左右两半的最近点对
- 合并时考虑跨越中线的点对

## 分治法的通用框架

```
function divideConquer(problem):
    if problem is small enough:
        return solveDirectly(problem)

    // 1. 分解
    subproblems = split(problem)

    // 2. 解决子问题
    solutions = []
    for sub in subproblems:
        solutions.append(divideConquer(sub))

    // 3. 合并
    return combine(solutions)
```

## 分治 vs 减治 vs 动态规划

| 特征 | 分治法 | 减治法 | 动态规划 |
|------|--------|--------|----------|
| 子问题关系 | 独立 | 依赖 | 依赖 |
| 重复计算 | 无 | 无 | 有 |
| 典型应用 | 归并排序 | 二分查找 | 最短路径 |
''',
      codeExamples: [
        CodeExample(
          title: '分治法求最大值（演示基本框架）',
          code: '''#include <iostream>
#include <vector>
#include <climits>
using namespace std;

// 分治法求数组中的最大值
int findMax(const vector<int>& arr, int left, int right) {
    // 基本情况：只有一个元素
    if (left == right) {
        return arr[left];
    }

    // 分解：从中间分开
    int mid = left + (right - left) / 2;

    // 解决：递归求左右两半的最大值
    int leftMax = findMax(arr, left, mid);
    int rightMax = findMax(arr, mid + 1, right);

    // 合并：返回较大值
    return max(leftMax, rightMax);
}

int main() {
    vector<int> arr = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5};

    int maxVal = findMax(arr, 0, arr.size() - 1);
    cout << "最大值: " << maxVal << endl;

    // 输出: 9
}''',
          description: '用分治法求数组最大值，展示分治法的基本框架。',
          output: '最大值: 9',
        ),
        CodeExample(
          title: '分治法实现归并排序',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 合并两个有序数组
void merge(vector<int>& arr, int left, int mid, int right) {
    vector<int> leftArr(arr.begin() + left, arr.begin() + mid + 1);
    vector<int> rightArr(arr.begin() + mid + 1, arr.begin() + right + 1);

    int i = 0, j = 0, k = left;
    while (i < leftArr.size() && j < rightArr.size()) {
        if (leftArr[i] <= rightArr[j]) {
            arr[k++] = leftArr[i++];
        } else {
            arr[k++] = rightArr[j++];
        }
    }

    while (i < leftArr.size()) arr[k++] = leftArr[i++];
    while (j < rightArr.size()) arr[k++] = rightArr[j++];
}

// 分治排序
void divideAndConquerSort(vector<int>& arr, int left, int right) {
    if (left >= right) return;

    // 分解：找中点
    int mid = left + (right - left) / 2;

    // 解决：递归排序左右两半
    divideAndConquerSort(arr, left, mid);
    divideAndConquerSort(arr, mid + 1, right);

    // 合并：合并两个有序数组
    merge(arr, left, mid, right);
}

int main() {
    vector<int> arr = {38, 27, 43, 3, 9, 82, 10, 5};
    divideAndConquerSort(arr, 0, arr.size() - 1);

    cout << "排序结果: ";
    for (int x : arr) cout << x << " ";
    // 输出: 3 5 9 10 27 38 43 82
}''',
          description: '归并排序是分治法的经典应用，完美诠释分解-解决-合并的过程。',
          output: '排序结果: 3 5 9 10 27 38 43 82',
        ),
        CodeExample(
          title: '分治法求幂运算（快速幂）',
          code: '''#include <iostream>
using namespace std;

// 分治法求 a 的 n 次方
// a^n = a^(n/2) * a^(n/2)  当 n 为偶数
// a^n = a^(n-1) * a        当 n 为奇数
double power(double a, long long n) {
    // 基本情况
    if (n == 0) return 1;
    if (n == 1) return a;

    // 分解：求 a^(n/2)
    double half = power(a, n / 2);

    // 合并
    if (n % 2 == 0) {
        return half * half;  // n 为偶数
    } else {
        return half * half * a;  // n 为奇数
    }
}

// 迭代版快速幂（位运算优化）
double fastPower(double a, long long n) {
    double result = 1.0;
    double base = a;
    while (n > 0) {
        if (n % 2 == 1) {
            result *= base;
        }
        base *= base;
        n /= 2;
    }
    return result;
}

int main() {
    cout << "2^10 = " << power(2, 10) << endl;
    cout << "3^5 = " << power(3, 5) << endl;
    cout << "2^30 = " << fastPower(2, 30) << endl;

    // 输出:
    // 2^10 = 1024
    // 3^5 = 243
    // 2^30 = 1073741824
}''',
          description: '分治法求幂运算，时间复杂度从 O(n) 降到 O(log n)。',
          output: '''2^10 = 1024
3^5 = 243
2^30 = 1073741824''',
        ),
      ],
      keyPoints: [
        '分治法三步：分解、解决、合并',
        '子问题必须相互独立',
        '递归是实现分治法的自然工具',
        '归并排序是分治法的经典应用',
      ],
    ),

    // Backtracking
    CourseLesson(
      id: 'strategy_backtracking',
      title: '回溯法 (Backtracking)',
      content: '''# 回溯法 (Backtracking)

回溯法是一种**搜索**算法，通过**枚举**所有可能的解来找出满足条件的解。当发现当前选择无法达到目标时，就**回退**到上一步，尝试其他选择。

## 算法思想

回溯法可以理解为"走迷宫"：
1. 从起点出发，沿着一条路往前走
2. 如果遇到死胡同（无法继续前进），就退回到上一个岔路口
3. 尝试走另一条路
4. 重复以上步骤，直到找到出口或所有路都走遍

回溯法本质上是**递归枚举**，通过剪枝避免无效搜索。

## 回溯法的通用框架

```
function backtrack(choices, state):
    if state is a valid solution:
        add state to results
        return

    for each choice in choices:
        // 做选择
        makeChoice(choice)
        state.do(choice)

        // 递归
        backtrack(remainingChoices, state)

        // 撤销选择（回溯）
        undoChoice(choice)
        state.undo(choice)
```

## 经典应用

### 1. 全排列问题
n 个元素的全排列共有 n! 种。

### 2. 子集和问题
在集合中找出和为目标值的子集。

### 3. 八皇后问题
在 8×8 的棋盘上放置 8 个皇后，使得它们互不攻击。

### 4. 数独求解
根据数独规则填入数字。

### 5. 图的着色问题
用最少的颜色为图的顶点着色，使得相邻顶点颜色不同。

## 回溯 vs 分支限界

| 特征 | 回溯法 | 分支限界 |
|------|--------|----------|
| 搜索策略 | 深度优先 | 广度优先 |
| 剪枝方式 | 约束剪枝 | 限界剪枝 |
| 适用问题 | 满足约束的解 | 最优解 |
| 典型应用 | 八皇后、全排列 | 旅行商问题 |
''',
      codeExamples: [
        CodeExample(
          title: '全排列问题',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void backtrack(vector<int>& nums, int start, vector<vector<int>>& results) {
    // 终止条件：所有位置都填满了
    if (start == nums.size()) {
        results.push_back(nums);
        return;
    }

    // 枚举所有可能的选择
    for (int i = start; i < nums.size(); i++) {
        // 做选择：把 nums[i] 放到位置 start
        swap(nums[start], nums[i]);

        // 递归：处理下一个位置
        backtrack(nums, start + 1, results);

        // 撤销选择：恢复到之前的状态
        swap(nums[start], nums[i]);
    }
}

vector<vector<int>> permute(vector<int>& nums) {
    vector<vector<int>> results;
    backtrack(nums, 0, results);
    return results;
}

int main() {
    vector<int> nums = {1, 2, 3};
    vector<vector<int>> result = permute(nums);

    cout << "全排列数量: " << result.size() << endl;
    for (const auto& perm : result) {
        cout << "[";
        for (int i = 0; i < perm.size(); i++) {
            cout << perm[i];
            if (i < perm.size() - 1) cout << ", ";
        }
        cout << "]" << endl;
    }

    // 输出 6 种排列
}''',
          description: '使用回溯法求数组的全排列。',
          output: '''全排列数量: 6
[1, 2, 3]
[1, 3, 2]
[2, 1, 3]
[2, 3, 1]
[3, 2, 1]
[3, 1, 2]''',
        ),
        CodeExample(
          title: '子集和问题',
          code: '''#include <iostream>
#include <vector>
using namespace std;

void backtrack(const vector<int>& nums, int target, int start,
               vector<int>& current, vector<vector<int>>& results) {
    // 找到满足条件的组合
    if (target == 0) {
        results.push_back(current);
        return;
    }

    // 超出目标值，剪枝
    if (target < 0) return;

    // 尝试每个可能的选择
    for (int i = start; i < nums.size(); i++) {
        // 做选择
        current.push_back(nums[i]);

        // 递归：下一个数可以是当前数或之后的数（允许重复使用用 i+1）
        backtrack(nums, target - nums[i], i + 1, current, results);

        // 撤销选择
        current.pop_back();
    }
}

vector<vector<int>> combinationSum(const vector<int>& candidates, int target) {
    vector<int> current;
    vector<vector<int>> results;
    backtrack(candidates, target, 0, current, results);
    return results;
}

int main() {
    vector<int> candidates = {2, 3, 5};
    int target = 8;

    vector<vector<int>> result = combinationSum(candidates, target);

    cout << "和为 " << target << " 的组合:" << endl;
    for (const auto& combo : result) {
        cout << "[";
        for (int i = 0; i < combo.size(); i++) {
            cout << combo[i];
            if (i < combo.size() - 1) cout << ", ";
        }
        cout << "]" << endl;
    }

    // 输出: [2, 3, 3] 和 [2, 2, 2, 2] 和 [3, 5]
}''',
          description: '使用回溯法找出所有和为目标值的组合（元素不可重复使用）。',
          output: '''和为 8 的组合:
[2, 3, 3]
[2, 2, 2, 2]
[3, 5]''',
        ),
        CodeExample(
          title: '八皇后问题',
          code: '''#include <iostream>
#include <vector>
using namespace std;

class NQueens {
private:
    vector<vector<string>> solutions;
    vector<int> queenCol;  // queenCol[i] = j 表示第 i 行皇后在第 j 列
    int n;

    bool isValid(int row, int col) {
        // 检查所有已放置的皇后
        for (int i = 0; i < row; i++) {
            int j = queenCol[i];

            // 同一列
            if (j == col) return false;

            // 同一对角线
            if (row - i == abs(col - j)) return false;
        }
        return true;
    }

    void backtrack(int row) {
        // 终止条件：成功放置 n 个皇后
        if (row == n) {
            vector<string> board;
            for (int i = 0; i < n; i++) {
                string rowStr(n, '.');
                rowStr[queenCol[i]] = 'Q';
                board.push_back(rowStr);
            }
            solutions.push_back(board);
            return;
        }

        // 尝试在当前行的每一列放置皇后
        for (int col = 0; col < n; col++) {
            if (isValid(row, col)) {
                queenCol[row] = col;      // 做选择
                backtrack(row + 1);       // 递归到下一行
                queenCol[row] = -1;        // 撤销选择
            }
        }
    }

public:
    vector<vector<string>> solveNQueens(int n_) {
        n = n_;
        queenCol.assign(n, -1);
        solutions.clear();
        backtrack(0);
        return solutions;
    }

    int getSolutionCount() const { return solutions.size(); }
};

int main() {
    NQueens solver;
    auto solutions = solver.solveNQueens(4);

    cout << "4 皇后共有 " << solutions.size() << " 种解法:" << endl << endl;

    for (int s = 0; s < solutions.size(); s++) {
        cout << "解法 " << s + 1 << ":" << endl;
        for (const string& row : solutions[s]) {
            cout << row << endl;
        }
        cout << endl;
    }

    // 4 皇后有 2 种解法
}''',
          description: '八皇后问题是回溯法的经典代表，展示如何用约束剪枝来提高效率。',
          output: '''4 皇后共有 2 种解法:

解法 1:
.Q..
...Q
Q...
..Q.

解法 2:
..Q.
Q...
...Q
.Q..
''',
        ),
      ],
      keyPoints: [
        '回溯法通过枚举和撤销选择来搜索所有可能的解',
        '需要正确实现"做选择"和"撤销选择"的对称操作',
        '剪枝可以避免无效搜索，提高效率',
        '适用于求解约束满足问题和组合优化问题',
      ],
    ),

    // Combination of Divide and Conquer + Backtracking
    CourseLesson(
      id: 'strategy_complex_examples',
      title: '综合应用：分治与回溯的结合',
      content: '''# 综合应用：分治与回溯的结合

分治法和回溯法虽然思想不同，但在实际应用中经常结合使用。

## 典型案例

### 1. 归并排序中的分治应用
我们已经知道归并排序是分治法的经典应用。

### 2. 二叉树的递归遍历
前序、中序、后序遍历都可以看作分治法：
- 分解：左子树、右子树
- 解决：递归处理左右子树
- 合并：拼接结果（后序）或直接返回（需要特殊处理）

### 3. LeetCode 经典题：括号生成
生成 n 对括号的所有有效组合。

**思路**：使用回溯法，分治思想体现在：
- 每次选择放置左括号或右括号
- 左括号数量不超过 n
- 右括号数量不超过左括号数量

### 4. LeetCode 经典题：复原 IP 地址
将字符串分割成有效的 IP 地址。

**思路**：分治 + 回溯：
- 每次取 1-3 位作为一段
- 验证每段是否在 0-255 范围内
- 递归处理剩余部分
- 收集有效结果

### 5. 分治法求最大子数组和（Kadane 算法改进版）

对于数组 [-2, 1, -3, 4, -1, 2, 1, -5, 4]：
- 分治：将数组从中间分开
- 解决：递归求左半、右半的最大子数组
- 合并：考虑跨越中线的情况

## 递归 vs 迭代的选择

| 场景 | 推荐 |
|------|------|
| 问题结构清晰、递归深度有限 | 递归 |
| 需要回溯、状态恢复 | 递归（配合回溯）|
| 递归深度可能很大（>1000）| 迭代 |
| 需要极致性能 | 迭代 |
| 问题自然符合递归结构 | 递归 |
''',
      codeExamples: [
        CodeExample(
          title: '括号生成问题',
          code: '''#include <iostream>
#include <vector>
#include <string>
using namespace std;

class GenerateParenthesis {
private:
    vector<string> results;

    // 回溯 + 分治
    void backtrack(string current, int open, int close, int n) {
        // 终止条件
        if (current.length() == 2 * n) {
            results.push_back(current);
            return;
        }

        // 分治：尝试两种选择
        // 选择 1：添加左括号（如果有剩余）
        if (open < n) {
            backtrack(current + "(", open + 1, close, n);
        }

        // 选择 2：添加右括号（如果左括号比右括号多）
        if (close < open) {
            backtrack(current + ")", open, close + 1, n);
        }
    }

public:
    vector<string> generate(int n) {
        results.clear();
        backtrack("", 0, 0, n);
        return results;
    }
};

int main() {
    GenerateParenthesis gen;
    auto result = gen.generate(3);

    cout << "n=3 时，所有有效的括号组合:" << endl;
    for (const string& s : result) {
        cout << s << endl;
    }

    // 输出:
    // ((()))
    // (()())
    // (())()
    // ()(())
    // ()()()
}''',
          description: '括号生成问题展示了分治选择与回溯搜索的结合。',
          output: '''n=3 时，所有有效的括号组合:
((()))
(()())
(())()
()(())
()()()''',
        ),
        CodeExample(
          title: '复原 IP 地址',
          code: '''#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// 判断子串是否为有效的 IP 段（0-255 且无前导零）
bool isValidSegment(const string& s) {
    if (s.empty() || s.length() > 3) return false;
    if (s.length() > 1 && s[0] == '0') return false;  // 无前导零
    int val = stoi(s);
    return val >= 0 && val <= 255;
}

void backtrack(const string& s, int start, vector<string>& segments,
               vector<string>& results) {
    // 如果已经有 4 段
    if (segments.size() == 4) {
        if (start == s.length()) {
            // 所有字符都用完，是一个有效的 IP 地址
            string ip;
            for (int i = 0; i < 4; i++) {
                ip += segments[i];
                if (i < 3) ip += ".";
            }
            results.push_back(ip);
        }
        return;
    }

    // 最多只能再取 3 个字符（IP 每段最多 3 位）
    for (int len = 1; len <= 3 && start + len <= s.length(); len++) {
        string segment = s.substr(start, len);

        // 剪枝：如果剩余字符太多，跳过
        if ((4 - segments.size() - 1) * 3 < s.length() - start - len) {
            continue;
        }

        if (isValidSegment(segment)) {
            segments.push_back(segment);
            backtrack(s, start + len, segments, results);
            segments.pop_back();  // 回溯
        }
    }
}

vector<string> restoreIpAddresses(const string& s) {
    vector<string> results;
    vector<string> segments;
    backtrack(s, 0, segments, results);
    return results;
}

int main() {
    string s = "25525511135";
    auto result = restoreIpAddresses(s);

    cout << "\"" << s << "\" 可以复原为以下 IP 地址:" << endl; // ignore: unnecessary_string_escapes
    for (const string& ip : result) {
        cout << ip << endl;
    }

    // 输出:
    // 255.255.11.135
    // 255.255.111.35
}''',
          description: '复原 IP 地址问题展示分治分段与回溯搜索的结合应用。',
          output: '''"25525511135" 可以复原为以下 IP 地址:
255.255.11.135
255.255.111.35''',
        ),
      ],
      keyPoints: [
        '分治法将问题分解为子问题，回溯法搜索所有可能的解',
        '两者结合时可以先分治分段，再回溯搜索',
        '剪枝是回溯法性能优化的关键',
        '递归深度过大时应考虑迭代改写',
      ],
    ),
  ],
);
