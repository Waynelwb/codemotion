// C++ 高级特性 - Lambda 表达式 - Lambda Expressions
import '../course_data.dart';

/// Lambda 表达式章节
const chapterLambda = CourseChapter(
  id: 'cpp_advanced_lambda',
  title: 'C++ Lambda 表达式',
  description: '学习 C++ Lambda 表达式的基础语法、捕获列表、与 STL 算法的结合使用。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.stl,
  lessons: [
    CourseLesson(
      id: 'cpp_lambda_basics',
      title: 'Lambda 基础',
      content: '''# Lambda 表达式基础

## 什么是 Lambda？

Lambda 表达式是 C++11 引入的一种定义匿名函数对象的方式，可以就地定义函数，常用于 STL 算法中的比较函数、过滤条件等。

```cpp
// 普通函数
bool cmp(int a, int b) { return a > b; }

// Lambda 表达式
auto cmp = [](int a, int b) { return a > b; };

sort(v.begin(), v.end(), cmp);
sort(v.begin(), v.end(), [](int a, int b) { return a > b; });
```

## Lambda 语法

```
[捕获列表] (参数列表) -> 返回类型 { 函数体 }
```

- **捕获列表 [ ]**：捕获外部变量
- **参数列表 ( )**：同普通函数
- **返回类型 ->**：可省略，编译器推导
- **函数体 { }**：函数具体实现

## 最简单的 Lambda

```cpp
[]() { }                    // 无参数，无返回值
[]() { cout << "hi"; }      // 无参数，打印 hi
[]() { return 42; }         // 返回 42

// 调用
auto f = []() { return 42; };
cout << f();  // 42
```

## 参数和返回类型

```cpp
// 完整写法
auto add = [](int a, int b) -> int { return a + b; };

// 省略返回类型（编译器推导）
auto add = [](int a, int b) { return a + b; };  // 推导为 int

// 多语句函数体必须指定返回类型
auto safeDiv = [](int a, int b) -> double {
    if (b == 0) return 0.0;
    return static_cast<double>(a) / b;
};
```

## 捕获列表详解

Lambda 可以捕获外部变量，按捕获方式分为：

| 捕获方式 | 语法 | 说明 |
|----------|------|------|
| 不捕获 | `[]` | 不能使用外部变量 |
| 值捕获 | `[x]` | 复制一份 x |
| 引用捕获 | `[&x]` | 使用 x 的引用 |
| 全部值捕获 | `[=]` | 所有外部变量按值捕获 |
| 全部引用捕获 | `[&]` | 所有外部变量按引用捕获 |
| 混合捕获 | `[=, &x]` | 默认按值，x 按引用 |

```cpp
int a = 1, b = 2;

// 值捕获
[a, b]() { return a + b; }  // OK

// 引用捕获
[&a, &b]() { a = 10; return b; }

// 全部捕获
[=]() { return a + b; }     // 值捕获
[&]() { return a + b; }      // 引用捕获
```

## mutable Lambda

按值捕获的 Lambda 默认不能修改捕获的副本：

```cpp
int count = 0;
auto counter = [count]() { count++; return count; };  // 错误！

// 使用 mutable
auto counter = [count]() mutable { count++; return count; };
```

## 返回 std::function

Lambda 可以赋值给 `std::function`：

```cpp
#include <functional>

function<int(int, int)> add = [](int a, int b) { return a + b; };
```

## Lambda 的类型

Lambda 的类型是**编译器生成的匿名仿函数类**，不同 Lambda 表达式类型不同：

```cpp
auto l1 = [](int x) { return x; };
auto l2 = [](int x) { return x; };

// l1 和 l2 类型不同！
// decltype(l1) != decltype(l2)
```

## Lambda 与 STL

Lambda 在 STL 算法中使用非常广泛：

```cpp
vector<int> v = {5, 2, 8, 1, 9};

// 排序（降序）
sort(v.begin(), v.end(), [](int a, int b) { return a > b; });

// 查找第一个偶数
auto it = find_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });

// 统计满足条件的元素个数
int cnt = count_if(v.begin(), v.end(), [](int x) { return x > 5; });
```
''',
      codeExamples: [
        CodeExample(
          title: 'Lambda 基础用法',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
using namespace std;

int main() {
    cout << "=== Lambda 基础语法 ===" << endl;

    // 最简单的 Lambda
    auto greet = []() { cout << "Hello, Lambda!" << endl; };
    greet();

    // 带参数的 Lambda
    auto add = [](int a, int b) { return a + b; };
    cout << "add(3, 5) = " << add(3, 5) << endl;

    // 省略返回类型（编译器推导）
    auto mul = [](int a, int b) { return a * b; };
    cout << "mul(4, 7) = " << mul(4, 7) << endl;

    // 显式返回类型
    auto div = [](double a, double b) -> double {
        if (b == 0) return 0;
        return a / b;
    };
    cout << "div(10, 3) = " << div(10, 3) << endl;

    cout << "\\n=== 捕获列表 ===" << endl;
    int x = 10, y = 20;

    // 值捕获
    auto byValue = [x, y]() {
        cout << "值捕获: x=" << x << ", y=" << y << endl;
    };
    byValue();

    // 引用捕获
    auto byRef = [&x, &y]() {
        x = 100;
        cout << "引用捕获: x=" << x << ", y=" << y << endl;
    };
    byRef();
    cout << "修改后 x=" << x << endl;

    // 全部捕获
    int a = 1, b = 2, c = 3;
    auto captureAllVal = [=]() {
        cout << "全部值捕获: " << a << ", " << b << ", " << c << endl;
    };
    auto captureAllRef = [&]() {
        cout << "全部引用捕获: " << a << ", " << b << ", " << c << endl;
    };
    captureAllVal();
    captureAllRef();

    // 混合捕获
    auto mixed = [=, &x]() {
        cout << "混合: x=" << x << ", a=" << a << endl;
    };
    mixed();

    cout << "\\n=== mutable Lambda ===" << endl;
    int count = 0;
    auto counter = [count]() mutable {
        count++;
        return count;
    };
    cout << "第1次: " << counter() << endl;
    cout << "第2次: " << counter() << endl;
    cout << "原始 count: " << count << endl;

    cout << "\\n=== std::function ===" << endl;
    function<int(int, int)> func = [](int a, int b) { return a + b; };
    cout << "function 调用: " << func(5, 3) << endl;

    // 存储 Lambda
    vector<function<bool(int)>> predicates;
    predicates.push_back([](int x) { return x > 0; });
    predicates.push_back([](int x) { return x % 2 == 0; });

    int val = 6;
    for (size_t i = 0; i < predicates.size(); i++) {
        cout << "predicates[" << i << "](" << val << ") = "
             << (predicates[i](val) ? "true" : "false") << endl;
    }

    return 0;
}''',
          description: '展示 Lambda 表达式的基础语法、捕获列表、mutable 和 std::function。',
          output: '''=== Lambda 基础语法 ===
Hello, Lambda!
add(3, 5) = 8
mul(4, 7) = 28
div(10, 3) = 3.33333

=== 捕获列表 ===
值捕获: x=10, y=20
引用捕获: x=100, y=20
修改后 x=100

全部值捕获: 1, 2, 3
全部引用捕获: 1, 2, 3
混合: x=100, a=1

=== mutable Lambda ===
第1次: 1
第2次: 2
原始 count: 0

=== std::function ===
function 调用: 8
predicates[0](6) = true
predicates[1](6) = true''',
        ),
        CodeExample(
          title: 'Lambda 与 STL 算法',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <map>
using namespace std;

struct Person {
    string name;
    int age;
    double salary;
};

int main() {
    cout << "=== Lambda 与 STL 算法 ===" << endl;

    // =====================
    // sort
    // =====================
    vector<int> v = {5, 2, 8, 1, 9, 3, 7, 4, 6};

    cout << "\\n--- sort ---" << endl;
    cout << "原数组: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // 升序（默认）
    sort(v.begin(), v.end());
    cout << "升序: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // 降序（Lambda）
    sort(v.begin(), v.end(), [](int a, int b) { return a > b; });
    cout << "降序: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // =====================
    // find_if / count_if
    // =====================
    cout << "\\n--- find_if ---" << endl;
    vector<int> nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    auto it = find_if(nums.begin(), nums.end(), [](int x) { return x > 5; });
    if (it != nums.end())
        cout << "第一个大于5的数: " << *it << endl;

    // 找第一个偶数
    it = find_if(nums.begin(), nums.end(), [](int x) { return x % 2 == 0; });
    if (it != nums.end())
        cout << "第一个偶数: " << *it << endl;

    // =====================
    // count_if
    // =====================
    cout << "\\n--- count_if ---" << endl;
    int cnt = count_if(nums.begin(), nums.end(), [](int x) { return x > 5; });
    cout << "大于5的元素个数: " << cnt << endl;

    cnt = count_if(nums.begin(), nums.end(), [](int x) { return x % 2 == 0; });
    cout << "偶数个数: " << cnt << endl;

    // =====================
    // remove_if / erase
    // =====================
    cout << "\\n--- remove_if ---" << endl;
    vector<int> arr = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    cout << "原数组: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    arr.erase(remove_if(arr.begin(), arr.end(), [](int x) { return x % 2 == 0; }), arr.end());
    cout << "移除偶数后: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    // =====================
    // for_each
    // =====================
    cout << "\\n--- for_each ---" << endl;
    vector<int> prices = {100, 200, 300, 400};

    cout << "原价: ";
    for_each(prices.begin(), prices.end(), [](int p) { cout << p << " "; });
    cout << endl;

    cout << "打9折: ";
    for_each(prices.begin(), prices.end(), [](int& p) { p = (int)(p * 0.9); });
    for_each(prices.begin(), prices.end(), [](int p) { cout << p << " "; });
    cout << endl;

    // =====================
    // transform
    // =====================
    cout << "\\n--- transform ---" << endl;
    vector<string> names = {"alice", "bob", "charlie"};
    vector<string> upper;

    transform(names.begin(), names.end(), back_inserter(upper),
              [](const string& s) {
                  string r = s;
                  transform(r.begin(), r.end(), r.begin(), ::toupper);
                  return r;
              });

    cout << "转大写: ";
    for (const auto& s : upper) cout << s << " ";
    cout << endl;

    // =====================
    // 自定义结构体排序
    // =====================
    cout << "\\n--- 结构体排序 ---" << endl;
    vector<Person> people = {
        {"Alice", 25, 5000},
        {"Bob", 30, 6000},
        {"Charlie", 25, 5500},
        {"Diana", 30, 7000}
    };

    cout << "按年龄升序，年龄相同按薪资降序:" << endl;
    sort(people.begin(), people.end(), [](const Person& a, const Person& b) {
        if (a.age != b.age) return a.age < b.age;
        return a.salary > b.salary;
    });

    for (const auto& p : people) {
        cout << p.name << ": age=" << p.age << ", salary=" << p.salary << endl;
    }

    // =====================
    // accumulate
    // =====================
    cout << "\\n--- accumulate ---" << endl;
    vector<int> nums2 = {1, 2, 3, 4, 5};
    int sum = accumulate(nums2.begin(), nums2.end(), 0,
                        [](int a, int b) { return a + b; });
    cout << "sum = " << sum << endl;

    int product = accumulate(nums2.begin(), nums2.end(), 1,
                            [](int a, int b) { return a * b; });
    cout << "product = " << product << endl;

    // 字符串连接
    vector<string> words = {"Hello", " ", "World", "!"};
    string result = accumulate(words.begin(), words.end(), string(""));
    cout << "字符串连接: " << result << endl;

    return 0;
}''',
          description: '展示 Lambda 在 STL 算法中的综合应用：sort、find_if、count_if、transform、accumulate 等。',
          output: '''=== Lambda 与 STL 算法 ===

--- sort ---
原数组: 5 2 8 1 9 3 7 4 6 
升序: 1 2 3 4 5 6 7 8 9 
降序: 9 8 7 6 5 4 3 2 1 

--- find_if ---
第一个大于5的数: 6
第一个偶数: 2

--- count_if ---
大于5的元素个数: 5
偶数个数: 5

--- remove_if ---
原数组: 1 2 3 4 5 6 7 8 9 10 
移除偶数后: 1 3 5 7 9 

--- for_each ---
原价: 100 200 300 400 
打9折: 90 180 270 360 

--- transform ---
转大写: ALICE BOB CHARLIE 

--- 结构体排序 ---
Alice: age=25, salary=5000
Charlie: age=25, salary=5500
Bob: age=30, salary=6000
Diana: age=30, salary=7000

--- accumulate ---
sum = 15
product = 120
字符串连接: Hello World!''',
        ),
      ],
      keyPoints: [
        'Lambda 语法：[捕获列表](参数) -> 返回类型 { 函数体 }',
        '捕获列表控制 Lambda 如何访问外部变量：[=] 值捕获，[&] 引用捕获',
        '按值捕获的 Lambda 使用 mutable 才能修改捕获的副本',
        'Lambda 广泛用于 STL 算法：sort、find_if、count_if、remove_if、for_each、transform 等',
        'std::function<Signature> 可以存储 Lambda，实现回调和高阶函数',
      ],
    ),

    CourseLesson(
      id: 'cpp_lambda_advanced',
      title: 'Lambda 进阶',
      content: '''# Lambda 进阶

## 泛型 Lambda (C++14)

C++14 引入泛型 Lambda，参数使用 `auto`：

```cpp
auto add = [](auto a, auto b) { return a + b; };

add(1, 2);        // int
add(1.0, 2.5);   // double
add("hello", "world");  // string
```

## Lambda 初始化捕获 (C++14)

在捕获列表中直接初始化变量：

```cpp
int x = 10;
auto lambda = [y = x * 2]() { return y; };  // y 是新变量，值为 20
```

## Lambda 表达式作为返回值

不能直接返回 Lambda，但可以包装在 `std::function` 中：

```cpp
function<int(int)> makeMultiplier(int factor) {
    return [factor](int x) { return x * factor; };
}
```

## Lambda 与 std::bind

`std::bind` 可以预设参数，Lambda 是更现代的替代：

```cpp
// 使用 bind
auto greaterThan5 = bind(greater<int>(), placeholders::_1, 5);

// 使用 Lambda（更清晰）
auto greaterThan5 = [](int x) { return x > 5; };
```

## 递归 Lambda

Lambda 不能直接引用自己，但可以借助 `std::function`：

```cpp
function<int(int)> fib = [&fib](int n) {
    if (n <= 1) return n;
    return fib(n-1) + fib(n-2);
};
```

## Lambda 的类型推断

```cpp
// auto 推断类型
auto l1 = [](int x) { return x; };  // 类型: lambda 类型（编译器生成）

// decltype 获取类型
decltype(l1) l2 = l1;  // l1 和 l2 类型相同
```

## Lambda 与比较

STL 容器和算法需要比较操作，Lambda 可以替代自定义比较器：

```cpp
// set 自定义比较
set<int, function<bool(int, int)>> s([](int a, int b) { return a > b; });

// map 自定义键比较
map<string, int, function<bool(string, string)>> m(
    [](const string& a, const string& b) { return a.length() < b.length(); }
);
```

## Lambda 捕获 this

在类中使用 Lambda，需要捕获 `this`：

```cpp
class Calculator {
    int factor = 10;
public:
    auto getMultiplier() {
        // 捕获 this（按值）
        return [this](int x) { return x * factor; };
        // 或者 [factor = factor]
    }
};
```

## 常量 Lambda (C++17)

C++17 可以将 Lambda 声明为 `constexpr`：

```cpp
constexpr auto add = [](int a, int b) { return a + b; };
int arr[add(2, 3)];  // 编译时常量，arr 大小为 5
```

## Lambda 的性能

Lambda 通常比函数指针更快（内联），比仿函数更灵活：

| 方式 | 性能 | 灵活性 |
|------|------|--------|
| 函数指针 | 最差（无法内联） | 低 |
| 仿函数 | 好 | 高 |
| Lambda | 最好（可内联） | 高 |

## 常见 Lambda 用法总结

```cpp
// 条件过滤
auto isPositive = [](int x) { return x > 0; };

// 比较器
auto cmp = [](const A& a, const A& b) { return a.key < b.key; };

// 转换
auto square = [](int x) { return x * x; };

// 回调
auto onClick = [](int x) { cout << x << endl; };

// 延迟执行
vector<int> ids = {1, 2, 3};
for_each(ids.begin(), ids.end(), [](int id) {
    // 实际处理逻辑
});
```
''',
      codeExamples: [
        CodeExample(
          title: '泛型 Lambda 与初始化捕获',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <map>
using namespace std;

int main() {
    cout << "=== 泛型 Lambda (C++14) ===" << endl;

    // 泛型 Lambda
    auto print = [](auto value) {
        cout << value << endl;
    };

    print(42);
    print(3.14);
    print("hello");
    print('c');

    // 泛型运算
    auto add = [](auto a, auto b) { return a + b; };
    cout << "int: " << add(1, 2) << endl;
    cout << "double: " << add(1.5, 2.5) << endl;
    cout << "string: " << add(string("hello"), string(" world")) << endl;

    // min/max 泛型版本
    auto myMin = [](auto a, auto b) { return (a < b) ? a : b; };
    auto myMax = [](auto a, auto b) { return (a > b) ? a : b; };
    cout << "min(3, 7) = " << myMin(3, 7) << endl;
    cout << "max(3, 7) = " << myMax(3, 7) << endl;

    cout << "\\n=== 初始化捕获 (C++14) ===" << endl;

    int x = 10;

    // 直接初始化新变量
    auto captureInit = [y = x * 2]() {
        cout << "y = " << y << endl;
    };
    captureInit();

    // 移动捕获
    auto moveCapture = [s = string("hello")]() {
        cout << "s = " << s << endl;
    };
    moveCapture();

    // 基于表达式的初始化
    auto complexInit = [z = x + x * 2]() {
        return z;
    };
    cout << "complexInit = " << complexInit() << endl;

    cout << "\\n=== 递归 Lambda ===" << endl;

    // 阶乘
    function<int(int)> factorial = [&factorial](int n) -> int {
        if (n <= 1) return 1;
        return n * factorial(n - 1);
    };
    cout << "5! = " << factorial(5) << endl;

    // 斐波那契
    function<int(int)> fib = [&fib](int n) -> int {
        if (n <= 1) return n;
        return fib(n - 1) + fib(n - 2);
    };
    cout << "fib(10) = " << fib(10) << endl;

    cout << "\\n=== Lambda 作为返回值 ===" << endl;

    auto makeAdder = [](int n) {
        return [n](int x) { return x + n; };
    };

    auto add5 = makeAdder(5);
    auto add10 = makeAdder(10);
    cout << "add5(3) = " << add5(3) << endl;
    cout << "add10(3) = " << add10(3) << endl;

    // 工厂函数
    auto makeMultiplier = [](int factor) {
        return [factor](int x) { return x * factor; };
    };

    auto times3 = makeMultiplier(3);
    auto times5 = makeMultiplier(5);
    vector<int> nums = {1, 2, 3, 4, 5};

    cout << "×3: ";
    for (int n : nums) cout << times3(n) << " ";
    cout << endl;

    cout << "×5: ";
    for (int n : nums) cout << times5(n) << " ";
    cout << endl;

    cout << "\\n=== Lambda 与容器 ===" << endl;

    // 自定义排序
    vector<pair<string, int>> vec = {{"apple", 3}, {"banana", 1}, {"cherry", 2}};
    sort(vec.begin(), vec.end(),
         [](const auto& a, const auto& b) { return a.second < b.second; });

    cout << "按值排序: ";
    for (const auto& p : vec)
        cout << "(" << p.first << "," << p.second << ") ";
    cout << endl;

    // 自定义 set
    set<int, function<bool(int, int)>> s([](int a, int b) { return a > b; });
    s.insert({5, 2, 8, 1, 9});
    cout << "降序 set: ";
    for (int n : s) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示泛型 Lambda、初始化捕获、递归 Lambda 和 Lambda 作为返回值的高级用法。',
          output: '''=== 泛型 Lambda (C++14) ===
42
3.14
hello
c
int: 3
double: 4
string: hello world
min(3, 7) = 3
max(3, 7) = 7

=== 初始化捕获 (C++14) ===
y = 20
s = hello
complexInit = 30

=== 递归 Lambda ===
5! = 120
fib(10) = 55

=== Lambda 作为返回值 ===
add5(3) = 8
add10(3) = 13
×3: 3 6 9 12 15 
×5: 5 10 15 20 25 

=== Lambda 与容器 ===
按值排序: (banana,1) (cherry,2) (apple,3) 
降序 set: 9 8 5 2 1 ''',
        ),
        CodeExample(
          title: 'Lambda 实战技巧',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <map>
#include <set>
using namespace std;

class EventManager {
    vector<function<void(int)>> handlers;
public:
    // 注册事件处理器
    void onEvent(function<void(int)> handler) {
        handlers.push_back(handler);
    }

    // 触发事件
    void trigger(int eventId) {
        for (auto& handler : handlers) {
            handler(eventId);
        }
    }
};

struct Query {
    string field;
    string value;
};

class QueryBuilder {
    vector<Query> queries;
public:
    QueryBuilder& add(const string& field, const string& value) {
        queries.push_back({field, value});
        return *this;  // 支持链式调用
    }

    template<typename Pred>
    QueryBuilder& where(Pred pred) {
        // 过滤查询
        vector<Query> filtered;
        for (const auto& q : queries) {
            Query temp = q;
            if (pred(temp)) {
                filtered.push_back(q);
            }
        }
        queries = filtered;
        return *this;
    }

    vector<Query> build() { return queries; }

    void print() const {
        for (const auto& q : queries) {
            cout << q.field << "=" << q.value << "; ";
        }
        cout << endl;
    }
};

int main() {
    cout << "=== Lambda 实战：事件系统 ===" << endl;

    EventManager manager;

    // 注册多个处理器
    manager.onEvent([](int id) {
        cout << "处理器1: 事件 " << id << endl;
    });

    manager.onEvent([](int id) {
        cout << "处理器2: 收到事件 " << id << endl;
    });

    manager.onEvent([](int id) {
        cout << "处理器3: 处理 " << id * 2 << endl;
    });

    manager.trigger(100);

    cout << "\\n=== Lambda 实战：链式调用 ===" << endl;

    QueryBuilder qb;
    qb.add("status", "active")
      .add("age", ">18")
      .add("country", "CN")
      .where([](const Query& q) {
          return q.field != "country";  // 过滤 country 条件
      })
      .where([](const Query& q) {
          return q.value.find(">") == string::npos;  // 过滤带 > 的
      });

    cout << "查询条件: ";
    qb.print();

    cout << "\\n=== Lambda 实战：条件执行 ===" << endl;

    bool flag = true;
    auto executeIf = [](bool cond, function<void()> func) {
        if (cond) func();
    };

    executeIf(flag, []() { cout << "条件为真时执行" << endl; });
    executeIf(!flag, []() { cout << "不会执行" << endl; });

    cout << "\\n=== Lambda 实战：延迟计算 ===" << endl;

    vector<int> data = {1, 2, 3, 4, 5};

    // 延迟执行的 filter
    auto lazyFilter = [&data](function<bool(int)> pred) {
        vector<int> result;
        for (int x : data) {
            if (pred(x)) result.push_back(x);
        }
        return result;
    };

    auto evens = lazyFilter([](int x) { return x % 2 == 0; });
    auto greaterThan3 = lazyFilter([](int x) { return x > 3; });

    cout << "偶数: ";
    for (int n : evens) cout << n << " ";
    cout << endl;

    cout << "大于3: ";
    for (int n : greaterThan3) cout << n << " ";
    cout << endl;

    cout << "\\n=== Lambda 实战：比较器工厂 ===" << endl;

    auto makeComparer = [](const string& field) {
        if (field == "name") {
            return [](const auto& a, const auto& b) {
                return a.name < b.name;
            };
        } else if (field == "age") {
            return [](const auto& a, const auto& b) {
                return a.age < b.age;
            };
        }
        return [](const auto&, const auto&) { return false; };
    };

    struct Person2 { string name; int age; };
    vector<Person2> people = {{"Charlie", 25}, {"Alice", 30}, {"Bob", 25}};

    sort(people.begin(), people.end(), makeComparer("name"));
    cout << "按名字: ";
    for (const auto& p : people) cout << p.name << "(age=" << p.age << ") ";
    cout << endl;

    sort(people.begin(), people.end(), makeComparer("age"));
    cout << "按年龄: ";
    for (const auto& p : people) cout << p.name << "(age=" << p.age << ") ";
    cout << endl;

    return 0;
}''',
          description: '展示 Lambda 在实战中的高级应用：事件系统、链式调用、条件执行、延迟计算、比较器工厂。',
          output: '''=== Lambda 实战：事件系统 ===
处理器1: 事件 100
处理器2: 收到事件 100
处理器3: 处理 200

=== Lambda 实战：链式调用 ===
查询条件: status=active; age=>18; 

=== Lambda 实战：条件执行 ===
条件为真时执行

=== Lambda 实战：延迟计算 ===
偶数: 2 4 
大于3: 4 5 

=== Lambda 实战：比较器工厂 ===
按名字: Alice(age=30) Bob(age=25) Charlie(age=25) 
按年龄: Bob(age=25) Charlie(age=25) Alice(age=30) ''',
        ),
      ],
      keyPoints: [
        '泛型 Lambda (C++14)：使用 auto 作为参数类型，实现真正的泛型函数',
        '初始化捕获 [y = expr]：在捕获列表中创建新变量，可以移动或基于表达式初始化',
        '递归 Lambda：需要借助 std::function，因为 Lambda 类型是匿名的',
        'Lambda 作为返回值：返回类型是 std::function<...>，常用于工厂函数',
        'Lambda 比函数指针更快（可内联），比仿函数更简洁，是现代 C++ 的标准做法',
      ],
    ),
  ],
);
