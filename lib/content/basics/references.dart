// 引用 - References
import '../course_data.dart';

/// 引用章节
const chapterReferences = CourseChapter(
  id: 'basics_references',
  title: '引用',
  description: '学习 C++ 中引用的概念、使用场景以及与指针的区别。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.basics,
  lessons: [
    CourseLesson(
      id: 'basics_references_intro',
      title: '引用的概念与使用',
      content: '''# 引用的概念与使用

## 什么是引用？

引用是变量的别名（alias），与变量共享同一块内存。

```cpp
int x = 10;
int& ref = x;  // ref 是 x 的引用

ref = 20;      // 修改 ref 就是修改 x
cout << x;     // 输出 20
```

## 引用 vs 指针

| 特性 | 引用 | 指针 |
|------|------|------|
| 语法 | `int& ref = x` | `int* ptr = &x` |
| 解引用 | 不需要 | 需要 `*ptr` |
| 空值 | 不存在空引用 | 可以是 nullptr |
| 重新绑定 | 不能 | 可以 |
|  sizeof | 等于原变量 | 指针大小 |

## 引用的特点

1. **必须初始化**：引用必须在定义时初始化
2. **不能重新绑定**：一旦绑定，不能改变
3. **没有空引用**：必须引用实际存在的变量
4. **语法更简洁**：不需要解引用操作符

## 引用的使用场景

1. **函数参数**：避免拷贝，高效传递大型对象
2. **函数返回值**：可以返回引用
3. **范围 for 循环**：遍历容器时修改元素
4. **实现运算符重载**：如 `operator[]`

## 引用作为参数的优势

```cpp
// 值传递 - 拷贝整个对象
void func1(MyClass obj);

// 引用传递 - 不拷贝
void func2(MyClass& obj);

// 常量引用 - 不能修改，高效
void func3(const MyClass& obj);
```
''',
      codeExamples: [
        CodeExample(
          title: '引用基础与引用作为参数',
          code: '''#include <iostream>
#include <string>
#include <vector>
using namespace std;

struct Student {
    string name;
    int age;
    vector<int> scores;
};

// 引用参数 - 修改原值
void swap(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

// 引用作为返回值
int& getElement(vector<int>& v, int index) {
    return v[index];  // 返回引用，可以修改元素
}

// 常量引用 - 只读访问
void printStudent(const Student& s) {
    cout << s.name << ", " << s.age << "岁";
    // s.name = "xxx";  // 错误！常量引用不能修改
}

// 引用遍历修改元素
void doubleAll(vector<int>& v) {
    for (int& num : v) {
        num *= 2;
    }
}

int main() {
    cout << "=== 引用基础 ===" << endl;
    int x = 10;
    int& ref = x;  // ref 是 x 的引用

    cout << "x = " << x << ", ref = " << ref << endl;
    ref = 20;
    cout << "修改后: x = " << x << endl;

    cout << "\\n=== 引用参数 ===" << endl;
    int a = 5, b = 10;
    cout << "交换前: a=" << a << ", b=" << b << endl;
    swap(a, b);
    cout << "交换后: a=" << a << ", b=" << b << endl;

    cout << "\\n=== 返回引用 ===" << endl;
    vector<int> v = {1, 2, 3, 4, 5};
    getElement(v, 2) = 100;  // 直接修改元素
    cout << "v[2] = " << v[2] << endl;

    cout << "\\n=== 常量引用 ===" << endl;
    Student s = {"张三", 20, {90, 85, 92}};
    printStudent(s);
    cout << endl;

    cout << "\\n=== 引用遍历 ===" << endl;
    vector<int> nums = {1, 2, 3, 4, 5};
    cout << "原值: ";
    for (int n : nums) cout << n << " ";
    cout << endl;

    doubleAll(nums);
    cout << "翻倍后: ";
    for (int n : nums) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示引用的基本用法、引用参数、返回引用，以及常量引用的使用。',
          output: '''=== 引用基础 ===
x = 10, ref = 10
修改后: x = 20

=== 引用参数 ===
交换前: a=5, b=10
交换后: a=10, b=5

=== 返回引用 ===
v[2] = 100

=== 常量引用 ===
张三, 20岁
=== 引用遍历 ===
原值: 1 2 3 4 5 
翻倍后: 2 4 6 8 10''',
        ),
        CodeExample(
          title: '引用与指针的对比',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 指针版本
void incrementPointer(int* p) {
    (*p)++;
}

// 引用版本
void incrementReference(int& r) {
    r++;
}

int main() {
    cout << "=== 指针 vs 引用 ===" << endl;

    int value = 10;

    // 指针调用
    incrementPointer(&value);
    cout << "通过指针: " << value << endl;

    // 引用调用
    incrementReference(value);
    cout << "通过引用: " << value << endl;

    cout << "\\n=== 引用 vs 指针安全性 ===" << endl;

    // 指针可以是空指针
    int* ptr = nullptr;
    // *ptr = 10;  // 危险！空指针解引用会导致崩溃

    // 引用必须有初始值
    // int& ref;  // 错误！引用必须初始化
    int& ref = value;  // 正确：引用必须绑定到对象

    cout << "ref 绑定到 value: " << ref << endl;

    cout << "\\n=== 引用不能重新绑定 ===" << endl;
    int x = 1, y = 2;
    int& r = x;
    cout << "r 绑定到 x: r=" << r << ", x=" << x << endl;

    r = y;  // 这不是重新绑定，而是修改了 x 的值！
    cout << "执行 r = y 后: r=" << r << ", x=" << x << ", y=" << y << endl;

    cout << "\\n=== 使用场景对比 ===" << endl;
    vector<int> v = {1, 2, 3};

    // 下标操作符返回引用
    int& element = v[0];
    element = 100;
    cout << "v[0] = " << v[0] << endl;

    // 范围 for 循环中的引用
    for (int& n : v) {
        n++;  // 直接修改原元素
    }
    cout << "自增后: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '对比引用和指针的使用场景，展示引用的安全性和不能重新绑定的特点。',
          output: '''=== 指针 vs 引用 ===
通过指针: 11
通过引用: 12

=== 引用 vs 指针安全性 ===
ref 绑定到 value: 12

=== 引用不能重新绑定 ===
r 绑定到 x: r=1, x=1
执行 r = y 后: r=2, x=2, y=2

=== 使用场景对比 ===
v[0] = 100
自增后: 101 3 4''',
        ),
      ],
      keyPoints: [
        '引用是变量的别名，与原变量共享内存，修改引用就是修改原变量',
        '引用必须在定义时初始化，不能是空引用，比指针更安全',
        '引用不能重新绑定，赋值操作修改的是引用的值，而不是重新绑定',
        '引用作为函数参数比指针更简洁，避免了 (*ptr) 解引用的语法',
        '范围 for 循环中使用引用 (for (int& n : v)) 可以直接修改容器元素',
      ],
    ),

    CourseLesson(
      id: 'basics_references_rvalue',
      title: '左值引用与右值引用',
      content: '''# 左值引用与右值引用

## 左值 vs 右值

- **左值 (lvalue)**：有持久地址的对象，可以取地址
- **右值 (rvalue)**：临时对象，不能取地址

```cpp
int x = 10;   // x 是左值，10 是右值
int& lr = x;  // 左值引用

int&& rr = 10;  // 右值引用，绑定到临时对象 10
```

## 左值引用 (lvalue reference)

```cpp
int x = 10;
int& lr = x;     // 正确：左值引用绑定左值
// int& lr2 = 10;  // 错误：左值引用不能绑定右值
```

## 右值引用 (rvalue reference) - C++11

```cpp
int&& rr = 10;    // 正确：右值引用绑定右值
// int&& rr2 = x;  // 错误：右值引用不能绑定左值
```

## 右值引用的意义

1. **移动语义**：避免不必要的拷贝
2. **完美转发**：保持参数的左右值特性

## 移动语义

```cpp
class Buffer {
public:
    Buffer(size_t size) : data(new char[size]) {}

    // 移动构造函数
    Buffer(Buffer&& other) noexcept : data(other.data) {
        other.data = nullptr;  // 转移所有权
    }

    // 移动赋值运算符
    Buffer& operator=(Buffer&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            other.data = nullptr;
        }
        return *this;
    }
};
```

## std::move

`std::move` 将左值转换为右值引用，用于触发移动操作：

```cpp
Buffer b1(100);
Buffer b2 = std::move(b1);  // 调用移动构造函数，b1 被"移动"
```
''',
      codeExamples: [
        CodeExample(
          title: '右值引用与移动语义',
          code: '''#include <iostream>
#include <vector>
#include <string>
#include <memory>
using namespace std;

// 演示移动语义的类
class MyString {
private:
    char* data;
    size_t len;

public:
    // 普通构造函数
    MyString(const char* str) {
        len = strlen(str);
        data = new char[len + 1];
        strcpy(data, str);
        cout << "构造: " << data << endl;
    }

    // 拷贝构造函数 (深拷贝)
    MyString(const MyString& other) : len(other.len) {
        data = new char[len + 1];
        strcpy(data, other.data);
        cout << "拷贝构造: " << data << endl;
    }

    // 移动构造函数 (转移所有权)
    MyString(MyString&& other) noexcept : data(other.data), len(other.len) {
        other.data = nullptr;  // 源对象置空
        other.len = 0;
        cout << "移动构造: " << data << endl;
    }

    // 移动赋值运算符
    MyString& operator=(MyString&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            len = other.len;
            other.data = nullptr;
            other.len = 0;
            cout << "移动赋值: " << data << endl;
        }
        return *this;
    }

    ~MyString() {
        if (data) {
            cout << "析构: " << data << endl;
        } else {
            cout << "析构: (空)" << endl;
        }
        delete[] data;
    }

    const char* get() const { return data ? data : "(空)"; }
};

int main() {
    cout << "=== 拷贝 vs 移动 ===" << endl;

    cout << "\\n1. 拷贝构造:" << endl;
    MyString s1("Hello");
    MyString s2 = s1;  // 拷贝

    cout << "\\n2. 移动构造:" << endl;
    MyString s3 = MyString("World");  // 临时对象，移动构造
    // 或者用 std::move
    MyString s4 = std::move(s1);  // s1 被移动到 s4

    cout << "\\n3. 移动后检查:" << endl;
    cout << "s1: " << s1.get() << endl;
    cout << "s4: " << s4.get() << endl;

    cout << "\\n4. 移动赋值:" << endl;
    MyString s5("Old");
    MyString s6("New");
    s5 = std::move(s6);  // 移动赋值

    cout << "\\n5. vector 的移动:" << endl;
    vector<MyString> v;
    v.push_back(MyString("Temp"));  // 临时对象直接移动进容器

    cout << "\\n=== 析构顺序 ===" << endl;
    return 0;
}''',
          description: '展示移动构造函数和移动赋值运算符如何避免不必要的深拷贝，以及 std::move 的使用。',
          output: '''=== 拷贝 vs 移动 ===

1. 拷贝构造:
构造: Hello
拷贝构造: Hello

2. 移动构造:
构造: World
移动构造: World
移动构造: Hello

3. 移动后检查:
s1: (空)
s4: Hello

4. 移动赋值:
移动赋值: New

5. vector 的移动:
构造: Temp
移动构造: Temp

=== 析构顺序 ===
析构: Temp
析构: (空)
析构: (空)
移动赋值: (空)
析构: (空)
析构: Hello
析构: (空)
析构: (空)''',
        ),
        CodeExample(
          title: '完美转发与 std::forward',
          code: '''#include <iostream>
#include <utility>
#include <vector>
#include <memory>
using namespace std;

// 完美转发示例
template<typename T>
void wrapper(T&& arg) {
    // 保持原始的左值/右值属性转发给 other
    process(forward<T>(arg));
}

void process(int& x) {
    cout << "process(int&): " << x << endl;
}

void process(int&& x) {
    cout << "process(int&&): " << x << endl;
}

class MoveOnly {
public:
    MoveOnly() {}
    MoveOnly(MoveOnly&&) noexcept { cout << "MoveOnly 移动" << endl; }
    MoveOnly(const MoveOnly&) = delete;
    MoveOnly& operator=(const MoveOnly&) = delete;
};

// 转发 unique_ptr
unique_ptr<int> create() {
    return make_unique<int>(42);
}

void consume(unique_ptr<int>&&) {
    cout << "收到 unique_ptr" << endl;
}

int main() {
    cout << "=== 完美转发 ===" << endl;

    int x = 10;
    wrapper(x);           // 传入左值
    wrapper(20);          // 传入右值

    cout << "\\n=== 转发 unique_ptr ===" << endl;
    auto uptr = create();
    cout << "值: " << *uptr << endl;

    cout << "\\n=== emplace 演示 ===" << endl;
    vector<MoveOnly> v;
    v.emplace_back();  // 直接构造，不移动
    v.push_back(MoveOnly());  // 需要移动

    return 0;
}''',
          description: '展示完美转发 forward 的作用，以及移动语义在模板和容器中的应用。',
          output: '''=== 完美转发 ===
process(int&): 10
process(int&&): 20

=== 转发 unique_ptr ===
值: 42

=== emplace 演示 ===
MoveOnly 移动''',
        ),
      ],
      keyPoints: [
        '左值有持久地址，右值是临时对象，右值引用用 && 表示',
        '移动语义通过移动构造函数和移动赋值运算符实现，避免深拷贝',
        'std::move 将左值转换为右值引用，触发移动操作',
        '完美转发 std::forward 保持参数的原始左右值属性',
        '移动后原对象变为空，必须将源对象的指针/引用置为空',
      ],
    ),
  ],
);
