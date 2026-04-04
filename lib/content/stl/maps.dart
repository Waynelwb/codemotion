// ignore_for_file: unnecessary_string_escapes
// Map 容器 - Map Container
import '../course_data.dart';

/// Map 容器章节
const chapterMaps = CourseChapter(
  id: 'stl_maps',
  title: 'Map 容器',
  description: '学习 C++ STL 中 map 和 unordered_map 的使用，包括键值对操作、查找、遍历和性能特点。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.stl,
  lessons: [
    CourseLesson(
      id: 'stl_maps_basic',
      title: 'map 基础操作',
      content: '''# Map 基础操作

## 什么是 Map？

`map` 是关联容器，存储键值对（key-value pairs），每个键唯一，用于快速查找对应的值。

## map vs unordered_map

| 特性 | `map` | `unordered_map` |
|------|-------|-----------------|
| 底层结构 | 红黑树（平衡二叉搜索树） | 哈希表 |
| 键有序 | 是（按键升序） | 否 |
| 查找复杂度 | O(log n) | 平均 O(1) |
| 插入/删除 | O(log n) | 平均 O(1) |

## 基本操作

| 操作 | 函数 | 说明 |
|------|------|------|
| 插入 | `m[key] = value` 或 `m.insert({key, value})` | 添加键值对 |
| 访问 | `m[key]` 或 `m.at(key)` | 获取值 |
| 查找 | `m.find(key)` | 查找键，返回迭代器 |
| 删除 | `m.erase(key)` | 删除键值对 |
| 判空 | `m.empty()` | 判断是否为空 |
| 大小 | `m.size()` | 返回键值对个数 |

## 使用 [] 的注意事项

- `m[key]`：如果 key 不存在，会插入默认值
- `m.at(key)`：如果 key 不存在，抛 `out_of_range` 异常

## 何时使用哪种 map？

- 需要键有序 → `map`
- 追求极致性能 → `unordered_map`
- 一般情况优先选择 `unordered_map`
''',
      codeExamples: [
        CodeExample(
          title: 'map 基本操作',
          code: '''#include <iostream>
#include <map>
#include <string>
using namespace std;

int main() {
    // 创建 map (key: string, value: int)
    map<string, int> ages;

    // 插入方式1: 使用 []
    ages["Alice"] = 25;
    ages["Bob"] = 30;
    ages["Charlie"] = 35;

    // 插入方式2: insert
    ages.insert({"David", 28});
    ages.insert(make_pair("Eve", 22));

    // 插入方式3: emplace (C++11)
    ages.emplace("Frank", 40);

    cout << "=== map 内容 ===" << endl;
    for (auto it = ages.begin(); it != ages.end(); it++) {
        cout << it->first << ": " << it->second << endl;
    }

    cout << "\\n=== 访问元素 ===" << endl;
    cout << "Alice 的年龄: " << ages["Alice"] << endl;
    cout << "Bob 的年龄: " << ages.at("Bob") << endl;

    // 查找元素
    cout << "\\n=== 查找操作 ===" << endl;
    auto it = ages.find("Charlie");
    if (it != ages.end()) {
        cout << "找到: " << it->first << " = " << it->second << endl;
    } else {
        cout << "未找到 Charlie" << endl;
    }

    // [] vs at
    cout << "\n[] vs at:" << endl;
    cout << "ages[\"不存在\"] 会插入: " << ages["不存在"] << endl;
    // ages.at("也不存在");  // 这行会抛异常！

    // 删除
    ages.erase("Bob");
    cout << "\\n删除 Bob 后: ";
    for (auto [name, age] : ages) {
        cout << name << " ";
    }
    cout << endl;

    // 大小
    cout << "map 大小: " << ages.size() << endl;

    return 0;
}''',
          description: '展示 map 的创建、插入、访问、查找和删除操作，以及 [] 和 at 的区别。',
          output: '''=== map 内容 ===
Alice: 25
Bob: 30
Charlie: 35
David: 28
Eve: 22
Frank: 40

=== 访问元素 ===
Alice 的年龄: 25
Bob 的年龄: 30

=== 查找操作 ===
找到: Charlie = 35

=== [] vs at ===
ages["不存在"] 会插入: 0
不存在

删除 Bob 后: Alice Charlie David Eve Frank 
map 大小: 7''',
        ),
        CodeExample(
          title: 'unordered_map 基础',
          code: '''#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;

int main() {
    // 创建 unordered_map
    unordered_map<string, int> scores;

    // 插入
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    scores["Charlie"] = 92;
    scores["David"] = 78;

    cout << "=== unordered_map 内容 ===" << endl;
    // 注意：遍历顺序不保证有序
    for (const auto& [name, score] : scores) {
        cout << name << ": " << score << endl;
    }

    cout << "\\n=== find 查找 ===" << endl;
    string target = "Bob";
    auto it = scores.find(target);
    if (it != scores.end()) {
        cout << "找到 " << target << ": " << it->second << endl;
    } else {
        cout << "未找到 " << target << endl;
    }

    // count - 检查键是否存在
    cout << "\\n=== count 检查 ===" << endl;
    cout << "Alice 存在: " << scores.count("Alice") << endl;
    cout << "Eve 存在: " << scores.count("Eve") << endl;

    // unordered_map 的 bucket 相关
    cout << "\\n=== bucket 信息 ===" << endl;
    cout << "bucket count: " << scores.bucket_count() << endl;
    cout << "max bucket count: " << scores.max_bucket_count() << endl;

    // 按 bucket 遍历
    cout << "\\n按 bucket 遍历:" << endl;
    for (size_t i = 0; i < scores.bucket_count(); i++) {
        if (scores.bucket_size(i) > 0) {
            cout << "Bucket " << i << ": ";
            for (auto it = scores.begin(i); it != scores.end(i); it++) {
                cout << it->first << "=" << it->second << " ";
            }
            cout << endl;
        }
    }

    return 0;
}''',
          description: '展示 unordered_map 的基本操作、find/count 查找方法，以及 bucket 概念。',
          output: '''=== unordered_map 内容 ===
David: 78
Charlie: 92
Bob: 87
Alice: 95

=== find 查找 ===
找到 Bob: 87

=== count 检查 ===
Alice 存在: 1
Eve 存在: 0

=== bucket 信息 ===
bucket count: 8
max bucket count: 2305843009213693951

按 bucket 遍历:
Bucket 0: David=78 
Bucket 2: Charlie=92 
Bucket 3: Bob=87 
Bucket 7: Alice=95''',
        ),
      ],
      keyPoints: [
        'map 和 unordered_map 都是键值对容器，map 键有序，unordered_map 键无序',
        '[] 操作符会在键不存在时插入，at() 会抛异常',
        'find() 返回迭代器，count() 返回键存在的个数（0 或 1）',
        'unordered_map 平均查找复杂度 O(1)，map 是 O(log n)',
        '一般情况优先选择 unordered_map，追求有序时选择 map',
      ],
    ),
    CourseLesson(
      id: 'stl_maps_advanced',
      title: 'Map 遍历与 multimap',
      content: '''# Map 遍历与 multimap

## Map 遍历方式

```cpp
// 迭代器遍历
for (auto it = m.begin(); it != m.end(); it++) {
    cout << it->first << ": " << it->second << endl;
}

// C++17 结构化绑定
for (const auto& [key, value] : m) {
    cout << key << ": " << value << endl;
}

// 只遍历键或只遍历值
for (auto& key : |view::keys(m)) { ... }
for (auto& value : |view::values(m)) { ... }
```

## multimap

`multimap` 允许重复键，底层也是红黑树。

```cpp
multimap<string, int> mm;
mm.insert({"apple", 100});
mm.insert({"apple", 200});  // 允许重复键
mm.erase("apple");  // 删除所有 apple
```

## 自定义比较函数

```cpp
// 按字符串长度排序的 map
struct cmpByLen {
    bool operator()(const string& a, const string& b) const {
        return a.length() < b.length();
    }
};

map<string, int, cmpByLen> m;
```
''',
      codeExamples: [
        CodeExample(
          title: 'Map 遍历技巧',
          code: '''#include <iostream>
#include <map>
#include <string>
#include <vector>
using namespace std;

int main() {
    map<string, int> fruits{
        {"apple", 100},
        {"banana", 50},
        {"orange", 80},
        {"grape", 120}
    };

    cout << "=== 方式1: 迭代器遍历 ===" << endl;
    for (auto it = fruits.begin(); it != fruits.end(); it++) {
        cout << it->first << " -> " << it->second << endl;
    }

    cout << "\\n=== 方式2: C++17 结构化绑定 ===" << endl;
    for (const auto& [name, count] : fruits) {
        cout << name << " -> " << count << endl;
    }

    cout << "\\n=== 方式3: 反向遍历 ===" << endl;
    for (auto it = fruits.rbegin(); it != fruits.rend(); it++) {
        cout << it->first << " -> " << it->second << endl;
    }

    cout << "\\n=== 只遍历键 ===" << endl;
    vector<string> keys;
    for (const auto& [k, v] : fruits) {
        keys.push_back(k);
    }
    for (const string& k : keys) {
        cout << k << " ";
    }
    cout << endl;

    cout << "\\n=== lower_bound 和 upper_bound ===" << endl;
    // lower_bound: 第一个不小于 key 的迭代器
    // upper_bound: 第一个大于 key 的迭代器
    auto lb = fruits.lower_bound("orange");
    auto ub = fruits.upper_bound("orange");
    cout << "orange lower: " << lb->first << endl;
    cout << "orange upper: " << (ub != fruits.end() ? ub->first : "end") << endl;

    // 范围查找
    map<int, string> scores{
        {60, "D"}, {70, "C"}, {80, "B"}, {90, "A"}, {100, "A+"}
    };
    cout << "\\n=== 范围查找 (70-90) ===" << endl;
    auto start = scores.lower_bound(70);
    auto end = scores.upper_bound(90);
    for (auto it = start; it != end; it++) {
        cout << it->first << ": " << it->second << endl;
    }

    return 0;
}''',
          description: '展示 map 的多种遍历方式，以及 lower_bound、upper_bound 范围查找。',
          output: '''=== 方式1: 迭代器遍历 ===
apple -> 100
banana -> 50
orange -> 80
grape -> 120

=== 方式2: C++17 结构化绑定 ===
apple -> 100
banana -> 50
orange -> 80
grape -> 120

=== 方式3: 反向遍历 ===
grape -> 120
orange -> 80
banana -> 50
apple -> 100

=== 只遍历键 ===
apple banana orange grape 

=== lower_bound 和 upper_bound ===
orange lower: orange
orange upper: grape

=== 范围查找 (70-90) ===
70: C
80: B
90: A''',
        ),
        CodeExample(
          title: 'multimap 与自定义比较',
          code: '''#include <iostream>
#include <map>
#include <string>
using namespace std;

// 按字符串长度排序的比较器
struct cmpByLen {
    bool operator()(const string& a, const string& b) const {
        return a.length() < b.length();
    }
};

int main() {
    cout << "=== multimap (允许多个相同键) ===" << endl;
    multimap<string, int> phoneBook;

    phoneBook.insert({"Alice", 1111});
    phoneBook.insert({"Alice", 2222});  // 同一个键可以多个值
    phoneBook.insert({"Bob", 3333});
    phoneBook.insert({"Charlie", 4444});

    cout << "phoneBook 内容:" << endl;
    for (const auto& [name, phone] : phoneBook) {
        cout << name << ": " << phone << endl;
    }

    // 查找某个人的所有电话
    string searchName = "Alice";
    cout << "\\n" << searchName << " 的所有电话:" << endl;
    auto range = phoneBook.equal_range(searchName);
    for (auto it = range.first; it != range.second; it++) {
        cout << it->second << " ";
    }
    cout << endl;

    // 删除所有 Alice 的记录
    phoneBook.erase(searchName);
    cout << "删除 Alice 后大小: " << phoneBook.size() << endl;

    cout << "\\n=== 自定义比较 (按字符串长度排序) ===" << endl;
    map<string, int, cmpByLen> words{
        {"hi", 1},
        {"hello", 2},
        {"world", 3},
        {"a", 4}
    };

    for (const auto& [word, val] : words) {
        cout << word << " (len=" << word.length() << ") -> " << val << endl;
    }

    return 0;
}''',
          description: '展示 multimap 的使用（支持重复键）、equal_range 范围查找，以及自定义比较器。',
          output: '''=== multimap (允许多个相同键) ===
Alice: 1111
Alice: 2222
Bob: 3333
Charlie: 4444

Alice 的所有电话:
1111 2222 
删除 Alice 后大小: 2

=== 自定义比较 (按字符串长度排序) ===
a (len=1) -> 4
hi (len=2) -> 2
world (len=5) -> 3
hello (len=5) -> 3''',
        ),
      ],
      keyPoints: [
        'C++17 结构化绑定 `for (auto& [k, v] : m)` 使遍历更简洁',
        'lower_bound 返回第一个不小于 key 的迭代器，upper_bound 返回第一个大于 key 的迭代器',
        'multimap 允许重复键，equal_range 返回 pair<begin, end> 表示范围',
        '可以使用自定义比较器改变 map 的排序方式',
        'map.erase(key) 删除所有匹配键的元素',
      ],
    ),
  ],
);
