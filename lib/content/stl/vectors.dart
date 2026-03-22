// Vector 容器 - Vector Container
import '../course_data.dart';

/// Vector 容器章节
const chapterVectors = CourseChapter(
  id: 'stl_vectors',
  title: 'Vector 容器',
  description: '学习 C++ STL 中 vector 容器的使用，包括创建、添加元素、访问、遍历和迭代器操作。',
  difficulty: DifficultyLevel.beginner,
  lessons: [
    CourseLesson(
      id: 'stl_vectors_basic',
      title: 'Vector 基础操作',
      content: '''# Vector 基础操作

## 什么是 Vector？

`vector` 是 C++ STL 中最常用的序列容器，类似于动态数组，可以自动管理内存大小。

## 为什么使用 Vector？

- **动态大小**：可以根据需要自动扩展
- **随机访问**：支持 O(1) 时间复杂度的下标访问
- **丰富的成员函数**：push_back, pop_back, insert, erase 等
- **类型安全**：强类型检查

## 基本操作

| 操作 | 函数 | 说明 |
|------|------|------|
| 创建 | `vector<T> v;` | 创建空 vector |
| 添加 | `v.push_back(x)` | 末尾添加元素 |
| 大小 | `v.size()` | 返回元素个数 |
| 访问 | `v[i]` 或 `v.at(i)` | 访问元素 |
| 删除 | `v.pop_back()` | 末尾删除元素 |
| 清空 | `v.clear()` | 清空所有元素 |
| 判空 | `v.empty()` | 判断是否为空 |

## 下标访问 vs at()

- `v[i]`：不检查下标，越界行为未定义
- `v.at(i)`：会检查下标，越界抛出 `std::out_of_range` 异常

## 初始化方式

```cpp
vector<int> v1;              // 空 vector
vector<int> v2(5);           // 5 个元素，默认值 0
vector<int> v3(5, 10);       // 5 个元素，都是 10
vector<int> v4{1, 2, 3, 4};  // 列表初始化
vector<int> v5 = v4;         // 拷贝构造
```
''',
      codeExamples: [
        CodeExample(
          title: 'Vector 基本操作演示',
          code: '''#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 创建 vector
    vector<int> numbers;

    // push_back - 末尾添加元素
    numbers.push_back(10);
    numbers.push_back(20);
    numbers.push_back(30);
    cout << "添加元素后: ";
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    // size - 获取大小
    cout << "元素个数: " << numbers.size() << endl;

    // 下标访问
    cout << "第一个元素: " << numbers[0] << endl;
    cout << "第二个元素: " << numbers.at(1) << endl;

    // 修改元素
    numbers[0] = 100;
    cout << "修改后第一个: " << numbers[0] << endl;

    // pop_back - 末尾删除
    numbers.pop_back();
    cout << "删除末尾后: ";
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    // empty - 判空
    cout << "是否为空: " << (numbers.empty() ? "是" : "否") << endl;

    // clear - 清空
    numbers.clear();
    cout << "清空后大小: " << numbers.size() << endl;

    // 不同初始化方式
    vector<int> v1(5);           // 5 个 0
    vector<int> v2(5, 100);     // 5 个 100
    vector<int> v3{1, 2, 3};    // 列表初始化

    cout << "v1 (5个0): ";
    for (int n : v1) cout << n << " ";
    cout << endl;

    cout << "v2 (5个100): ";
    for (int n : v2) cout << n << " ";
    cout << endl;

    cout << "v3 {1,2,3}: ";
    for (int n : v3) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示 vector 的基本操作：创建、添加、访问、修改、删除和初始化方式。',
          output: '''添加元素后: 10 20 30 
元素个数: 3
第一个元素: 10
第二个元素: 20
修改后第一个: 100
删除末尾后: 10 20 
是否为空: 否
清空后大小: 0
v1 (5个0): 0 0 0 0 0 
v2 (5个100): 100 100 100 100 100 
v3 {1,2,3}: 1 2 3''',
        ),
        CodeExample(
          title: 'Vector 遍历方式',
          code: '''#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> nums{10, 20, 30, 40, 50};

    // 方式1: 下标遍历
    cout << "下标遍历: ";
    for (size_t i = 0; i < nums.size(); i++) {
        cout << nums[i] << " ";
    }
    cout << endl;

    // 方式2: 迭代器遍历
    cout << "迭代器遍历: ";
    for (auto it = nums.begin(); it != nums.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;

    // 方式3: 范围 for 循环 (C++11)
    cout << "范围 for: ";
    for (int n : nums) {
        cout << n << " ";
    }
    cout << endl;

    // 方式4: const 迭代器 (遍历时不修改)
    cout << "const 迭代器: ";
    for (auto it = nums.cbegin(); it != nums.cend(); it++) {
        cout << *it << " ";
    }
    cout << endl;

    // 反向遍历
    cout << "反向遍历: ";
    for (auto it = nums.rbegin(); it != nums.rend(); it++) {
        cout << *it << " ";
    }
    cout << endl;

    // 修改元素 (范围 for 需用引用)
    cout << "每个元素翻倍: ";
    for (int& n : nums) {
        n *= 2;
    }
    for (int n : nums) {
        cout << n << " ";
    }
    cout << endl;

    // front 和 back
    cout << "front: " << nums.front() << ", back: " << nums.back() << endl;

    // capacity 和 size 的区别
    vector<int> v;
    cout << "\\n动态增长演示:" << endl;
    for (int i = 0; i < 10; i++) {
        v.push_back(i);
        cout << "size=" << v.size() << ", capacity=" << v.capacity() << endl;
    }

    return 0;
}''',
          description: '展示 vector 的多种遍历方式，以及 front/back/capacity 的概念。',
          output: '''下标遍历: 10 20 30 40 50 
迭代器遍历: 10 20 30 40 50 
范围 for: 10 20 30 40 50 
const 迭代器: 10 20 30 40 50 
反向遍历: 50 40 30 20 10 
每个元素翻倍: 20 40 60 80 100 
front: 20, back: 100

动态增长演示:
size=1, capacity=1
size=2, capacity=2
size=3, capacity=4
size=4, capacity=4
size=5, capacity=8
size=6, capacity=8
size=7, capacity=8
size=8, capacity=8
size=9, capacity=16
size=10, capacity=16''',
        ),
      ],
      keyPoints: [
        'vector 是动态数组，push_back 在末尾添加元素，pop_back 删除末尾元素',
        '下标访问 v[i] 不检查越界，v.at(i) 会检查并抛异常',
        '遍历方式：下标、迭代器、范围 for 循环',
        'capacity 是预分配的空间，size 是实际元素个数',
        '范围 for 遍历时加 & 可修改元素，const_iterator 遍历时不能修改',
      ],
    ),
    CourseLesson(
      id: 'stl_vectors_advanced',
      title: 'Vector 高级操作',
      content: '''# Vector 高级操作

## 插入操作 (insert)

```cpp
vector<int> v{1, 2, 3};
v.insert(v.begin() + 1, 100);  // 在位置1插入100: {1, 100, 2, 3}
```

## 删除操作 (erase)

```cpp
v.erase(v.begin() + 1);        // 删除位置1的元素
v.erase(v.begin(), v.begin() + 2);  // 删除范围 [first, last)
```

## vector 容量管理

| 函数 | 说明 |
|------|------|
| `shrink_to_fit()` | 释放多余容量 |
| `reserve(n)` | 预分配至少 n 个元素空间 |
| `resize(n)` | 改变大小（可填充默认值） |

## 性能优化技巧

1. **预分配空间**：如果知道大致大小，用 `reserve()` 避免多次扩容
2. **使用 emplace**：避免不必要的拷贝/移动
3. **避免在头部插入/删除**：时间复杂度 O(n)

## emplace vs push_back

```cpp
vector<Person> v;
// push_back 需要先创建对象，再拷贝/移动
v.push_back(Person("Alice", 20));
// emplace 直接在容器中构造，省去拷贝/移动
v.emplace_back("Bob", 25);
```

## 二维 Vector

```cpp
vector<vector<int>> matrix(3, vector<int>(4, 0));  // 3x4 矩阵
```
''',
      codeExamples: [
        CodeExample(
          title: 'insert 和 erase 操作',
          code: '''#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v{1, 2, 3, 4, 5};

    cout << "原始: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // insert - 在位置2插入100
    v.insert(v.begin() + 2, 100);
    cout << "insert(位置2, 100): ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // insert - 在开头插入多个元素
    v.insert(v.begin(), {0, -1, -2});
    cout << "insert(开头, {0,-1,-2}): ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // erase - 删除位置3的元素
    v.erase(v.begin() + 3);
    cout << "erase(位置3): ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // erase - 删除一个范围
    v.erase(v.begin() + 1, v.begin() + 4);  // 删除 [1,4)
    cout << "erase(位置1-4): ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // clear
    v.clear();
    cout << "clear后大小: " << v.size() << endl;

    // resize - 改变大小
    v.resize(5, 99);  // 大小改为5，不足的用99填充
    cout << "resize(5, 99): ";
    for (int n : v) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '演示 insert、erase、clear、resize 等操作的使用方法和效果。',
          output: '''原始: 1 2 3 4 5 
insert(位置2, 100): 1 2 100 3 4 5 
insert(开头, {0,-1,-2}): 0 -1 -2 1 2 100 3 4 5 
erase(位置3): 0 -1 1 2 100 3 4 5 
erase(位置1-4): 0 100 3 4 5 
clear后大小: 0
resize(5, 99): 99 99 99 99 99''',
        ),
        CodeExample(
          title: '性能优化与 emplace',
          code: '''#include <iostream>
#include <vector>
#include <chrono>
using namespace std;

class Student {
private:
    string name;
    int id;
public:
    Student(const string& n, int i) : name(n), id(i) {
        cout << "构造: " << name << endl;
    }
    Student(const Student& s) : name(s.name), id(s.id) {
        cout << "拷贝构造: " << name << endl;
    }
    Student(Student&& s) noexcept : name(move(s.name)), id(s.id) {
        cout << "移动构造: " << name << endl;
    }
};

int main() {
    cout << "=== push_back vs emplace ===" << endl;

    cout << "\\npush_back:" << endl;
    vector<Student> v1;
    v1.push_back(Student("Alice", 1));

    cout << "\\nemplace_back:" << endl;
    vector<Student> v2;
    v2.emplace_back("Bob", 2);

    cout << "\\n=== reserve 性能测试 ===" << endl;
    vector<int> v3;
    v3.reserve(100000);  // 预分配空间

    auto start = chrono::high_resolution_clock::now();
    for (int i = 0; i < 100000; i++) {
        v3.push_back(i);
    }
    auto end = chrono::high_resolution_clock::now();
    auto duration = chrono::duration_cast<chrono::milliseconds>(end - start);
    cout << "预分配后耗时: " << duration.count() << " ms" << endl;
    cout << "capacity: " << v3.capacity() << endl;

    return 0;
}''',
          description: '展示 emplace_back 的优势，以及 reserve 预分配空间对性能的影响。',
          output: '''=== push_back vs emplace ===

push_back:
构造: Alice
移动构造: Alice

emplace_back:
构造: Bob

=== reserve 性能测试 ===
预分配后耗时: 4 ms
capacity: 100000''',
        ),
      ],
      keyPoints: [
        'insert 和 erase 在中间位置操作时间复杂度为 O(n)',
        'emplace_back 直接构造对象，避免拷贝/移动开销',
        'reserve 预分配空间可避免多次扩容带来的性能开销',
        'resize 会改变元素个数，shrink_to_fit 释放多余容量',
        '避免在 vector 头部频繁插入/删除，考虑使用 deque',
      ],
    ),
  ],
);
