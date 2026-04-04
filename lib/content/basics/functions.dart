// 函数 - Functions
import '../course_data.dart';

/// 函数章节
const chapterFunctions = CourseChapter(
  id: 'basics_functions',
  title: '函数',
  description: '学习 C++ 中函数的定义、参数传递、返回值以及递归函数的原理和应用。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.basics,
  lessons: [
    CourseLesson(
      id: 'basics_functions_basics',
      title: '函数基础',
      content: '''# 函数基础

函数是组织代码的基本单元，可以提高代码的复用性和可读性。

## 函数定义

```cpp
返回类型 函数名(参数列表) {
    // 函数体
    return 结果;  // 如果返回类型不是 void
}
```

## 函数声明与定义

- **声明（Declaration）**：告诉编译器函数的存在
- **定义（Definition）**：函数的实际实现

```cpp
// 声明
int max(int a, int b);

// 定义
int max(int a, int b) {
    return (a > b) ? a : b;
}
```

## 参数传递方式

| 方式 | 说明 | 效果 |
|------|------|------|
| 值传递 | `void f(int x)` | 复制一份，修改不影响原值 |
| 引用传递 | `void f(int& x)` | 直接操作原变量 |
| 指针传递 | `void f(int* p)` | 通过指针间接修改 |
| 常量引用 | `void f(const int& x)` | 高效访问，不允许修改 |

## 返回值

- `void` 函数不返回值
- `return` 语句立即返回
- 可以返回基本类型、指针、引用
- **不能返回局部变量的引用**（悬空引用）

## 默认参数

```cpp
void greet(string name = "World") {
    cout << "Hello, " << name << endl;
}
greet();           // 使用默认值
greet("Alice");    // 使用传入值
```

**注意**：默认参数只能放在参数列表右侧。
''',
      codeExamples: [
        CodeExample(
          title: '函数定义与调用',
          code: '''#include <iostream>
using namespace std;

// 求最大值
int max(int a, int b) {
    return (a > b) ? a : b;
}

// 求最小值
int min(int a, int b) {
    return (a < b) ? a : b;
}

// 交换两个数 (值传递 - 不影响原值)
void swapValue(int x, int y) {
    int temp = x;
    x = y;
    y = temp;
}

// 交换两个数 (引用传递 - 会影响原值)
void swapRef(int& x, int& y) {
    int temp = x;
    x = y;
    y = temp;
}

// 判断闰年
bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

// 计算阶乘
long long factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main() {
    // 基本函数调用
    cout << "max(10, 20) = " << max(10, 20) << endl;
    cout << "min(10, 20) = " << min(10, 20) << endl;

    // 值传递 vs 引用传递
    int a = 5, b = 10;
    cout << "\\n值传递 swapValue:" << endl;
    cout << "交换前: a=" << a << ", b=" << b << endl;
    swapValue(a, b);
    cout << "交换后: a=" << a << ", b=" << b << endl;

    cout << "\\n引用传递 swapRef:" << endl;
    cout << "交换前: a=" << a << ", b=" << b << endl;
    swapRef(a, b);
    cout << "交换后: a=" << a << ", b=" << b << endl;

    // 闰年判断
    cout << "\\n闰年判断:" << endl;
    for (int year : {2000, 2020, 2022, 1900, 2004}) {
        cout << year << " 年: " << (isLeapYear(year) ? "闰年" : "平年") << endl;
    }

    // 阶乘
    cout << "\\n阶乘计算:" << endl;
    for (int i = 1; i <= 10; i++) {
        cout << i << "! = " << factorial(i) << endl;
    }

    return 0;
}''',
          description: '展示函数的基本定义、值传递与引用传递的区别，以及函数的实际应用。',
          output: '''max(10, 20) = 20
min(10, 20) = 10

值传递 swapValue:
交换前: a=5, b=10
交换后: a=5, b=10

引用传递 swapRef:
交换前: a=5, b=10
交换后: a=10, b=5

闰年判断:
2000 年: 闰年
2020 年: 闰年
2022 年: 平年
1900 年: 平年
2004 年: 闰年

阶乘计算:
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
6! = 720
7! = 5040
8! = 40320
9! = 362880
10! = 3628800''',
        ),
        CodeExample(
          title: '默认参数与函数重载',
          code: '''#include <iostream>
#include <string>
using namespace std;

// 默认参数示例
void greet(string name = "World", string prefix = "Hello") {
    cout << prefix << ", " << name << "!" << endl;
}

// 函数重载 - 同一函数名，不同参数
int add(int a, int b) {
    cout << "add(int, int)" << endl;
    return a + b;
}

double add(double a, double b) {
    cout << "add(double, double)" << endl;
    return a + b;
}

string add(string a, string b) {
    cout << "add(string, string)" << endl;
    return a + b;
}

// 指针参数
void doubleValue(int* ptr) {
    if (ptr) {
        *ptr *= 2;
    }
}

// 常量引用参数 (高效且安全)
void printInfo(const string& name, const int& age) {
    // name = "new";  // 错误！常量引用不能修改
    cout << name << ", 年龄 " << age << endl;
}

int main() {
    // 默认参数
    cout << "默认参数:" << endl;
    greet();                  // 使用所有默认值
    greet("Alice");           // 使用第一个参数
    greet("Bob", "Hi");        // 使用两个参数

    // 函数重载
    cout << "\\n函数重载:" << endl;
    cout << "3 + 5 = " << add(3, 5) << endl;
    cout << "2.5 + 3.7 = " << add(2.5, 3.7) << endl;
    cout << "Hello + World = " << add(string("Hello"), string("World")) << endl;

    // 指针参数
    cout << "\\n指针参数:" << endl;
    int num = 21;
    cout << "原值: " << num << endl;
    doubleValue(&num);
    cout << "翻倍后: " << num << endl;

    // 常量引用
    cout << "\\n常量引用参数:" << endl;
    printInfo("张三", 25);

    return 0;
}''',
          description: '演示默认参数、函数重载、指针参数和常量引用的使用。',
          output: '''默认参数:
Hello, World!
Hello, Alice!
Hi, Bob!

函数重载:
add(int, int)
3 + 5 = 8
add(double, double)
2.5 + 3.7 = 6.2
add(string, string)
Hello + World = HelloWorld

指针参数:
原值: 21
翻倍后: 42

常量引用参数:
张三, 年龄 25''',
        ),
      ],
      keyPoints: [
        '函数通过值传递、引用传递或指针传递来操作参数',
        '引用传递允许函数修改传入变量的值，比指针更安全',
        '函数重载允许同一函数名有不同参数类型的实现',
        '默认参数必须放在参数列表右侧，可以简化函数调用',
        '常量引用 (const T&) 既高效又安全，适合传递大型对象',
      ],
    ),

    CourseLesson(
      id: 'basics_functions_recursion',
      title: '递归函数',
      content: '''# 递归函数

递归是函数调用自身的一种编程技巧，适合解决可以分解为相似子问题的问题。

## 递归的两个要素

1. **基准情况 (Base Case)**：递归终止的条件
2. **递归情况 (Recursive Case)**：函数调用自身

## 递归 vs 迭代

| 方面 | 递归 | 迭代 |
|------|------|------|
| 代码简洁度 | 简洁 | 可能复杂 |
| 性能 | 函数调用开销 | 无额外开销 |
| 栈空间 | 占用栈空间 | 占用常量空间 |
| 适用场景 | 问题本身有递归结构 | 简单循环即可解决 |

## 尾递归优化

如果递归调用是函数的最后一条语句，编译器可能进行优化：

```cpp
// 尾递归形式
int factTail(int n, int result = 1) {
    if (n <= 1) return result;
    return factTail(n - 1, n * result);  // 最后一条是递归调用
}
```

## 递归的常见应用

- **数学计算**：阶乘、斐波那契数列、幂运算
- **搜索/遍历**：树的遍历、图的 DFS
- **分治算法**：归并排序、快速排序
- **动态规划**：最优子结构问题

## 斐波那契数列的陷阱

普通递归计算斐波那契数效率很低，存在大量重复计算：

```
fib(5) = fib(4) + fib(3)
       = (fib(3) + fib(2)) + (fib(2) + fib(1))
       = ...
```

**解决方案**：使用记忆化 (Memoization) 或改用迭代。
''',
      codeExamples: [
        CodeExample(
          title: '递归基础演示',
          code: '''#include <iostream>
using namespace std;

// 计算阶乘
int factorial(int n) {
    // 基准情况
    if (n <= 1) return 1;
    // 递归情况
    return n * factorial(n - 1);
}

// 计算幂运算 x^n
double power(double x, int n) {
    if (n == 0) return 1;
    if (n < 0) return 1.0 / power(x, -n);
    return x * power(x, n - 1);
}

// 求最大公约数 (欧几里得算法 - 递归版)
int gcd(int a, int b) {
    if (b == 0) return a;
    return gcd(b, a % b);
}

// 倒序打印数字
void printReverse(int n) {
    if (n < 10) {
        cout << n;
    } else {
        cout << n % 10;
        printReverse(n / 10);
    }
}

// 尾递归版 - 计算阶乘
int factorialTail(int n, int result = 1) {
    if (n <= 1) return result;
    return factorialTail(n - 1, n * result);
}

int main() {
    // 阶乘
    cout << "阶乘计算 (递归):" << endl;
    for (int i = 1; i <= 10; i++) {
        cout << i << "! = " << factorial(i) << endl;
    }

    // 幂运算
    cout << "\\n幂运算 (递归):" << endl;
    cout << "2^10 = " << power(2, 10) << endl;
    cout << "3^4 = " << power(3, 4) << endl;
    cout << "2^-3 = " << power(2, -3) << endl;

    // 最大公约数
    cout << "\\n最大公约数:" << endl;
    cout << "gcd(48, 18) = " << gcd(48, 18) << endl;
    cout << "gcd(100, 25) = " << gcd(100, 25) << endl;
    cout << "gcd(17, 13) = " << gcd(17, 13) << endl;

    // 倒序打印
    cout << "\\n倒序打印数字:" << endl;
    cout << "12345 倒序: ";
    printReverse(12345);
    cout << endl;

    // 尾递归
    cout << "\\n尾递归阶乘:" << endl;
    cout << "5! (尾递归) = " << factorialTail(5) << endl;

    return 0;
}''',
          description: '展示递归的基本应用：阶乘、幂运算、最大公约数和倒序打印。',
          output: '''阶乘计算 (递归):
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
6! = 720
7! = 5040
8! = 40320
9! = 362880
10! = 3628800

幂运算 (递归):
2^10 = 1024
3^4 = 81
2^-3 = 0.125

最大公约数:
gcd(48, 18) = 6
gcd(100, 25) = 25
gcd(17, 13) = 1

倒序打印数字:
12345 倒序: 54321

尾递归阶乘:
5! (尾递归) = 120''',
        ),
        CodeExample(
          title: '斐波那契数列与记忆化',
          code: '''#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

// 普通递归 - 效率低，存在大量重复计算
long long fibNaive(int n) {
    if (n <= 1) return n;
    return fibNaive(n - 1) + fibNaive(n - 2);
}

// 记忆化递归 - 用数组缓存结果
unordered_map<int, long long> fibMemoCache;
long long fibMemo(int n) {
    if (n <= 1) return n;
    if (fibMemoCache.find(n) != fibMemoCache.end()) {
        return fibMemoCache[n];  // 命中缓存
    }
    long long result = fibMemo(n - 1) + fibMemo(n - 2);
    fibMemoCache[n] = result;    // 存入缓存
    return result;
}

// 迭代版本 - 最高效
long long fibIterative(int n) {
    if (n <= 1) return n;
    long long prev = 0, curr = 1;
    for (int i = 2; i <= n; i++) {
        long long next = prev + curr;
        prev = curr;
        curr = next;
    }
    return curr;
}

int main() {
    cout << "斐波那契数列比较:" << endl;
    cout << "n\\t\\t迭代\\t\\t记忆化\\t\\t普通递归" << endl;

    for (int n : {5, 10, 20, 30, 40}) {
        cout << n << "\\t\\t" << fibIterative(n)
             << "\\t\\t" << fibMemo(n)
             << "\\t\\t" << fibNaive(n) << endl;
    }

    cout << "\\n各算法复杂度:" << endl;
    cout << "普通递归: O(2^n) - 指数级，大量重复计算" << endl;
    cout << "记忆化递归: O(n) - 线性时间" << endl;
    cout << "迭代版本: O(n) - 线性时间，最优" << endl;

    cout << "\\n斐波那契数列前 15 项:" << endl;
    for (int i = 0; i <= 14; i++) {
        cout << fibIterative(i) << " ";
    }
    cout << endl;

    return 0;
}''',
          description: '对比普通递归、记忆化递归和迭代三种方式计算斐波那契数列的效率。',
          output: '''斐波那契数列比较:
n		迭代		记忆化		普通递归
5		5		5		5
10		55		55		55
20		6765		6765		6765
30		832040		832040		832040
40		102334155		102334155		102334155

各算法复杂度:
普通递归: O(2^n) - 指数级，大量重复计算
记忆化递归: O(n) - 线性时间
迭代版本: O(n) - 线性时间，最优

斐波那契数列前 15 项:
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377''',
        ),
      ],
      keyPoints: [
        '递归必须包含基准情况和递归情况，否则会导致无限递归',
        '递归适合问题本身具有递归结构（如树、分形）的场景',
        '普通递归计算斐波那契数是指数级复杂度，应使用记忆化或迭代',
        '尾递归可能被编译器优化，减少栈空间使用',
        '能用迭代解决的问题尽量用迭代，避免递归带来的函数调用开销',
      ],
    ),
  ],
);
