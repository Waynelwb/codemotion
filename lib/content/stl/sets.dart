// Set 容器 - Set Container
import '../course_data.dart';

/// Set 容器章节
const chapterSets = CourseChapter(
  id: 'stl_sets',
  title: 'Set 容器',
  description: '学习 C++ STL 中 set 和 unordered_set 的使用，包括去重、查找和集合运算。',
  difficulty: DifficultyLevel.intermediate,
  lessons: [
    CourseLesson(
      id: 'stl_sets_basic',
      title: 'Set 基础操作',
      content: '''# Set 基础操作

## 什么是 Set？

`set` 是关联容器，用于存储唯一元素（不容纳重复元素）。

## set vs unordered_set

| 特性 | `set` | `unordered_set` |
|------|-------|-----------------|
| 底层结构 | 红黑树 | 哈希表 |
| 元素有序 | 是（升序） | 否 |
| 查找复杂度 | O(log n) | 平均 O(1) |
| 插入/删除 | O(log n) | 平均 O(1) |
| 有序遍历 | 支持 | 不支持 |

## 基本操作

| 操作 | 函数 | 说明 |
|------|------|------|
| 插入 | `s.insert(x)` | 插入元素 |
| 删除 | `s.erase(x)` | 删除元素 |
| 查找 | `s.find(x)` | 查找元素 |
| 判空 | `s.empty()` | 判断是否为空 |
| 大小 | `s.size()` | 返回元素个数 |
| 清空 | `s.clear()` | 清空所有元素 |

## multiset 和 unordered_multiset

- `multiset`：允许重复元素的有序集合
- `unordered_multiset`：允许重复元素的无序集合

## 使用场景

- **去重**：自动去除重复元素
- **查找**：快速判断元素是否存在
- **有序集合**：需要按顺序遍历时使用 set
- **集合运算**：交集、并集、差集等
''',
      codeExamples: [
        CodeExample(
          title: 'set 基本操作',
          code: '''#include <iostream>
#include <set>
#include <string>
using namespace std;

int main() {
    // 创建 set
    set<int> numbers;

    // insert - 插入元素
    numbers.insert(5);
    numbers.insert(2);
    numbers.insert(8);
    numbers.insert(2);  // 重复元素，不会插入
    numbers.insert(1);
    numbers.insert(9);

    cout << "=== set 内容 (自动排序) ===" << endl;
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    // 插入返回 pair<iterator, bool>
    auto result = numbers.insert(3);
    cout << "插入 3: " << (result.second ? "成功" : "失败") << endl;
    result = numbers.insert(3);  // 再次插入 3
    cout << "再次插入 3: " << (result.second ? "成功" : "失败") << endl;

    // find - 查找元素
    cout << "\\n=== find 查找 ===" << endl;
    auto it = numbers.find(8);
    if (it != numbers.end()) {
        cout << "找到: " << *it << endl;
    } else {
        cout << "未找到" << endl;
    }

    // count - 检查元素存在个数
    cout << "count(5): " << numbers.count(5) << endl;
    cout << "count(100): " << numbers.count(100) << endl;

    // erase - 删除元素
    numbers.erase(5);
    cout << "\\n删除 5 后: ";
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    // lower_bound / upper_bound
    cout << "\\n=== bound 操作 ===" << endl;
    set<int> s{1, 3, 5, 7, 9};
    auto lb = s.lower_bound(5);
    auto ub = s.upper_bound(5);
    cout << "lower_bound(5): " << *lb << endl;
    cout << "upper_bound(5): " << *ub << endl;

    return 0;
}''',
          description: '展示 set 的创建、插入（自动去重）、查找、删除和 bound 操作。',
          output: '''=== set 内容 (自动排序) ===
1 2 5 8 9 
插入 3: 成功
再次插入 3: 失败
找到: 8
count(5): 1
count(100): 0

删除 5 后: 1 2 3 8 9 

=== bound 操作 ===
lower_bound(5): 5
upper_bound(5): 7''',
        ),
        CodeExample(
          title: 'unordered_set 基础',
          code: '''#include <iostream>
#include <unordered_set>
using namespace std;

int main() {
    unordered_set<int> us;

    // 插入
    us.insert(10);
    us.insert(30);
    us.insert(20);
    us.insert(10);  // 重复

    cout << "=== unordered_set 内容 ===" << endl;
    // 遍历顺序不保证
    for (int n : us) {
        cout << n << " ";
    }
    cout << endl;

    cout << "大小: " << us.size() << endl;

    // find
    if (us.find(20) != us.end()) {
        cout << "找到 20" << endl;
    }

    // bucket 相关
    cout << "\\nbucket_count: " << us.bucket_count() << endl;
    cout << "max_bucket_count: " << us.max_bucket_count() << endl;

    // rehashing
    cout << "\\nrehash 后:" << endl;
    us.rehash(100);
    cout << "bucket_count: " << us.bucket_count() << endl;

    // load_factor
    cout << "load_factor: " << us.load_factor() << endl;
    cout << "max_load_factor: " << us.max_load_factor() << endl;

    return 0;
}''',
          description: '展示 unordered_set 的基本操作和哈希表相关参数（bucket_count、load_factor）。',
          output: '''=== unordered_set 内容 ===
10 20 30 
大小: 3
找到 20

bucket_count: 8
max_bucket_count: 2305843009213693951

rehash 后:
bucket_count: 128
load_factor: 0.0234375
max_load_factor: 1''',
        ),
      ],
      keyPoints: [
        'set 自动去除重复元素，并按升序排列',
        'set.insert() 返回 pair<iterator, bool>，可判断插入是否成功',
        'set.find() 找不到返回 end()，时间复杂度 O(log n)',
        'unordered_set 底层是哈希表，查找平均 O(1)，但不保证遍历顺序',
        'multiset 和 unordered_multiset 允许存储重复元素',
      ],
    ),
    CourseLesson(
      id: 'stl_sets_operations',
      title: '集合运算',
      content: '''# 集合运算

## STL 提供的集合算法

`<algorithm>` 库提供了以下集合运算：

| 运算 | 函数 | 说明 |
|------|------|------|
| 并集 | `set_union` | 合并两个集合 |
| 交集 | `set_intersection` | 两集合共同元素 |
| 差集 | `set_difference` | 属于 A 不属于 B |
| 对称差 | `set_symmetric_difference` | A∪B - A∩B |
| 包含 | `includes` | 判断是否包含 |

## 使用示例

```cpp
set<int> A = {1, 2, 3, 4};
set<int> B = {3, 4, 5, 6};
set<int> result;

// 并集
set_union(A.begin(), A.end(), B.begin(), B.end(),
           inserter(result, result.begin()));
// result: {1, 2, 3, 4, 5, 6}
```

## multiset 的特殊性

- `count()` 返回重复元素的个数
- `find()` 返回第一个匹配元素的迭代器
- 删除操作会删除所有匹配的元素
''',
      codeExamples: [
        CodeExample(
          title: '集合运算示例',
          code: '''#include <iostream>
#include <set>
#include <algorithm>
#include <iterator>
using namespace std;

void printSet(const string& label, const set<int>& s) {
    cout << label << ": ";
    for (int n : s) {
        cout << n << " ";
    }
    cout << endl;
}

int main() {
    set<int> A = {1, 2, 3, 4, 5};
    set<int> B = {4, 5, 6, 7, 8};

    printSet("集合 A", A);
    printSet("集合 B", B);

    // 并集 set_union
    set<int> unionSet;
    set_union(A.begin(), A.end(), B.begin(), B.end(),
              inserter(unionSet, unionSet.begin()));
    printSet("并集 A∪B", unionSet);

    // 交集 set_intersection
    set<int> interSet;
    set_intersection(A.begin(), A.end(), B.begin(), B.end(),
                     inserter(interSet, interSet.begin()));
    printSet("交集 A∩B", interSet);

    // 差集 set_difference (A-B)
    set<int> diffSet;
    set_difference(A.begin(), A.end(), B.begin(), B.end(),
                   inserter(diffSet, diffSet.begin()));
    printSet("差集 A-B", diffSet);

    // 对称差 set_symmetric_difference (A∪B - A∩B)
    set<int> symDiffSet;
    set_symmetric_difference(A.begin(), A.end(), B.begin(), B.end(),
                              inserter(symDiffSet, symDiffSet.begin()));
    printSet("对称差 A△B", symDiffSet);

    // includes - 判断包含关系
    set<int> C = {2, 3, 4};
    cout << "\\nincludes:" << endl;
    cout << "A 包含 C: " << includes(A.begin(), A.end(), C.begin(), C.end()) << endl;
    cout << "C 包含 A: " << includes(C.begin(), C.end(), A.begin(), A.end()) << endl;

    return 0;
}''',
          description: '展示 STL 集合算法：并集、交集、差集、对称差和 includes 判断。',
          output: '''集合 A: 1 2 3 4 5 
集合 B: 4 5 6 7 8 
并集 A∪B: 1 2 3 4 5 6 7 8 
交集 A∩B: 4 5 
差集 A-B: 1 2 3 
对称差 A△B: 1 2 3 6 7 8 
includes:
A 包含 C: 1
C 包含 A: 0''',
        ),
        CodeExample(
          title: 'multiset 示例',
          code: '''#include <iostream>
#include <set>
using namespace std;

int main() {
    multiset<int> ms;

    // 插入重复元素
    ms.insert(10);
    ms.insert(20);
    ms.insert(10);
    ms.insert(30);
    ms.insert(10);
    ms.insert(20);

    cout << "=== multiset 内容 ===" << endl;
    for (int n : ms) {
        cout << n << " ";
    }
    cout << endl;

    // count - 返回重复个数
    cout << "count(10): " << ms.count(10) << endl;
    cout << "count(20): " << ms.count(20) << endl;
    cout << "count(100): " << ms.count(100) << endl;

    // find - 返回第一个匹配的迭代器
    cout << "\\nfind(20): " << *ms.find(20) << endl;

    // equal_range - 返回所有匹配元素的范围
    cout << "equal_range(10):" << endl;
    auto range = ms.equal_range(10);
    for (auto it = range.first; it != range.second; it++) {
        cout << *it << " ";
    }
    cout << endl;

    // erase - 删除所有匹配元素
    ms.erase(10);
    cout << "删除所有 10 后: ";
    for (int n : ms) {
        cout << n << " ";
    }
    cout << endl;

    // erase - 删除单个迭代器指向的元素
    ms.erase(ms.find(20));  // 只删除一个 20
    cout << "删除一个 20 后: ";
    for (int n : ms) {
        cout << n << " ";
    }
    cout << endl;

    return 0;
}''',
          description: '展示 multiset 如何处理重复元素，以及 count、equal_range、erase 的使用。',
          output: '''=== multiset 内容 ===
10 10 10 20 20 30 
count(10): 3
count(20): 2
count(100): 0

find(20): 20
equal_range(10):
10 10 10 
删除所有 10 后: 20 20 30 
删除一个 20 后: 20 30''',
        ),
      ],
      keyPoints: [
        'set_union、set_intersection、set_difference、set_symmetric_difference 是 STL 提供的集合算法',
        '使用 inserter() 将结果插入到 set 中',
        'includes 用于判断一个集合是否完全包含另一个集合',
        'multiset 允许重复元素，count() 返回重复个数，erase(key) 删除所有匹配元素',
        'equal_range 返回 pair 表示所有匹配元素的范围',
      ],
    ),
  ],
);
