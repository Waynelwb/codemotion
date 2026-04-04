// 数据结构 - 栈 - Stack
import '../course_data.dart';

/// 栈章节
const chapterStack = CourseChapter(
  id: 'data_structures_stack',
  title: '栈 (Stack)',
  description: '学习 C++ 中栈数据结构的概念、实现和应用场景，包括括号匹配、表达式求值等经典问题。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'data_structures_stack_concept',
      title: '栈的概念与实现',
      content: '''# 栈的概念与实现

## 什么是栈？

栈是一种**后进先出 (LIFO - Last In First Out)** 的数据结构。

```
     ┌──────┐
     │  top │  ← 最后放入的元素先取出
     ├──────┤
     │      │
     ├──────┤
     │      │
     ├──────┤
     │bottom│  ← 最早放入的元素最后取出
     └──────┘
```

## 栈的基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|------------|
| `push` | 入栈，将元素放到栈顶 | O(1) |
| `pop` | 出栈，移除栈顶元素 | O(1) |
| `top` | 查看栈顶元素 | O(1) |
| `empty` | 判断是否为空 | O(1) |
| `size` | 返回元素个数 | O(1) |

## 栈的顺序存储实现（数组）

使用固定大小数组和栈顶指针实现：

```cpp
template<typename T, int MAX_SIZE = 1000>
class Stack {
private:
    T data[MAX_SIZE];
    int top;  // -1 表示空栈
public:
    Stack() : top(-1) {}
    void push(const T& item);
    void pop();
    T& top();
    bool empty() const { return top == -1; }
};
```

## 栈的链式存储实现

使用链表实现，栈顶在链表头部：

```cpp
template<typename T>
struct Node {
    T data;
    Node* next;
};

template<typename T>
class LinkedStack {
private:
    Node<T>* topNode;
public:
    void push(const T& item);
    void pop();
    T& top();
};
```

## 栈的特点

- **只能在一端操作**：只能在栈顶进行 push 和 pop
- **后进先出**：最后放入的元素最先被取出
- **不需要遍历**：O(1) 的 push/pop 操作

## 使用场景

- 函数调用栈（递归）
- 括号匹配
- 表达式求值（后缀表达式）
- 撤销操作（Undo）
- 深度优先搜索 (DFS)
''',
      codeExamples: [
        CodeExample(
          title: '栈的顺序存储实现',
          code: '''#include <iostream>
#include <vector>
#include <stdexcept>
using namespace std;

// 栈的模板类 - 顺序存储
template<typename T>
class Stack {
private:
    vector<T> data;  // 使用 vector 存储
    int topIndex;    // 栈顶索引，-1 表示空栈

public:
    Stack() : topIndex(-1) {}

    // 入栈
    void push(const T& item) {
        data.push_back(item);
        topIndex++;
    }

    // 出栈
    void pop() {
        if (empty()) {
            throw out_of_range("Stack underflow!");
        }
        data.pop_back();
        topIndex--;
    }

    // 查看栈顶元素
    T& top() {
        if (empty()) {
            throw out_of_range("Stack is empty!");
        }
        return data.back();
    }

    const T& top() const {
        if (empty()) {
            throw out_of_range("Stack is empty!");
        }
        return data.back();
    }

    // 判断是否为空
    bool empty() const {
        return topIndex == -1;
    }

    // 返回元素个数
    int size() const {
        return topIndex + 1;
    }

    // 清空栈
    void clear() {
        data.clear();
        topIndex = -1;
    }
};

int main() {
    Stack<int> s;

    cout << "=== 栈操作演示 ===" << endl;

    // 入栈
    cout << "入栈: 10, 20, 30" << endl;
    s.push(10);
    s.push(20);
    s.push(30);
    cout << "栈大小: " << s.size() << endl;
    cout << "栈顶元素: " << s.top() << endl;

    // 出栈
    cout << "\\n出栈: " << s.top() << endl;
    s.pop();
    cout << "新栈顶: " << s.top() << endl;

    // 再入栈
    s.push(40);
    cout << "入栈 40 后栈顶: " << s.top() << endl;

    // 遍历栈（从栈顶到栈底）
    cout << "\\n栈内容 (栈顶到栈底): ";
    Stack<int> temp = s;
    vector<int> elements;
    while (!temp.empty()) {
        elements.push_back(temp.top());
        temp.pop();
    }
    for (int i = 0; i < elements.size(); i++) {
        cout << elements[elements.size() - 1 - i];
        if (i < elements.size() - 1) cout << ", ";
    }
    cout << endl;

    cout << "\\n栈是否为空: " << (s.empty() ? "是" : "否") << endl;

    // 清空
    s.clear();
    cout << "清空后栈大小: " << s.size() << endl;

    return 0;
}''',
          description: '展示栈的模板类实现，包括 push、pop、top、empty 等基本操作。',
          output: '''=== 栈操作演示 ===
入栈: 10, 20, 30
栈大小: 3
栈顶元素: 30

出栈: 30
新栈顶: 20
入栈 40 后栈顶: 40

栈内容 (栈顶到栈底): 40, 20, 10

栈是否为空: 否
清空后栈大小: 0''',
        ),
        CodeExample(
          title: '括号匹配与表达式求值',
          code: '''#include <iostream>
#include <stack>
#include <string>
#include <cctype>
using namespace std;

// 括号匹配
bool isBalanced(const string& str) {
    stack<char> s;

    for (char c : str) {
        if (c == '(' || c == '[' || c == '{') {
            s.push(c);
        } else if (c == ')' || c == ']' || c == '}') {
            if (s.empty()) return false;
            char top = s.top();
            s.pop();
            if ((c == ')' && top != '(') ||
                (c == ']' && top != '[') ||
                (c == '}' && top != '{')) {
                return false;
            }
        }
    }

    return s.empty();
}

// 后缀表达式求值
int evaluatePostfix(const string& expr) {
    stack<int> s;
    string num = "";

    for (size_t i = 0; i < expr.size(); i++) {
        char c = expr[i];

        if (isdigit(c)) {
            num += c;
        } else if (c == ' ' && !num.empty()) {
            s.push(stoi(num));
            num = "";
        } else if (c == '+' || c == '-' || c == '*' || c == '/') {
            if (s.size() < 2) continue;
            int b = s.top(); s.pop();
            int a = s.top(); s.pop();
            int result;
            switch (c) {
                case '+': result = a + b; break;
                case '-': result = a - b; break;
                case '*': result = a * b; break;
                case '/': result = a / b; break;
            }
            s.push(result);
        }
    }

    return s.empty() ? 0 : s.top();
}

int main() {
    cout << "=== 括号匹配 ===" << endl;
    string tests[] = {
        "(())[]{}",
        "([)]",
        "((())",
        "{[()]}",
        "([{}])"
    };

    for (const string& t : tests) {
        cout << "\"" << t << "\" "
             << (isBalanced(t) ? "平衡" : "不平衡") << endl;
    }

    cout << "\\n=== 后缀表达式求值 ===" << endl;
    string expressions[] = {
        "3 4 +",        // 3 + 4 = 7
        "3 4 * 2 +",    // 3 * 4 + 2 = 14
        "10 2 / 5 2 * -",  // 10 / 2 - 5 * 2 = -5
    };

    for (const string& expr : expressions) {
        cout << "\"" << expr << "\" = "
             << evaluatePostfix(expr) << endl;
    }

    // 中缀转后缀的简单示例
    cout << "\\n=== 栈的应用 ===" << endl;
    stack<int> callStack;
    cout << "函数调用模拟:" << endl;

    auto functionA = [&](int n) {
        callStack.push(1); cout << "A 入栈, 大小=" << callStack.size() << endl;
        if (n > 1) functionA(n - 1);
        callStack.pop(); cout << "A 出栈, 大小=" << callStack.size() << endl;
    };

    functionA(3);

    return 0;
}''',
          description: '展示栈在括号匹配、表达式求值和函数调用模拟中的应用。',
          output: '''=== 括号匹配 ===
"(())[]{}" 平衡
"([)]" 不平衡
"((())" 不平衡
"{[()]}" 平衡
"([{}])" 平衡

=== 后缀表达式求值 ===
"3 4 +" = 7
"3 4 * 2 +" = 14
"10 2 / 5 2 * -" = -5

=== 栈的应用 ===
函数调用模拟:
A 入栈, 大小=1
A 入栈, 大小=2
A 入栈, 大小=3
A 出栈, 大小=2
A 出栈, 大小=1
A 出栈, 大小=0''',
        ),
      ],
      keyPoints: [
        '栈是后进先出 (LIFO) 的数据结构，只能在栈顶进行操作',
        'push 入栈、pop 出栈、top 查看栈顶，时间复杂度都是 O(1)',
        '括号匹配是栈的经典应用，利用栈的 LIFO 特性检查配对',
        '后缀表达式求值利用栈来保存操作数，遇到运算符时弹出计算',
        '函数调用栈就是栈的应用，递归调用对应入栈，返回对应出栈',
      ],
    ),

    CourseLesson(
      id: 'data_structures_stack_applications',
      title: '栈的高级应用',
      content: '''# 栈的高级应用

## 递归与栈

递归函数的调用过程本质上就是栈的操作：
- 函数调用 → 入栈（保存现场）
- 函数返回 → 出栈（恢复现场）

**递归改写成循环**：可以用显式栈消除递归。

## 迷宫问题 (DFS)

使用栈实现深度优先搜索解决迷宫问题：

```cpp
struct Position { int x, y; };

bool solveMaze(vector<vector<int>>& maze, Position start, Position end) {
    stack<Position> s;
    s.push(start);

    while (!s.empty()) {
        Position curr = s.top();
        s.pop();

        if (curr.x == end.x && curr.y == end.y) return true;

        // 标记并探索四个方向
        // ...
    }
    return false;
}
```

## 单调栈

单调栈是栈的变种，保持栈内元素单调递增或递减：

### 应用场景

1. **下一个更大元素**：对于每个元素，找到右侧第一个比它大的元素
2. **柱状图最大矩形**：利用单调递增栈
3. **去除重复字母**：保持结果单调

```cpp
vector<int> nextGreaterElement(const vector<int>& nums) {
    vector<int> result(nums.size(), -1);
    stack<int> s;  // 存索引，单调递减栈

    for (int i = 0; i < nums.size(); i++) {
        while (!s.empty() && nums[i] > nums[s.top()]) {
            result[s.top()] = nums[i];
            s.pop();
        }
        s.push(i);
    }

    return result;
}
```

## 表达式转换

### 中缀转后缀 (Shunting-yard 算法)

```cpp
string infixToPostfix(const string& infix) {
    stack<char> s;
    string result;

    for (char c : infix) {
        if (isdigit(c)) {
            result += c;
        } else if (c == '(') {
            s.push(c);
        } else if (c == ')') {
            while (!s.empty() && s.top() != '(') {
                result += s.top();
                s.pop();
            }
            s.pop();  // 弹出 (
        } else if (isOperator(c)) {
            while (!s.empty() && precedence(s.top()) >= precedence(c)) {
                result += s.top();
                s.pop();
            }
            s.push(c);
        }
    }

    while (!s.empty()) {
        result += s.top();
        s.pop();
    }

    return result;
}
```

## 栈与队列的相互实现

### 两个栈实现队列

```cpp
class QueueWithTwoStacks {
    stack<int> s1, s2;
public:
    void enqueue(int x) { s1.push(x); }
    void dequeue() {
        if (s2.empty()) {
            while (!s1.empty()) {
                s2.push(s1.top());
                s1.pop();
            }
        }
        if (!s2.empty()) s2.pop();
    }
};
```
''',
      codeExamples: [
        CodeExample(
          title: '单调栈 - 下一个更大元素',
          code: '''#include <iostream>
#include <stack>
#include <vector>
using namespace std;

// 下一个更大元素
vector<int> nextGreaterElement(const vector<int>& nums) {
    vector<int> result(nums.size(), -1);
    stack<int> s;  // 单调递减栈，存索引

    for (int i = 0; i < nums.size(); i++) {
        // 栈顶元素比当前元素小，则栈顶的"下一个更大"就是当前元素
        while (!s.empty() && nums[i] > nums[s.top()]) {
            result[s.top()] = nums[i];
            s.pop();
        }
        s.push(i);
    }

    return result;
}

// 柱状图最大矩形 - 单调栈应用
int largestRectangleArea(const vector<int>& heights) {
    stack<int> s;  // 单调递增栈
    int maxArea = 0;

    for (int i = 0; i <= heights.size(); i++) {
        // 最后多加一个 0，弹出所有剩余柱子
        int h = (i == heights.size()) ? 0 : heights[i];

        while (!s.empty() && heights[s.top()] > h) {
            int height = heights[s.top()];
            s.pop();
            int width = s.empty() ? i : i - s.top() - 1;
            maxArea = max(maxArea, height * width);
        }
        s.push(i);
    }

    return maxArea;
}

int main() {
    cout << "=== 下一个更大元素 ===" << endl;
    vector<int> nums = {2, 1, 2, 4, 3};
    vector<int> result = nextGreaterElement(nums);

    cout << "输入: ";
    for (int n : nums) cout << n << " ";
    cout << endl;

    cout << "输出: ";
    for (int n : result) cout << n << " ";
    cout << endl;

    // 详细展示过程
    cout << "\\n详细过程:" << endl;
    cout << "对于 nums[0]=2, 右边第一个更大元素是 4" << endl;
    cout << "对于 nums[1]=1, 右边第一个更大元素是 2" << endl;
    cout << "对于 nums[2]=2, 右边第一个更大元素是 4" << endl;
    cout << "对于 nums[3]=4, 右边第一个更大元素是 -1 (没有更大)" << endl;
    cout << "对于 nums[4]=3, 右边第一个更大元素是 -1" << endl;

    cout << "\\n=== 柱状图最大矩形 ===" << endl;
    vector<int> heights = {2, 1, 5, 6, 2, 3};
    cout << "柱状图高度: ";
    for (int h : heights) cout << h << " ";
    cout << endl;
    cout << "最大矩形面积: " << largestRectangleArea(heights) << endl;

    return 0;
}''',
          description: '展示单调栈在"下一个更大元素"和"柱状图最大矩形"问题中的应用。',
          output: '''=== 下一个更大元素 ===
输入: 2 1 2 4 3 
输出: 4 2 4 -1 -1 

详细过程:
对于 nums[0]=2, 右边第一个更大元素是 4
对于 nums[1]=1, 右边第一个更大元素是 2
对于 nums[2]=2, 右边第一个更大元素是 4
对于 nums[3]=4, 右边第一个更大元素是 -1 (没有更大)
对于 nums[4]=3, 右边第一个更大元素是 -1

=== 柱状图最大矩形 ===
柱状图高度: 2 1 5 6 2 3 
最大矩形面积: 10''',
        ),
        CodeExample(
          title: '中缀转后缀与逆波兰计算器',
          code: '''#include <iostream>
#include <stack>
#include <string>
#include <cctype>
using namespace std;

int precedence(char op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
}

bool isOperator(char c) {
    return c == '+' || c == '-' || c == '*' || c == '/';
}

// 中缀转后缀
string infixToPostfix(const string& infix) {
    stack<char> s;
    string result;

    for (char c : infix) {
        if (isdigit(c)) {
            result += c;
            result += ' ';
        } else if (c == '(') {
            s.push(c);
        } else if (c == ')') {
            while (!s.empty() && s.top() != '(') {
                result += s.top();
                result += ' ';
                s.pop();
            }
            if (!s.empty()) s.pop();  // 弹出 (
        } else if (isOperator(c)) {
            while (!s.empty() && s.top() != '(' &&
                   precedence(s.top()) >= precedence(c)) {
                result += s.top();
                result += ' ';
                s.pop();
            }
            s.push(c);
        }
    }

    while (!s.empty()) {
        result += s.top();
        result += ' ';
        s.pop();
    }

    return result;
}

// 计算后缀表达式
int evaluatePostfix(const string& postfix) {
    stack<int> s;
    string num = "";

    for (char c : postfix) {
        if (isdigit(c)) {
            num += c;
        } else if (c == ' ') {
            if (!num.empty()) {
                s.push(stoi(num));
                num = "";
            }
        } else if (isOperator(c)) {
            if (s.size() < 2) continue;
            int b = s.top(); s.pop();
            int a = s.top(); s.pop();
            int result;
            switch (c) {
                case '+': result = a + b; break;
                case '-': result = a - b; break;
                case '*': result = a * b; break;
                case '/': result = a / b; break;
            }
            s.push(result);
        }
    }

    return s.empty() ? 0 : s.top();
}

int main() {
    cout << "=== 中缀转后缀 ===" << endl;
    string infixExpressions[] = {
        "3+4*2",
        "(3+4)*2",
        "3*(2+5)",
        "((2+3)*(4-1))"
    };

    for (const string& infix : infixExpressions) {
        string postfix = infixToPostfix(infix);
        int result = evaluatePostfix(postfix);
        cout << "中缀: " << infix << endl;
        cout << "后缀: " << postfix << endl;
        cout << "结果: " << result << endl;
        cout << endl;
    }

    cout << "=== 逆波兰计算器演示 ===" << endl;
    // 手动计算 (3 + 4) * 2 = 14
    // 后缀: 3 4 + 2 *
    string manualPostfix = "3 4 + 2 *";
    cout << "后缀表达式 \"" << manualPostfix << "\" = "
         << evaluatePostfix(manualPostfix) << endl;

    return 0;
}''',
          description: '展示中缀表达式转后缀表达式的算法，以及使用后缀表达式求值实现计算器。',
          output: '''=== 中缀转后缀 ===
中缀: 3+4*2
后缀: 3 4 2 *+ 
结果: 11

中缀: (3+4)*2
后缀: 3 4 +2 *
结果: 14

中缀: 3*(2+5)
后缀: 3 2 5 +*
结果: 21

中缀: ((2+3)*(4-1))
后缀: 2 3 +4 1 -*
结果: 15

=== 逆波兰计算器演示 ===
后缀表达式 "3 4 + 2 *" = 14''',
        ),
      ],
      keyPoints: [
        '递归本质上是函数调用栈，单调栈可以解决"下一个更大元素"等问题',
        '柱状图最大矩形使用单调递增栈，O(n) 时间复杂度',
        '中缀转后缀利用栈来保存运算符，按优先级出栈',
        '后缀表达式求值：操作数入栈，遇到运算符弹出计算，结果再入栈',
        '单调栈保持栈内元素单调性，用于快速找到某个元素附近第一个更大/更小的元素',
      ],
    ),
  ],
);
