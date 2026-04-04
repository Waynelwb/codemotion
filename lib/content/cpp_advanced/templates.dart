// C++ 高级特性 - 模板 - Templates
import '../course_data.dart';

/// 模板章节
const chapterTemplates = CourseChapter(
  id: 'cpp_advanced_templates',
  title: 'C++ 模板 (Templates)',
  description: '学习 C++ 模板的概念，包括函数模板、类模板、模板参数推导、模板特化和可变参数模板。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.stl,
  lessons: [
    CourseLesson(
      id: 'cpp_templates_basics',
      title: '模板基础',
      content: '''# 模板基础

## 为什么需要模板？

如果不使用模板，为不同类型写相同逻辑需要重复代码：

```cpp
// 需要为 int、float、double 分别写函数
int max(int a, int b) { return a > b ? a : b; }
float max(float a, float b) { return a > b ? a : b; }
double max(double a, double b) { return a > b ? a : b; }
```

使用模板，一份代码搞定所有类型：

```cpp
template<typename T>
T max(T a, T b) {
    return a > b ? a : b;
}

// 使用
cout << max(1, 2);        // int
cout << max(1.5, 2.5);    // double
cout << max('a', 'b');    // char
```

## 模板语法

```cpp
template<typename T>
template<class T>   // typename 和 class 在模板中完全等价
```

**注意**：`class` 并不意味着只能是类，基础类型（int、double）也可以。

## 函数模板

```cpp
template<typename T>
T add(T a, T b) {
    return a + b;
}

// 显式指定类型
add<int>(1, 2);

// 类型推导（编译器自动推断）
add(1, 2);        // 推断为 int
add(1.0, 2.0);    // 推断为 double
```

## 模板参数推导

编译器根据实参类型自动推断模板参数：

```cpp
template<typename T>
void print(T value) {
    cout << value << endl;
}

print(10);      // T = int
print("hello"); // T = const char*
print(3.14);    // T = double
```

## 多个模板参数

```cpp
template<typename T1, typename T2>
pair<T1, T2> makePair(T1 a, T2 b) {
    return {a, b};
}

auto p = makePair(1, "hello");  // pair<int, string>
```

## 非类型模板参数

模板参数不一定是类型，也可以是常量：

```cpp
template<int N>
int fibonacci() {
    static int dp[N+1] = {0};
    // ...
}

// 使用
cout << fibonacci<10>() << endl;
```

## 模板的编译模型

模板在**使用时**才实例化（包含模型）：

```cpp
// a.h
template<typename T>
T max(T a, T b) { return a > b ? a : b; }

// b.cpp
#include "a.h"
max(1, 2);  // 在这里实例化 max<int>

// c.cpp
#include "a.h"
max(1.0, 2.0);  // 在这里实例化 max<double>
```

## 模板与函数重载

模板和普通函数可以同时存在，编译器选择最匹配的：

```cpp
template<typename T>
T max(T a, T b) { return a > b ? a : b; }

int max(int a, int b) { return a > b ? a : b; }

max(1, 2);    // 调用普通函数（更匹配）
max(1.0, 2.0); // 调用模板
```
''',
      codeExamples: [
        CodeExample(
          title: '函数模板基础',
          code: '''#include <iostream>
#include <string>
using namespace std;

// 基础函数模板
template<typename T>
T maxValue(T a, T b) {
    cout << "调用模板: T=" << typeid(T).name() << endl;
    return a > b ? a : b;
}

// 多个模板参数
template<typename T1, typename T2>
pair<T1, T2> makePair(T1 a, T2 b) {
    return {a, b};
}

// 模板参数推导示例
template<typename T>
void printType(T value) {
    cout << "值: " << value << ", 类型: " << typeid(T).name() << endl;
}

// 交换模板
template<typename T>
void swap(T& a, T& b) {
    T temp = a;
    a = b;
    b = temp;
}

// 数组排序模板
template<typename T, int N>
void sortArray(T (&arr)[N]) {
    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j < N; j++) {
            if (arr[j] < arr[i]) {
                T temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
}

int main() {
    cout << "=== 函数模板基础 ===" << endl;

    // int 类型
    cout << "int: ";
    cout << maxValue(1, 2) << endl;

    // double 类型
    cout << "double: ";
    cout << maxValue(3.14, 2.71) << endl;

    // char 类型
    cout << "char: ";
    cout << maxValue('a', 'b') << endl;

    cout << "\\n=== 多个模板参数 ===" << endl;
    auto p = makePair(42, "答案");
    cout << "pair: (" << p.first << ", " << p.second << ")" << endl;

    cout << "\\n=== 模板参数推导 ===" << endl;
    printType(10);
    printType(3.14);
    printType("hello");
    printType('x');

    cout << "\\n=== 交换模板 ===" << endl;
    int x = 1, y = 2;
    cout << "交换前: x=" << x << ", y=" << y << endl;
    swap(x, y);
    cout << "交换后: x=" << x << ", y=" << y << endl;

    string s1 = "apple", s2 = "banana";
    cout << "交换前: s1=" << s1 << ", s2=" << s2 << endl;
    swap(s1, s2);
    cout << "交换后: s1=" << s1 << ", s2=" << s2 << endl;

    cout << "\\n=== 数组排序模板 ===" << endl;
    int arr[] = {64, 25, 12, 22, 11};
    cout << "排序前: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    sortArray(arr);
    cout << "排序后: ";
    for (int n : arr) cout << n << " ";
    cout << endl;

    double dArr[] = {3.14, 1.41, 2.71, 1.73};
    cout << "double 排序前: ";
    for (double d : dArr) cout << d << " ";
    cout << endl;
    sortArray(dArr);
    cout << "double 排序后: ";
    for (double d : dArr) cout << d << " ";
    cout << endl;

    return 0;
}''',
          description: '展示函数模板的基础用法，包括类型推导、多模板参数、swap 和数组排序。',
          output: '''=== 函数模板基础 ===
int: 调用模板: T=i
2
double: 调用模板: T=d
3.14
char: 调用模板: T=c
b

=== 多个模板参数 ===
pair: (42, 答案)

=== 模板参数推导 ===
值: 10, 类型: i
值: 3.14, 类型: d
值: hello, 类型: PKc
值: x, 类型: c

=== 交换模板 ===
交换前: x=1, y=2
交换后: x=2, y=1
交换前: s1=apple, s2=banana
交换后: s1=banana, s2=apple

=== 数组排序模板 ===
排序前: 64 25 12 22 11 
排序后: 11 12 22 25 64 
double 排序前: 3.14 1.41 2.71 1.73 
double 排序后: 1.41 1.73 2.71 3.14''',
        ),
        CodeExample(
          title: '类模板基础',
          code: '''#include <iostream>
#include <vector>
#include <stdexcept>
using namespace std;

// 简单的 Stack 类模板
template<typename T>
class Stack {
private:
    vector<T> data;
public:
    void push(const T& value) {
        data.push_back(value);
    }

    void pop() {
        if (data.empty()) throw out_of_range("Stack is empty!");
        data.pop_back();
    }

    T& top() {
        if (data.empty()) throw out_of_range("Stack is empty!");
        return data.back();
    }

    const T& top() const {
        if (data.empty()) throw out_of_range("Stack is empty!");
        return data.back();
    }

    bool empty() const { return data.empty(); }
    size_t size() const { return data.size(); }
};

// Pair 类模板
template<typename T1, typename T2>
class Pair {
private:
    T1 first;
    T2 second;
public:
    Pair(const T1& f, const T2& s) : first(f), second(s) {}

    T1 getFirst() const { return first; }
    T2 getSecond() const { return second; }

    void setFirst(const T1& f) { first = f; }
    void setSecond(const T2& s) { second = s; }

    bool operator<(const Pair& other) const {
        return first < other.first ||
               (first == other.first && second < other.second);
    }
};

// 带有默认模板参数的类模板
template<typename T = int, int N = 100>
class FixedArray {
private:
    T data[N];
    int size_;
public:
    FixedArray() : size_(0) {}

    void add(const T& value) {
        if (size_ < N) data[size_++] = value;
    }

    T& operator[](int index) { return data[index]; }
    const T& operator[](int index) const { return data[index]; }

    int size() const { return size_; }
    int capacity() const { return N; }
};

int main() {
    cout << "=== Stack 类模板 ===" << endl;
    Stack<int> intStack;
    intStack.push(1);
    intStack.push(2);
    intStack.push(3);
    cout << "栈顶: " << intStack.top() << endl;
    intStack.pop();
    cout << "pop 后栈顶: " << intStack.top() << endl;
    cout << "大小: " << intStack.size() << endl;

    cout << "\\n字符串栈:" << endl;
    Stack<string> strStack;
    strStack.push("hello");
    strStack.push("world");
    while (!strStack.empty()) {
        cout << "弹出: " << strStack.top() << endl;
        strStack.pop();
    }

    cout << "\\n=== Pair 类模板 ===" << endl;
    Pair<int, string> p1(1, "one");
    Pair<int, string> p2(2, "two");
    cout << "p1: (" << p1.getFirst() << ", " << p1.getSecond() << ")" << endl;
    cout << "p2: (" << p2.getFirst() << ", " << p2.getSecond() << ")" << endl;
    cout << "p1 < p2: " << (p1 < p2 ? "true" : "false") << endl;

    cout << "\\n=== 默认模板参数 ===" << endl;
    FixedArray<double, 50> fa;
    fa.add(3.14);
    fa.add(2.71);
    cout << "FixedArray 大小: " << fa.size()
         << ", 容量: " << fa.capacity() << endl;

    FixedArray<> defaultArr;  // 使用默认参数 int, 100
    defaultArr.add(42);
    cout << "默认模板参数: " << defaultArr[0] << endl;

    return 0;
}''',
          description: '展示类模板的基础用法，包括 Stack、Pair 和带默认参数的模板。',
          output: '''=== Stack 类模板 ===
栈顶: 3
pop 后栈顶: 2
大小: 2

字符串栈:
弹出: world
弹出: hello

=== Pair 类模板 ===
p1: (1, one)
p2: (2, two)
p1 < p2: true

=== 默认模板参数 ===
FixedArray 大小: 2, 容量: 50
默认模板参数: 42''',
        ),
      ],
      keyPoints: [
        '模板是 C++ 实现泛型编程的基础，使用 template<typename T> 或 template<class T> 声明',
        '函数模板通过实参类型自动推导模板参数，也可以显式指定 template<typename T>',
        '类模板在创建对象时必须指定类型，如 Stack<int>',
        '非类型模板参数必须是常量表达式，如 int N',
        '模板在编译时实例化，不同翻译单元分别实例化，不会导致链接错误',
      ],
    ),

    CourseLesson(
      id: 'cpp_templates_advanced',
      title: '模板进阶',
      content: '''# 模板进阶

## 模板特化

当模板对特定类型需要特殊处理时，使用模板特化：

### 全特化

```cpp
// 通用模板
template<typename T>
T max(T a, T b) { return a > b ? a : b; }

// 对 char* 的全特化
template<>
const char* max<const char*>(const char* a, const char* b) {
    return strcmp(a, b) > 0 ? a : b;
}
```

### 偏特化（部分特化）

```cpp
// 通用模板：两个指针参数
template<typename T1, typename T2>
class Pair { /* ... */ };

// 偏特化：两个相同类型
template<typename T>
class Pair<T, T> { /* 特化版本 */ };

// 偏特化：T2 是 T1 的指针
template<typename T1, typename T2>
class Pair<T1, T2*> { /* ... */ };
```

## 模板默认参数

```cpp
template<typename T, typename Container = vector<T>>
class Stack {
    Container c;
public:
    void push(const T& value) { c.push_back(value); }
    // ...
};

// 使用默认容器
Stack<int> s1;  // vector<int>

// 指定不同容器
Stack<int, deque<int>> s2;  // deque<int>
```

## 可变参数模板

```cpp
// 可变参数函数
template<typename... Args>
void print(Args... args) {
    // sizeof...(args) 获取参数个数
}

// 展开参数包
template<typename T>
T sum(T value) { return value; }

template<typename T, typename... Args>
T sum(T first, Args... args) {
    return first + sum(args...);
}

cout << sum(1, 2, 3, 4, 5) << endl;  // 15
```

## SFINAE 与类型萃取

SFINAE (Substitution Failure Is Not An Error)：模板替换失败时，编译器尝试其他重载。

```cpp
// 检测类型是否有 size() 方法
template<typename T>
auto getSize(const T& c) -> decltype(c.size(), typename T::size_type()) {
    return c.size();
}
```

## 模板与 static

模板类的每个实例化版本有独立的 static 成员：

```cpp
template<typename T>
class Counter {
public:
    static int count;
    Counter() { count++; }
};

template<typename T>
int Counter<T>::count = 0;

Counter<int> c1, c2;
Counter<double> d1;
cout << Counter<int>::count << endl;   // 2
cout << Counter<double>::count << endl; // 1
```

## 模板实现静态多态

```cpp
// 概念：类似接口
template<typename T>
void drawShape(const T& shape) {
    shape.draw();  // 调用实际类型的 draw 方法
}
```

## 模板的注意事项

1. **头文件定义**：模板通常需要在头文件中定义（不能分离编译）
2. **编译时间**：大量模板可能导致编译变慢
3. **错误信息**：模板错误信息通常很长，难以理解
4. **调试困难**：模板代码调试不便

## 模板与 STL

STL 容器的实现大量使用模板：

```cpp
vector<int>      // vector<int>
vector<string>   // vector<string>
map<string, int> // map<string, int>
```

理解模板是深入理解 STL 的前提。
''',
      codeExamples: [
        CodeExample(
          title: '模板特化与偏特化',
          code: '''#include <iostream>
#include <cstring>
using namespace std;

// 通用模板
template<typename T>
T maxTemplate(T a, T b) {
    cout << "通用模板: ";
    return a > b ? a : b;
}

// 全特化：const char*
template<>
const char* maxTemplate<const char*>(const char* a, const char* b) {
    cout << "char* 特化: ";
    return strcmp(a, b) > 0 ? a : b;
}

// 通用 Pair 模板
template<typename T1, typename T2>
class MyPair {
public:
    T1 first;
    T2 second;
    MyPair(const T1& f, const T2& s) : first(f), second(s) {}
    void print() const {
        cout << "Pair(" << first << ", " << second << ")" << endl;
    }
};

// 偏特化：两个相同类型
template<typename T>
class MyPair<T, T> {
public:
    T first;
    T second;
    MyPair(const T& f, const T& s) : first(f), second(s) {}
    void print() const {
        cout << "Pair<" << typeid(T).name() << ">(" << first << ", " << second << ")" << endl;
    }
};

// 偏特化：第二个类型是指针
template<typename T1, typename T2>
class MyPair<T1, T2*> {
public:
    T1 first;
    T2* second;
    MyPair(const T1& f, T2* s) : first(f), second(s) {}
    void print() const {
        cout << "Pointer Pair(" << first << ", " << *second << ")" << endl;
    }
};

// static 模板成员
template<typename T>
class Counter {
public:
    static int count;
    Counter() { count++; }
    static void printCount() {
        cout << "Counter<" << typeid(T).name() << ">: " << count << endl;
    }
};

template<typename T>
int Counter<T>::count = 0;

int main() {
    cout << "=== 模板特化 ===" << endl;
    cout << maxTemplate(1, 2) << endl;
    cout << maxTemplate(3.14, 2.71) << endl;
    cout << maxTemplate("apple", "banana") << endl;

    cout << "\\n=== 偏特化 ===" << endl;
    MyPair<int, double> p1(1, 2.5);
    p1.print();

    MyPair<int, int> p2(10, 20);
    p2.print();

    int val = 100;
    MyPair<string, int*> p3("value", &val);
    p3.print();

    cout << "\\n=== static 模板成员 ===" << endl;
    Counter<int> c1, c2, c3;
    Counter<double> d1, d2;
    Counter<int>::printCount();    // 3
    Counter<double>::printCount(); // 2

    return 0;
}''',
          description: '展示模板全特化、偏特化和 static 模板成员的使用。',
          output: '''=== 模板特化 ===
通用模板: 2
通用模板: 3.14
char* 特化: banana

=== 偏特化 ===
Pair(1, 2.5)
Pair<i>(10, 20)
Pointer Pair(value, 100)

=== static 模板成员 ===
Counter<i>: 3
Counter<d>: 2''',
        ),
        CodeExample(
          title: '可变参数模板',
          code: '''#include <iostream>
using namespace std;

// 可变参数模板 - 递归终止函数
void print() {
    cout << endl;
}

// 可变参数模板 - 递归打印
template<typename T, typename... Args>
void print(const T& first, const Args&... args) {
    cout << first;
    if (sizeof...(args) > 0) cout << ", ";
    print(args...);
}

// 求和 - 递归终止
int sum() { return 0; }

template<typename T, typename... Args>
int sum(T first, Args... args) {
    return first + sum(args...);
}

// 获取第 N 个参数
template<int N, typename T, typename... Args>
struct NthType {
    using type = typename NthType<N-1, Args...>::type;
};

template<typename T, typename... Args>
struct NthType<0, T, Args...> {
    using type = T;
};

// make_index_sequence 用于元编程
template<size_t... Indices>
struct IndexSequence {
    using type = IndexSequence<Indices..., sizeof...(Indices)>;
};

template<size_t N>
struct MakeIndexSequence {
    using type = typename MakeIndexSequence<N-1>::type::template append<N-1>;
};

template<>
struct MakeIndexSequence<0> {
    using type = IndexSequence<>;
};

int main() {
    cout << "=== 可变参数模板打印 ===" << endl;
    print(1, 2, 3, 4, 5);
    print("hello", 42, 3.14, 'a');
    print("仅一个参数");

    cout << "\\n=== 可变参数求和 ===" << endl;
    cout << "sum(): " << sum() << endl;
    cout << "sum(1): " << sum(1) << endl;
    cout << "sum(1, 2): " << sum(1, 2) << endl;
    cout << "sum(1, 2, 3, 4, 5): " << sum(1, 2, 3, 4, 5) << endl;

    cout << "\\n=== 类型萃取 ===" << endl;
    using T0 = typename NthType<0, int, double, char, string>::type;
    using T2 = typename NthType<2, int, double, char, string>::type;
    cout << "第 0 个类型: " << typeid(T0).name() << endl;
    cout << "第 2 个类型: " << typeid(T2).name() << endl;

    cout << "\\n=== 模板应用：参数验证 ===" << endl;
    auto maxOf = [](auto... args) {
        auto list = {args...};
        return *max_element(list.begin(), list.end());
    };

    cout << "maxOf(1, 2, 3): " << maxOf(1, 2, 3) << endl;
    cout << "maxOf(3.14, 2.71, 1.41): " << maxOf(3.14, 2.71, 1.41) << endl;

    return 0;
}''',
          description: '展示可变参数模板的递归展开、求和以及类型萃取的应用。',
          output: '''=== 可变参数模板打印 ===
1, 2, 3, 4, 5
hello, 42, 3.14, a
仅一个参数

=== 可变参数求和 ===
sum(): 0
sum(1): 1
sum(1, 2): 3
sum(1, 2, 3, 4, 5): 15

=== 类型萃取 ===
第 0 个类型: i
第 2 个类型: c

=== 模板应用：参数验证 ===
maxOf(1, 2, 3): 3
maxOf(3.14, 2.71, 1.41): 3.14''',
        ),
      ],
      keyPoints: [
        '模板特化：当通用模板对特定类型不适用时，使用 template<> 全特化或偏特化',
        '偏特化可以为模板的部分参数提供特殊实现，如 Pair<T, T> 和 Pair<T, T*>',
        '可变参数模板使用 sizeof...(Args) 获取参数个数，递归展开参数包',
        'SFINAE 原则：模板替换失败时，编译器尝试其他重载，不会报错',
        '模板的 static 成员在每个模板实例化版本中独立存在',
      ],
    ),
  ],
);
