// 指针基础 - Pointer Basics
import '../course_data.dart';

/// 指针基础章节
const chapterPointers = CourseChapter(
  id: 'basics_pointers',
  title: '指针基础',
  description: '学习 C++ 中指针的概念、定义、使用以及指针与数组、函数的关系。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.basics,
  lessons: [
    CourseLesson(
      id: 'basics_pointers_intro',
      title: '指针的概念与定义',
      content: '''# 指针的概念与定义

## 什么是指针？

指针是一种特殊的数据类型，存储另一个变量的内存地址。

```
变量 x 的值: 42
变量 x 的地址: 0x7ffe1234

指针 p 存储的值: 0x7ffe1234 (x 的地址)
指针 p 指向的内存: 42
```

## 指针的声明

```cpp
int* ptr;        // 指向 int 的指针
double* dp;     // 指向 double 的指针
char* cp;       // 指向 char 的指针
```

## 取地址运算符 &

使用 `&` 获取变量的地址：

```cpp
int x = 10;
int* ptr = &x;  // ptr 存储 x 的地址
```

## 解引用运算符 *

使用 `*` 访问指针指向的内存：

```cpp
int x = 10;
int* ptr = &x;
cout << *ptr;   // 输出 ptr 指向的值: 10
*ptr = 20;      // 修改 ptr 指向的内存
cout << x;      // x 变为 20
```

## 指针的大小

- 指针的大小取决于系统架构
- 32 位系统：4 字节
- 64 位系统：8 字节

## 指针的类型

指针类型决定了如何解释指向的内存：

```cpp
int* pi;      // 指向 int，步长 4 字节
char* pc;     // 指向 char，步长 1 字节
double* pd;   // 指向 double，步长 8 字节
```
''',
      codeExamples: [
        CodeExample(
          title: '指针基础操作',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 基本指针操作
    int x = 42;
    int* ptr = &x;  // ptr 存储 x 的地址

    cout << "=== 指针基础 ===" << endl;
    cout << "x 的值: " << x << endl;
    cout << "x 的地址: " << &x << endl;
    cout << "ptr 的值 (存储的地址): " << ptr << endl;
    cout << "ptr 指向的值: " << *ptr << endl;

    // 通过指针修改值
    *ptr = 100;
    cout << "\\n通过 *ptr = 100 修改后:" << endl;
    cout << "x 的值: " << x << endl;
    cout << "*ptr: " << *ptr << endl;

    // 指针的大小
    cout << "\\n=== 指针大小 ===" << endl;
    cout << "int* 大小: " << sizeof(int*) << " 字节" << endl;
    cout << "char* 大小: " << sizeof(char*) << " 字节" << endl;
    cout << "double* 大小: " << sizeof(double*) << " 字节" << endl;

    // 不同类型指针
    cout << "\\n=== 不同类型指针 ===" << endl;
    int arr[] = {1, 2, 3, 4, 5};
    int* pInt = arr;
    char* pChar = (char*)arr;  // 强制类型转换

    cout << "pInt[2] = " << pInt[2] << endl;
    cout << "pChar[0] = " << (int)pChar[0] << endl;

    // void* 指针
    cout << "\\n=== void* 指针 ===" << endl;
    void* vp = &x;
    cout << "void* vp 存储的地址: " << vp << endl;
    // 使用前必须转换为具体类型
    int* fromVoid = static_cast<int*>(vp);
    cout << "转换后 *fromVoid: " << *fromVoid << endl;

    return 0;
}''',
          description: '展示指针的基本操作：取地址、解引用、修改值，以及不同类型指针的区别。',
          output: '''=== 指针基础 ===
x 的值: 42
x 的地址: 0x7ffe12345678
ptr 的值 (存储的地址): 0x7ffe12345678
ptr 指向的值: 42

通过 *ptr = 100 修改后:
x 的值: 100
*ptr: 100

=== 指针大小 ===
int* 大小: 8 字节
char* 大小: 8 字节
double* 大小: 8 字节

=== 不同类型指针 ===
pInt[2] = 3
pChar[0] = 1

=== void* 指针 ===
void* vp 存储的地址: 0x7ffe12345678
转换后 *fromVoid: 42''',
        ),
        CodeExample(
          title: '指针与数组',
          code: '''#include <iostream>
using namespace std;

int main() {
    int arr[] = {10, 20, 30, 40, 50};

    // 数组名就是首元素的地址
    int* p = arr;  // 等价于 &arr[0]

    cout << "=== 指针与数组 ===" << endl;
    cout << "arr (数组名/首地址): " << arr << endl;
    cout << "&arr[0]: " << &arr[0] << endl;
    cout << "p: " << p << endl;

    // 指针算术运算
    cout << "\\n=== 指针算术运算 ===" << endl;
    cout << "*p = " << *p << endl;
    p++;  // 移动到下一个 int
    cout << "p++ 后: *p = " << *p << endl;
    p += 2;  // 再移动 2 个 int
    cout << "p += 2 后: *p = " << *p << endl;

    // 使用指针遍历数组
    cout << "\\n=== 用指针遍历数组 ===" << endl;
    int* start = arr;
    int* end = arr + 5;
    for (int* ptr = start; ptr != end; ptr++) {
        cout << *ptr << " ";
    }
    cout << endl;

    // 指针与下标的关系
    cout << "\\n=== 指针与下标等价 ===" << endl;
    cout << "arr[3] = " << arr[3] << endl;
    cout << "*(arr + 3) = " << *(arr + 3) << endl;
    cout << "p[3] = " << p[-3] << endl;  // p 当前指向 arr[4]

    // const 指针
    cout << "\\n=== const 指针 ===" << endl;
    int x = 1, y = 2;

    // 指向常量的指针
    const int* cp = &x;
    // *cp = 10;  // 错误！不能通过 cp 修改
    cp = &y;  // 可以指向其他地址

    // 常量指针
    int* const ip = &x;
    *ip = 10;  // 可以修改值
    // ip = &y;  // 错误！指针本身是常量

    // 指向常量的常量指针
    const int* const ccp = &x;
    // *ccp = 10;  // 错误！
    // ccp = &y;   // 错误！

    cout << "x = " << x << ", y = " << y << endl;

    return 0;
}''',
          description: '展示指针与数组的关系、指针算术运算、以及 const 指针的不同形式。',
          output: '''=== 指针与数组 ===
arr (数组名/首地址): 0x7ffe12345678
&arr[0]: 0x7ffe12345678
p: 0x7ffe12345678

=== 指针算术运算 ===
*p = 10
p++ 后: *p = 20
p += 2 后: *p = 50

=== 用指针遍历数组 ===
10 20 30 40 50 
=== 指针与下标等价 ===
arr[3] = 40
*(arr + 3) = 40
p[3] = 20

=== const 指针 ===
x = 10, y = 2''',
        ),
      ],
      keyPoints: [
        '指针存储地址，使用 * 解引用访问值，& 取地址',
        '指针算术运算：指针 + n 表示向前移动 n 个元素大小，指针 - n 表示向后移动',
        '数组名就是首元素地址，指针运算与数组访问等价',
        '指向常量的指针 (const int* p) 不能通过指针修改值，但可以指向其他地址',
        '常量指针 (int* const p) 指针本身是常量，不能指向其他地址，但可以通过指针修改值',
      ],
    ),

    CourseLesson(
      id: 'basics_pointers_functions',
      title: '指针与函数',
      content: '''# 指针与函数

## 指针作为函数参数

通过指针在函数中修改外部变量：

```cpp
void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int x = 10, y = 20;
swap(&x, &y);  // x 和 y 被交换
```

## 指针作为返回值

可以返回指针，但要注意：

1. 不能返回局部变量的地址
2. 返回指向静态或全局变量的指针
3. 返回动态分配的内存

```cpp
// 正确：返回静态局部变量的地址
int* getPointer() {
    static int value = 100;
    return &value;
}

// 正确：返回动态分配内存
int* createArray(int size) {
    return new int[size];
}

// 错误！局部变量在函数结束时销毁
int* getLocalPtr() {
    int local = 10;
    return &local;  // 悬空指针！
}
```

## 函数指针

函数也有地址，可以存储到指针中：

```cpp
int add(int a, int b) { return a + b; }

int (*funcPtr)(int, int) = add;  // 指向返回 int、参数为 (int, int) 的函数
int result = funcPtr(3, 4);       // 调用 add(3, 4)
```

## 指向函数的指针数组

```cpp
int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }

int (*operations[])(int, int) = {add, sub};
int result = operations[0](10, 5);  // add(10, 5)
```
''',
      codeExamples: [
        CodeExample(
          title: '指针参数与返回值',
          code: '''#include <iostream>
using namespace std;

// 指针参数 - 修改外部变量
void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// 找最大最小值
void findMinMax(const int* arr, int size, int* min, int* max) {
    *min = *max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] < *min) *min = arr[i];
        if (arr[i] > *max) *max = arr[i];
    }
}

// 返回指针 - 返回动态数组
int* createRange(int start, int end) {
    int* arr = new int[end - start + 1];
    for (int i = 0; i <= end - start; i++) {
        arr[i] = start + i;
    }
    return arr;
}

// 返回静态局部变量的指针
int* getNextId() {
    static int id = 1000;
    return &id;  // 安全，返回静态变量的地址
}

// 函数指针
int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }

int main() {
    // 指针参数演示
    cout << "=== 指针参数 ===" << endl;
    int x = 10, y = 20;
    cout << "交换前: x=" << x << ", y=" << y << endl;
    swap(&x, &y);
    cout << "交换后: x=" << x << ", y=" << y << endl;

    // 找最大最小
    int arr[] = {5, 2, 9, 1, 7, 3, 8};
    int min, max;
    findMinMax(arr, 7, &min, &max);
    cout << "最小值: " << min << ", 最大值: " << max << endl;

    // 返回动态数组
    cout << "\\n=== 返回指针 ===" << endl;
    int* range = createRange(1, 10);
    cout << "createRange(1, 10): ";
    for (int i = 0; i <= 9; i++) {
        cout << range[i] << " ";
    }
    cout << endl;
    delete[] range;  // 记得释放内存

    // 静态局部变量
    int* id1 = getNextId();
    int* id2 = getNextId();
    cout << "ID1: " << *id1 << ", ID2: " << *id2 << endl;

    // 函数指针
    cout << "\\n=== 函数指针 ===" << endl;
    int (*operations[])(int, int) = {add, sub, mul};

    for (int i = 0; i < 3; i++) {
        cout << "operations[" << i << "](10, 5) = "
             << operations[i](10, 5) << endl;
    }

    return 0;
}''',
          description: '展示指针作为函数参数、返回值，以及函数指针数组的使用。',
          output: '''=== 指针参数 ===
交换前: x=10, y=20
交换后: x=20, y=10
最小值: 1, 最大值: 9

=== 返回指针 ===
createRange(1, 10): 1 2 3 4 5 6 7 8 9 10 

ID1: 1000, ID2: 1001

=== 函数指针 ===
operations[0](10, 5) = 15
operations[1](10, 5) = 5
operations[2](10, 5) = 50''',
        ),
        CodeExample(
          title: '函数指针与回调',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 函数指针类型别名
using CompareFunc = bool(*)(int, int);

// 回调函数示例
bool ascending(int a, int b) { return a < b; }
bool descending(int a, int b) { return a > b; }

// 使用函数指针进行排序
void bubbleSort(vector<int>& arr, CompareFunc cmp) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (cmp(arr[j], arr[j + 1])) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}

// typedef 定义函数指针类型
typedef bool (*Predicate)(int);

// 通用查找函数
int* findIf(int* arr, int size, Predicate pred) {
    for (int i = 0; i < size; i++) {
        if (pred(arr[i])) {
            return &arr[i];
        }
    }
    return nullptr;
}

// 使用 lambda 作为函数指针
bool isEven(int n) { return n % 2 == 0; }
bool isPositive(int n) { return n > 0; }

int main() {
    cout << "=== 函数指针排序 ===" << endl;
    vector<int> v1 = {5, 2, 8, 1, 9, 3, 7};

    bubbleSort(v1, ascending);
    cout << "升序: ";
    for (int n : v1) cout << n << " ";
    cout << endl;

    bubbleSort(v1, descending);
    cout << "降序: ";
    for (int n : v1) cout << n << " ";
    cout << endl;

    // 函数指针查找
    cout << "\\n=== 函数指针查找 ===" << endl;
    int arr[] = {1, 3, 5, 7, 9, 11, 13};

    int* found = findIf(arr, 7, isEven);
    if (found) cout << "第一个偶数: " << *found << endl;

    found = findIf(arr, 7, [](int n) { return n > 8; });  // lambda
    if (found) cout << "第一个大于8的: " << *found << endl;

    // std::function 包装函数指针
    cout << "\\n=== std::function ===" << endl;
    #include <functional>
    std::function<int(int, int)> func = add;
    cout << "func(3, 4) = " << func(3, 4) << endl;

    return 0;
}''',
          description: '展示函数指针作为回调、lambda 表达式，以及 std::function 的使用。',
          output: '''=== 函数指针排序 ===
升序: 1 2 3 5 7 8 9 
降序: 9 8 7 5 3 2 1 

=== 函数指针查找 ===
第一个偶数: 3
第一个大于8的: 9

=== std::function ===
func(3, 4) = 7''',
        ),
      ],
      keyPoints: [
        '指针作为函数参数允许函数修改外部变量，效果类似引用传递',
        '指针作为返回值可以返回动态分配内存或静态变量地址，但不能返回局部变量地址',
        '函数指针声明形式：返回类型 (*指针名)(参数类型列表)',
        '函数指针可用于回调机制，实现策略模式或泛型算法',
        'lambda 表达式可以替代函数指针，提供更灵活的函数对象',
      ],
    ),
  ],
);
