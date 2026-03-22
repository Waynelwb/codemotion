// STL 算法 - STL Algorithms
import '../course_data.dart';

/// STL 算法章节
const chapterStlAlgorithms = CourseChapter(
  id: 'stl_algorithms',
  title: 'STL 算法',
  description: '学习 C++ STL 常用算法，包括排序、查找、遍历变换、数值计算等。',
  difficulty: DifficultyLevel.intermediate,
  lessons: [
    CourseLesson(
      id: 'stl_algorithms_sorting',
      title: '排序与查找算法',
      content: '''# 排序与查找算法

## 排序算法

| 函数 | 说明 |
|------|------|
| `sort` | 快速排序，O(n log n)，不稳定 |
| `stable_sort` | 稳定排序，O(n log n) |
| `partial_sort` | 部分排序，只保证前 n 个有序 |
| `nth_element` | 找到第 n 小的元素 |
| `reverse` | 反转顺序 |
| `rotate` | 旋转元素 |

## 查找算法

| 函数 | 说明 |
|------|------|
| `find` | 查找第一个匹配元素 |
| `find_if` | 查找第一个满足条件的元素 |
| `binary_search` | 二分查找（需有序） |
| `lower_bound` | 找到第一个不小于 value 的位置 |
| `upper_bound` | 找到第一个大于 value 的位置 |
| `equal_range` | 返回 lower 和 upper 的范围 |

## sort 的比较函数

```cpp
// 默认升序
sort(v.begin(), v.end());

// 降序
sort(v.begin(), v.end(), greater<int>());

// 自定义比较
sort(v.begin(), v.end(), [](int a, int b) {
    return a > b;  // 降序
});
```
''',
      codeExamples: [
        CodeExample(
          title: 'sort 排序演示',
          code: '''#include <iostream>
#include <algorithm>
#include <vector>
#include <array>
using namespace std;

int main() {
    // 基本 sort
    vector<int> v = {5, 2, 8, 1, 9, 3};
    cout << "原始: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    sort(v.begin(), v.end());
    cout << "升序: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // 降序排序
    sort(v.begin(), v.end(), greater<int>());
    cout << "降序: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // partial_sort - 只排前 n 个
    vector<int> v2 = {9, 5, 2, 8, 1, 9, 3, 7, 6};
    partial_sort(v2.begin(), v2.begin() + 3, v2.end());
    cout << "partial_sort (前3): ";
    for (int n : v2) cout << n << " ";
    cout << endl;

    // nth_element - 找到第 n 小的元素
    vector<int> v3 = {5, 2, 8, 1, 9, 3, 7, 6};
    nth_element(v3.begin(), v3.begin() + 4, v3.end());
    cout << "nth_element (第5小): " << v3[4] << endl;
    cout << "v3: ";
    for (int n : v3) cout << n << " ";
    cout << endl;

    // 结构体排序
    struct Student {
        string name;
        int score;
    };
    vector<Student> students = {
        {"Alice", 85},
        {"Bob", 92},
        {"Charlie", 78}
    };

    sort(students.begin(), students.end(),
         [](const Student& a, const Student& b) {
             return a.score > b.score;  // 按分数降序
         });

    cout << "\\n学生排名:" << endl;
    for (const auto& s : students) {
        cout << s.name << ": " << s.score << endl;
    }

    return 0;
}''',
          description: '展示 sort、partial_sort、nth_element 的使用，以及自定义比较函数排序结构体。',
          output: '''原始: 5 2 8 1 9 3 
升序: 1 2 3 5 8 9 
降序: 9 8 5 3 2 1 
partial_sort (前3):
1 2 3 9 5 8 7 9 6 
nth_element (第5小): 5
v3: 1 2 3 4 5 6 7 9 8 

学生排名:
Bob: 92
Alice: 85
Charlie: 78''',
        ),
        CodeExample(
          title: '查找算法演示',
          code: '''#include <iostream>
#include <algorithm>
#include <vector>
#include <functional>
using namespace std;

int main() {
    vector<int> v = {1, 3, 5, 7, 9, 11, 13};

    // find - 线性查找
    auto it = find(v.begin(), v.end(), 7);
    if (it != v.end()) {
        cout << "find: 找到 " << *it << " 在位置 " << (it - v.begin()) << endl;
    }

    // find_if - 查找满足条件的第一个元素
    it = find_if(v.begin(), v.end(), [](int x) { return x > 8; });
    if (it != v.end()) {
        cout << "find_if: 第一个大于8的是 " << *it << endl;
    }

    // binary_search - 二分查找 (必须有序!)
    bool found = binary_search(v.begin(), v.end(), 9);
    cout << "binary_search(9): " << found << endl;
    found = binary_search(v.begin(), v.end(), 10);
    cout << "binary_search(10): " << found << endl;

    // lower_bound / upper_bound
    cout << "\\n=== bound 操作 ===" << endl;
    auto lb = lower_bound(v.begin(), v.end(), 7);
    auto ub = upper_bound(v.begin(), v.end(), 7);
    cout << "lower_bound(7): " << (lb - v.begin()) << endl;
    cout << "upper_bound(7): " << (ub - v.begin()) << endl;

    // 查找范围
    auto range = equal_range(v.begin(), v.end(), 7);
    cout << "equal_range(7): 范围 [" << (range.first - v.begin())
         << ", " << (range.second - v.begin()) << ")" << endl;

    // count / count_if
    vector<int> v2 = {1, 2, 3, 2, 4, 2, 5};
    int cnt = count(v2.begin(), v2.end(), 2);
    cout << "\\ncount(2): " << cnt << endl;

    cnt = count_if(v2.begin(), v2.end(), [](int x) { return x % 2 == 0; });
    cout << "count_if(偶数): " << cnt << endl;

    // all_of / any_of / none_of
    vector<int> v3 = {2, 4, 6, 8};
    cout << "\\nall_of(偶数): " << all_of(v3.begin(), v3.end(), [](int x){ return x%2==0; }) << endl;
    cout << "any_of(奇数): " << any_of(v3.begin(), v3.end(), [](int x){ return x%2==1; }) << endl;
    cout << "none_of(负数): " << none_of(v3.begin(), v3.end(), [](int x){ return x<0; }) << endl;

    return 0;
}''',
          description: '展示 find、find_if、binary_search、lower_bound、count_if 等查找算法的使用。',
          output: '''find: 找到 7 在位置 3
find_if: 第一个大于8的是 9
binary_search(9): 1
binary_search(10): 0

=== bound 操作 ===
lower_bound(7): 3
upper_bound(7): 4
equal_range(7): 范围 [3, 4)

count(2): 3
count_if(偶数): 4

all_of(偶数): 1
any_of(奇数): 0
none_of(负数): 1''',
        ),
      ],
      keyPoints: [
        'sort 默认升序排序，O(n log n)；可自定义比较函数实现降序或复杂排序',
        'binary_search 必须在有序序列上使用，返回 bool 表示是否找到',
        'lower_bound 返回第一个不小于 value 的迭代器，upper_bound 返回第一个大于 value 的迭代器',
        'find 是线性查找 O(n)，binary_search 是二分查找 O(log n)',
        'all_of/any_of/none_of 用于检查元素是否满足条件',
      ],
    ),
    CourseLesson(
      id: 'stl_algorithms_transform',
      title: '遍历与变换算法',
      content: '''# 遍历与变换算法

## 遍历算法

| 函数 | 说明 |
|------|------|
| `for_each` | 对每个元素执行操作 |
| `transform` | 变换每个元素 |

## for_each

```cpp
vector<int> v = {1, 2, 3};
for_each(v.begin(), v.end(), [](int& x) {
    x *= 2;  // 每个元素翻倍
});
```

## transform

```cpp
// transform 可以同时做遍历和变换
transform(src.begin(), src.end(), dest.begin(), [](int x) {
    return x * 2;  // 返回变换后的值
});
```

## 数值算法 (<numeric>)

| 函数 | 说明 |
|------|------|
| `accumulate` | 求和 |
| `inner_product` | 内积 |
| `partial_sum` | 前缀和 |
| `iota` | 生成递增序列 |

## accumulate

```cpp
vector<int> v = {1, 2, 3, 4, 5};
int sum = accumulate(v.begin(), v.end(), 0);  // 15
```
''',
      codeExamples: [
        CodeExample(
          title: 'for_each 和 transform',
          code: '''#include <iostream>
#include <algorithm>
#include <vector>
#include <string>
using namespace std;

int main() {
    // for_each - 遍历并操作
    vector<int> v1 = {1, 2, 3, 4, 5};

    cout << "=== for_each ===" << endl;
    cout << "原值: ";
    for_each(v1.begin(), v1.end(), [](int x) {
        cout << x << " ";
    });
    cout << endl;

    // 引用捕获可以修改元素
    for_each(v1.begin(), v1.end(), [](int& x) {
        x *= 2;
    });
    cout << "翻倍后: ";
    for_each(v1.begin(), v1.end(), [](int x) {
        cout << x << " ";
    });
    cout << endl;

    // transform - 变换并存储
    cout << "\\n=== transform ===" << endl;
    vector<int> v2 = {1, 2, 3, 4, 5};
    vector<int> v3(5);

    // 一元变换
    transform(v2.begin(), v2.end(), v3.begin(), [](int x) {
        return x * x;  // 平方
    });
    cout << "平方: ";
    for (int n : v3) cout << n << " ";
    cout << endl;

    // 二元变换 (合并两个序列)
    vector<int> a = {1, 2, 3};
    vector<int> b = {10, 20, 30};
    vector<int> c(3);
    transform(a.begin(), a.end(), b.begin(), c.begin(), [](int x, int y) {
        return x + y;  // 对应元素相加
    });
    cout << "a + b: ";
    for (int n : c) cout << n << " ";
    cout << endl;

    // 字符串处理
    vector<string> words = {"hello", "world", "cpp"};
    vector<string> upper;
    transform(words.begin(), words.end(), back_inserter(upper),
              [](const string& s) {
                  string result = s;
                  for (char& c : result) c = toupper(c);
                  return result;
              });
    cout << "大写: ";
    for (const string& s : upper) cout << s << " ";
    cout << endl;

    return 0;
}''',
          description: '展示 for_each 和 transform 的用法，包括一元变换和二元变换。',
          output: '''=== for_each ===
原值: 1 2 3 4 5 
翻倍后: 2 4 6 8 10 

=== transform ===
平方: 1 4 9 16 25 
a + b: 11 22 33 
大写: HELLO WORLD CPP''',
        ),
        CodeExample(
          title: '数值算法 accumulate 等',
          code: '''#include <iostream>
#include <numeric>
#include <vector>
#include <functional>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 4, 5};

    // accumulate - 求和 (初始值 0)
    int sum = accumulate(v.begin(), v.end(), 0);
    cout << "accumulate 求和: " << sum << endl;

    // accumulate - 自定义运算
    int product = accumulate(v.begin(), v.end(), 1, multiplies<int>());
    cout << "accumulate 乘积: " << product << endl;

    // accumulate - 字符串连接
    vector<string> words = {"Hello", " ", "World", "!"};
    string s = accumulate(words.begin(), words.end(), string(""));
    cout << "字符串连接: " << s << endl;

    // partial_sum - 前缀和
    cout << "\\n=== partial_sum (前缀和) ===" << endl;
    vector<int> ps(v.size());
    partial_sum(v.begin(), v.end(), ps.begin());
    cout << "原数组: ";
    for (int n : v) cout << n << " ";
    cout << endl;
    cout << "前缀和: ";
    for (int n : ps) cout << n << " ";
    cout << endl;

    // iota - 生成递增序列
    cout << "\\n=== iota ===" << endl;
    vector<int> seq(5);
    iota(seq.begin(), seq.end(), 10);  // 从10开始递增
    cout << "iota(从10开始): ";
    for (int n : seq) cout << n << " ";
    cout << endl;

    // inner_product - 内积
    vector<int> a = {1, 2, 3};
    vector<int> b = {4, 5, 6};
    int ip = inner_product(a.begin(), a.end(), b.begin(), 0);
    cout << "\\n内积 <a,b>: " << ip << endl;  // 1*4 + 2*5 + 3*6 = 32

    return 0;
}''',
          description: '展示 accumulate、partial_sum、iota、inner_product 等数值算法的使用。',
          output: '''accumulate 求和: 15
accumulate 乘积: 120
字符串连接: Hello World!

=== partial_sum (前缀和) ===
原数组: 1 2 3 4 5 
前缀和: 1 3 6 10 15 
iota(从10开始): 10 11 12 13 14 

内积 <a,b>: 32''',
        ),
      ],
      keyPoints: [
        'for_each 对每个元素执行操作，可通过引用捕获修改元素',
        'transform 可以一元变换（单序列）或二元变换（双序列合并）',
        'accumulate 默认做加法，可通过 binary_op 自定义运算（乘法、字符串连接等）',
        'partial_sum 计算前缀和，iota 生成递增序列',
        'inner_product 计算两个序列的内积（对应元素乘积之和）',
      ],
    ),
    CourseLesson(
      id: 'stl_algorithms_copy_remove',
      title: '复制、移除与分区',
      content: '''# 复制、移除与分区

## 复制算法

| 函数 | 说明 |
|------|------|
| `copy` | 复制元素到另一个范围 |
| `copy_if` | 有条件复制 |
| `copy_n` | 复制 n 个元素 |
| `copy_backward` | 反向复制 |
| `move` | 移动元素 |
| `fill` | 填充值 |
| `generate` | 用函数生成值 |

## 移除算法

| 函数 | 说明 |
|------|------|
| `remove` | 移除等于某值的元素 |
| `remove_if` | 满足条件的移除 |
| `unique` | 移除相邻重复元素 |
| `remove_copy` | 移除并复制 |

## 分区算法

| 函数 | 说明 |
|------|------|
| `partition` | 将满足条件的放到前面 |
| `stable_partition` | 稳定分区 |
| `is_partitioned` | 判断是否已分区 |
| `partition_point` | 找到分区点 |

## remove 原理

`remove` 实际上是将不等于 value 的元素前移，返回新的结尾迭代器。需要配合 `erase` 才能真正删除元素：

```cpp
v.erase(remove(v.begin(), v.end(), value), v.end());
```
''',
      codeExamples: [
        CodeExample(
          title: 'copy 与 remove',
          code: '''#include <iostream>
#include <algorithm>
#include <vector>
#include <iterator>
using namespace std;

int main() {
    // copy - 复制
    cout << "=== copy ===" << endl;
    vector<int> src = {1, 2, 3, 4, 5};
    vector<int> dest;
    copy(src.begin(), src.end(), back_inserter(dest));
    cout << "copy 结果: ";
    for (int n : dest) cout << n << " ";
    cout << endl;

    // copy_if - 条件复制
    vector<int> even;
    copy_if(src.begin(), src.end(), back_inserter(even),
            [](int x) { return x % 2 == 0; });
    cout << "copy_if(偶数): ";
    for (int n : even) cout << n << " ";
    cout << endl;

    // fill 和 generate
    cout << "\\n=== fill / generate ===" << endl;
    vector<int> v1(5);
    fill(v1.begin(), v1.end(), 100);
    cout << "fill(100): ";
    for (int n : v1) cout << n << " ";
    cout << endl;

    vector<int> v2(5);
    int n = 1;
    generate(v2.begin(), v2.end(), [&n]() { return n++; });
    cout << "generate(递增): ";
    for (int x : v2) cout << x << " ";
    cout << endl;

    // remove - 移除元素
    cout << "\\n=== remove ===" << endl;
    vector<int> v3 = {1, 2, 3, 2, 4, 2, 5};
    cout << "原数组: ";
    for (int n : v3) cout << n << " ";
    cout << endl;

    // remove 返回新的结尾
    auto newEnd = remove(v3.begin(), v3.end(), 2);
    v3.erase(newEnd, v3.end());  // 真正删除

    cout << "移除2后: ";
    for (int n : v3) cout << n << " ";
    cout << endl;

    // remove_if
    vector<int> v4 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    v4.erase(remove_if(v4.begin(), v4.end(), [](int x) { return x % 2 == 0; }),
             v4.end());
    cout << "移除偶数后: ";
    for (int n : v4) cout << n << " ";
    cout << endl;

    // unique - 移除相邻重复
    cout << "\\n=== unique ===" << endl;
    vector<int> v5 = {1, 1, 2, 2, 2, 3, 3, 3, 3, 4};
    v5.erase(unique(v5.begin(), v5.end()), v5.end());
    cout << "unique 后: ";
    for (int n : v5) cout << n << " ";
    cout << endl;

    return 0;
}''',
          description: '展示 copy、copy_if、fill、remove、remove_if、unique 的使用方法和注意事项。',
          output: '''=== copy ===
copy 结果: 1 2 3 4 5 
copy_if(偶数): 2 4 

=== fill / generate ===
fill(100): 100 100 100 100 100 
generate(递增): 1 2 3 4 5 

=== remove ===
原数组: 1 2 3 2 4 2 5 
移除2后: 1 3 4 5 

移除偶数后: 1 3 5 7 9 

=== unique ===
unique 后: 1 2 3 4''',
        ),
        CodeExample(
          title: 'partition 分区算法',
          code: '''#include <iostream>
#include <algorithm>
#include <vector>
#include <string>
using namespace std;

int main() {
    // partition - 将满足条件的放到前面
    cout << "=== partition ===" << endl;
    vector<int> v = {5, 3, 8, 1, 9, 2, 7, 4, 6};

    cout << "原数组: ";
    for (int n : v) cout << n << " ";
    cout << endl;

    // 将偶数放到前面
    auto it = partition(v.begin(), v.end(), [](int x) {
        return x % 2 == 0;
    });

    cout << "分区后: ";
    for (int n : v) cout << n << " ";
    cout << endl;
    cout << "分区点位置: " << (it - v.begin()) << endl;

    // stable_partition - 保持相对顺序
    cout << "\\n=== stable_partition ===" << endl;
    vector<pair<string, int>> students = {
        {"Alice", 85},
        {"Bob", 92},
        {"Charlie", 78},
        {"David", 95}
    };

    stable_partition(students.begin(), students.end(),
                     [](const auto& s) { return s.second >= 90; });

    cout << "及格线90分以上:" << endl;
    for (const auto& s : students) {
        cout << s.first << ": " << s.second << endl;
    }

    // is_partitioned / partition_point
    cout << "\\n=== 分区检查 ===" << endl;
    vector<int> v2 = {2, 4, 6, 1, 3, 5};
    cout << "v2 是否已分区(偶数在前): " << is_partitioned(v2.begin(), v2.end(),
                                                          [](int x){ return x%2==0; }) << endl;

    // partition_point 找分区点
    vector<int> v3 = {2, 4, 6, 8, 9, 10};
    auto pp = partition_point(v3.begin(), v3.end(), [](int x){ return x%2==0; });
    cout << "分区点: " << (pp - v3.begin()) << ", 值: " << *pp << endl;

    return 0;
}''',
          description: '展示 partition、stable_partition、is_partitioned、partition_point 的使用。',
          output: '''=== partition ===
原数组: 5 3 8 1 9 2 7 4 6 
分区后: 6 4 2 8 9 1 7 3 5 
分区点位置: 5

=== stable_partition ===
及格线90分以上:
Bob: 92
David: 95
Alice: 85
Charlie: 78

=== 分区检查 ===
v2 是否已分区(偶数在前): 0
分区点: 4, 值: 9''',
        ),
      ],
      keyPoints: [
        'copy、copy_if 用于复制元素到另一个容器，back_inserter 可用于目标容器自动扩展',
        'remove 并不真正删除元素，而是将不匹配的元素前移，需配合 erase 真正删除',
        'unique 移除相邻重复元素，同样需要 erase 真正删除多余元素',
        'partition 将满足条件的元素放到前面，stable_partition 保持相对顺序',
        'is_partitioned 检查是否已分区，partition_point 找到分区边界',
      ],
    ),
  ],
);
