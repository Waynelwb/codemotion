// C++ 高级特性 - 智能指针 - Smart Pointers
import '../course_data.dart';

/// 智能指针章节
const chapterSmartPointers = CourseChapter(
  id: 'cpp_advanced_smart_pointers',
  title: 'C++ 智能指针',
  description: '学习 C++11/14/17 中的智能指针：unique_ptr、shared_ptr、weak_ptr，以及它们的使用场景。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.stl,
  lessons: [
    CourseLesson(
      id: 'cpp_smart_ptr_basics',
      title: '为什么要用智能指针',
      content: '''# 为什么要用智能指针？

## 内存管理的问题

C++ 中手动管理内存容易出错：

```cpp
void problemFunction() {
    int* p = new int[1000];
    // ... 使用 p ...
    if (someError) return;  // 内存泄漏！
    delete[] p;
}
```

常见问题：
- **内存泄漏**：忘记 delete
- **野指针**：delete 后继续使用
- **双重释放**：delete 两次
- **悬挂指针**：指向已释放的内存

## 智能指针简介

C++11 引入了智能指针，自动管理内存，再也不需要手动 delete：

| 类型 | 特点 | 独占/共享 |
|------|------|----------|
| `unique_ptr` | 独占所有权 | 独占 |
| `shared_ptr` | 引用计数 | 共享 |
| `weak_ptr` | 弱引用，不增加计数 | 配合 shared_ptr |

## 头文件

```cpp
#include <memory>
```

## unique_ptr

独占所有权的智能指针，同一时刻只能有一个指针拥有对象：

```cpp
#include <memory>

unique_ptr<int> p1(new int(42));
// p1 拥有这块内存

unique_ptr<int> p2 = p1;  // 错误！不能复制
unique_ptr<int> p3 = move(p1);  // 可以移动，p3 拥有，p1 变为空
```

## shared_ptr

共享所有权的智能指针，使用引用计数：

```cpp
shared_ptr<int> p1(new int(42));
cout << p1.use_count() << endl;  // 1

shared_ptr<int> p2 = p1;  // 共享所有权
cout << p1.use_count() << endl;  // 2

p2.reset();  // p2 释放所有权
cout << p1.use_count() << endl;  // 1
```

## weak_ptr

weak_ptr 不拥有对象，用来打破 shared_ptr 的循环引用：

```cpp
shared_ptr<int> p1(new int(42));
weak_ptr<int> w = p1;  // 不增加引用计数

if (auto lock = w.lock()) {
    cout << *lock << endl;  // 安全访问
}
```

## 智能指针 vs raw 指针

| 特性 | raw 指针 | unique_ptr | shared_ptr |
|------|----------|------------|------------|
| 自动释放 | ❌ | ✅ | ✅ |
| 复制所有权 | 可以 | ❌ | ✅ |
| 性能 | 最快 | 接近 raw | 略慢（引用计数） |
| 线程安全 | ❌ | ✅ | 部分 ✅ |
''',
      codeExamples: [
        CodeExample(
          title: 'unique_ptr 独占所有权',
          code: '''#include <iostream>
#include <memory>
#include <vector>
using namespace std;

// 示例：资源 RAII
class FileHandle {
    string filename;
public:
    FileHandle(const string& name) : filename(name) {
        cout << "打开文件: " << filename << endl;
    }
    ~FileHandle() {
        cout << "关闭文件: " << filename << endl;
    }
    void read() { cout << "读取 " << filename << endl; }
};

// 工厂函数返回 unique_ptr
unique_ptr<int> createValue(int val) {
    return unique_ptr<int>(new int(val));
}

int main() {
    cout << "=== unique_ptr 基础 ===" << endl;

    // 创建 unique_ptr
    unique_ptr<int> p1(new int(42));
    cout << "*p1 = " << *p1 << endl;

    // 使用 make_unique (C++14 推荐)
    auto p2 = make_unique<int>(100);
    cout << "*p2 = " << *p2 << endl;

    // unique_ptr 数组
    auto arr = make_unique<int[]>(5);
    for (int i = 0; i < 5; i++) arr[i] = i * i;
    cout << "数组: ";
    for (int i = 0; i < 5; i++) cout << arr[i] << " ";
    cout << endl;

    // 不能复制，只能移动
    unique_ptr<int> p3 = p2;  // 编译错误！
    unique_ptr<int> p4 = move(p2);
    cout << "*p4 = " << *p4 << endl;
    // cout << "*p2 = " << *p2 << endl;  // p2 已为空！

    // reset - 释放原有对象
    p4.reset();
    cout << "p4 reset 后为空: " << (p4 == nullptr) << endl;

    // release - 放弃所有权，返回 raw 指针
    unique_ptr<int> p5 = make_unique<int>(999);
    int* raw = p5.release();
    cout << "release raw: " << *raw << endl;
    delete raw;  // 手动管理，但不再智能

    cout << "\\n=== unique_ptr 自动析构 ===" << endl;
    {
        unique_ptr<FileHandle> f = make_unique<FileHandle>("test.txt");
        f->read();
        cout << "退出作用域前..." << endl;
    }
    cout << "退出作用域后，文件已自动关闭" << endl;

    cout << "\\n=== 工厂函数返回 unique_ptr ===" << endl;
    auto val = createValue(42);
    cout << "工厂创建: " << *val << endl;

    cout << "\\n=== unique_ptr 作为函数参数 ===" << endl;

    // 按值传参会转移所有权
    auto takeOwnership = [](unique_ptr<int> p) {
        cout << "接收所有权: " << *p << endl;
    };

    auto ptr = make_unique<int>(123);
    takeOwnership(move(ptr));
    // cout << *ptr << endl;  // ptr 已为空！

    // 按引用传参不转移所有权
    auto useReference = [](const unique_ptr<int>& p) {
        cout << "借用: " << *p << endl;
    };
    auto ptr2 = make_unique<int>(456);
    useReference(ptr2);
    cout << "仍然拥有: " << *ptr2 << endl;

    return 0;
}''',
          description: '展示 unique_ptr 的独占所有权、make_unique、自动析构、移动语义和作为函数参数。',
          output: '''=== unique_ptr 基础 ===
*p1 = 42
*p2 = 100
数组: 0 1 4 9 16 
*p4 = 100
p4 reset 后为空: 1

=== unique_ptr 自动析构 ===
打开文件: test.txt
读取 test.txt
退出作用域前...
关闭文件: test.txt
退出作用域后，文件已自动关闭

=== 工厂函数返回 unique_ptr ===
工厂创建: 42

=== unique_ptr 作为函数参数 ===
接收所有权: 123
借用: 456
仍然拥有: 456''',
        ),
        CodeExample(
          title: 'shared_ptr 共享所有权',
          code: '''#include <iostream>
#include <memory>
#include <vector>
using namespace std;

int main() {
    cout << "=== shared_ptr 基础 ===" << endl;

    // 创建 shared_ptr
    shared_ptr<int> p1(new int(42));
    cout << "p1 use_count: " << p1.use_count() << endl;

    // 使用 make_shared (推荐，更高效)
    auto p2 = make_shared<int>(100);
    cout << "p2 use_count: " << p2.use_count() << endl;

    // 复制 shared_ptr - 共享所有权
    shared_ptr<int> p3 = p2;
    cout << "复制后 p2: " << p2.use_count() << endl;
    cout << "复制后 p3: " << p3.use_count() << endl;

    // 引用计数演示
    cout << "\\n=== 引用计数变化 ===" << endl;
    auto showCount = [](const shared_ptr<int>& p, const string& name) {
        cout << name << " use_count: " << p.use_count() << endl;
    };

    {
        shared_ptr<int> sp = make_shared<int>(42);
        showCount(sp, "创建");

        shared_ptr<int> sp2 = sp;
        showCount(sp, "sp2=sp");
        showCount(sp2, "sp2");

        {
            shared_ptr<int> sp3 = sp;
            showCount(sp, "sp3=sp");
        }
        showCount(sp, "sp3 销毁");

        sp.reset();
        showCount(sp, "sp reset");
    }

    cout << "\\n=== shared_ptr 用于容器 ===" << endl;
    vector<shared_ptr<int>> vec;

    for (int i = 1; i <= 3; i++) {
        vec.push_back(make_shared<int>(i * 10));
    }

    cout << "vec 内容: ";
    for (auto sp : vec) cout << *sp << " ";
    cout << endl;

    // 共享同一个对象
    shared_ptr<int> sp1 = make_shared<int>(999);
    vec[0] = sp1;
    vec[1] = sp1;
    vec[2] = sp1;

    cout << "共享后 sp1 count: " << sp1.use_count() << endl;
    cout << "vec 全部指向: " << *vec[0] << endl;

    cout << "\\n=== shared_ptr 常见错误 ===" << endl;

    // 错误：用 raw pointer 创建多个 shared_ptr
    int* raw = new int(42);
    shared_ptr<int> sp_a(raw);
    shared_ptr<int> sp_b(raw);  // 危险！两个独立的 shared_ptr 都会 delete 同一块内存
    cout << "sp_a count: " << sp_a.use_count() << endl;  // 1
    cout << "sp_b count: " << sp_b.use_count() << endl;  // 1（各自独立！）

    // 正确：用 make_shared 或复制
    shared_ptr<int> sp_c = make_shared<int>(42);
    shared_ptr<int> sp_d = sp_c;  // 正确，复制 shared_ptr

    cout << "sp_c count: " << sp_c.use_count() << endl;  // 2

    cout << "\\n=== shared_ptr 转换 ===" << endl;

    // shared_ptr<int> 转 shared_ptr<double>
    shared_ptr<int> sp_int = make_shared<int>(42);
    // 不能直接转换，需要自定义转换
    auto sp_double = static_pointer_cast<double>(sp_int);
    cout << "sp_int: " << *sp_int << endl;
    cout << "sp_double: " << *sp_double << endl;

    return 0;
}''',
          description: '展示 shared_ptr 的引用计数、make_shared、容器使用和常见错误。',
          output: '''=== shared_ptr 基础 ===
p1 use_count: 1
p2 use_count: 1
复制后 p2: 2
复制后 p3: 2

=== 引用计数变化 ===
创建 use_count: 1
sp2=sp use_count: 2
sp2 use_count: 2
sp3=sp use_count: 3
sp3 销毁 use_count: 2
sp reset use_count: 1

=== shared_ptr 用于容器 ===
vec 内容: 10 20 30 
共享后 sp1 count: 3
vec 全部指向: 999

=== shared_ptr 常见错误 ===
sp_a count: 1
sp_b count: 1
sp_c count: 2

=== shared_ptr 转换 ===
sp_int: 42
sp_double: 42''',
        ),
      ],
      keyPoints: [
        '智能指针自动管理内存，在作用域结束时自动调用 delete，避免内存泄漏',
        'unique_ptr 独占所有权，不能复制只能移动，同一时刻只有一个指针持有对象',
        'make_unique 和 make_shared 是创建智能指针的推荐方式，比直接 new 更安全高效',
        'shared_ptr 通过引用计数共享所有权，use_count() 查看引用计数，为 0 时自动释放',
        '不要用同一个 raw 指针创建多个 shared_ptr，这会导致双重释放',
      ],
    ),

    CourseLesson(
      id: 'cpp_smart_ptr_advanced',
      title: 'weak_ptr 与循环引用',
      content: '''# weak_ptr 与循环引用

## 什么是循环引用？

当两个 shared_ptr 互相引用时，引用计数永远不会归零，导致内存泄漏：

```cpp
class B;  // 前向声明

class A {
public:
    shared_ptr<B> b;
};

class B {
public:
    shared_ptr<A> a;
};

auto pa = make_shared<A>();
auto pb = make_shared<B>();

pa->b = pb;  // pb 引用计数 +1
pb->a = pa;  // pa 引用计数 +1

// 销毁 pa 和 pb
// pa 和 pb 引用计数都是 1，永远不会释放！
```

## weak_ptr 解决方案

`weak_ptr` 不拥有对象，只是"观察"shared_ptr，不增加引用计数：

```cpp
weak_ptr<int> wp = sp;  // wp 不拥有对象，sp 引用计数不变

// 安全访问 weak_ptr
if (auto lock = wp.lock()) {  // lock() 返回 shared_ptr 或空
    // lock() 不为空，对象还存在
    cout << *lock << endl;
} else {
    // 对象已被销毁
}
```

## weak_ptr 的用途

1. **打破循环引用**：Tree/Graph 节点
2. **观察者模式**：observer 持有 weak_ptr
3. **缓存**：缓存 shared_ptr 对象
4. **防止 shared_ptr 重复**：避免同一个对象被 shared_ptr 多次持有

## weak_ptr API

```cpp
weak_ptr<T> wp;

// 检查对象是否还存在
wp.expired();  // true 如果已销毁

// 获取 shared_ptr（如果对象还存在）
wp.lock();    // 返回 shared_ptr 或空

// 强制获取（不推荐，可能 expired）
wp.use_count();  // 返回引用计数
```

## 循环引用示例与修复

```cpp
class Node {
public:
    string name;
    weak_ptr<Node> parent;  // 改为 weak_ptr！
    vector<shared_ptr<Node>> children;

    Node(const string& n) : name(n) {}
};

int main() {
    auto root = make_shared<Node>("root");
    auto child = make_shared<Node>("child");

    root->children.push_back(child);
    child->parent = root;  // root 引用计数不变

    // 正常析构
    return 0;
}
```

## 自定义删除器

智能指针默认用 `delete` 释放内存，但可以指定自定义删除器：

```cpp
// 文件删除器
auto fileDeleter = [](FILE* f) {
    if (f) fclose(f);
};

unique_ptr<FILE, decltype(fileDeleter)> 
    fp(fopen("test.txt", "w"), fileDeleter);

// 数组删除器
unique_ptr<int[]> arr(new int[100]);  // C++14
unique_ptr<int, function<void(int*)>> 
    arr2(new int[100], [](int* p) { delete[] p; });
```

## enable_shared_from_this

当类需要返回自己的 shared_ptr 时，继承 `enable_shared_from_this`：

```cpp
#include <memory>

class Good : public enable_shared_from_this<Good> {
public:
    shared_ptr<Good> getShared() {
        return shared_from_this();  // 返回正确的 shared_ptr
    }
};

// 错误做法
class Bad {
    shared_ptr<Bad> getShared() {
        return shared_ptr<Bad>(this);  // 危险！两个独立的 shared_ptr
    }
};
```

## 智能指针选择指南

| 场景 | 推荐指针 |
|------|----------|
| 独占资源（文件、锁） | `unique_ptr` |
| 对象需多方共享 | `shared_ptr` |
| 打破 shared_ptr 循环引用 | `weak_ptr` |
| 需要返回 this | 继承 `enable_shared_from_this` |
| 工厂函数返回值 | `unique_ptr` |
| STL 容器元素 | `shared_ptr` 或 `unique_ptr` |

## 性能注意事项

1. **unique_ptr 性能接近 raw 指针**
2. **shared_ptr 有引用计数的开销**：原子操作保证线程安全
3. **weak_ptr 本身很轻量**：只是观察，不增加计数
4. **make_shared 比 new 更高效**：一次分配对象和控制块
5. **避免循环引用**：及时使用 weak_ptr
''',
      codeExamples: [
        CodeExample(
          title: 'weak_ptr 打破循环引用',
          code: '''#include <iostream>
#include <memory>
#include <vector>
using namespace std;

// Tree 节点 - 使用 weak_ptr 打破循环引用
class TreeNode {
public:
    string name;
    weak_ptr<TreeNode> parent;  // 关键：使用 weak_ptr！
    vector<shared_ptr<TreeNode>> children;

    TreeNode(const string& n) : name(n) {}

    void addChild(shared_ptr<TreeNode> child) {
        children.push_back(child);
        child->parent = weak_ptr<TreeNode>(shared_from_this());
    }

    void print(int depth = 0) {
        for (int i = 0; i < depth; i++) cout << "  ";
        cout << name << endl;
        for (auto& child : children) {
            child->print(depth + 1);
        }
    }
};

int main() {
    cout << "=== Tree 结构（weak_ptr 打破循环）===" << endl;

    auto root = make_shared<TreeNode>("root");
    auto child1 = make_shared<TreeNode>("child1");
    auto child2 = make_shared<TreeNode>("child2");
    auto grandchild = make_shared<TreeNode>("grandchild");

    root->addChild(child1);
    root->addChild(child2);
    child1->addChild(grandchild);

    root->print();

    cout << "\\n=== 引用计数分析 ===" << endl;
    cout << "root use_count: " << root.use_count() << endl;
    cout << "child1 use_count: " << child1.use_count() << endl;
    cout << "grandchild parent.expired: " << grandchild->parent.expired() << endl;

    cout << "\\n=== weak_ptr 安全访问 ===" << endl;

    auto sp = make_shared<int>(42);
    weak_ptr<int> wp = sp;

    cout << "sp use_count: " << sp.use_count() << endl;
    cout << "wp.expired: " << wp.expired() << endl;

    if (auto lock = wp.lock()) {
        cout << "wp.lock() 成功: " << *lock << endl;
    }

    sp.reset();  // 销毁对象

    cout << "sp.reset() 后:" << endl;
    cout << "wp.expired: " << wp.expired() << endl;

    if (auto lock = wp.lock()) {
        cout << "wp.lock() 成功: " << *lock << endl;
    } else {
        cout << "wp.lock() 返回空（对象已销毁）" << endl;
    }

    cout << "\\n=== 观察者模式示例 ===" << endl;

    class Observer;
    class Subject {
        vector<weak_ptr<Observer>> observers;
    public:
        void addObserver(shared_ptr<Observer> o);
        void notify();
    };

    class Observer {
    public:
        string name;
        Observer(const string& n) : name(n) {}
        void update() { cout << name << " 收到通知!" << endl; }
    };

    // 简化实现
    vector<shared_ptr<Observer>> observerList;
    auto obs1 = make_shared<Observer>("观察者1");
    auto obs2 = make_shared<Observer>("观察者2");
    observerList.push_back(obs1);
    observerList.push_back(obs2);

    cout << "通知所有观察者:" << endl;
    for (auto& obs : observerList) {
        if (!obs.expired()) {
            obs.lock()->update();
        }
    }

    obs1.reset();  // 模拟销毁
    cout << "obs1 销毁后:" << endl;
    for (auto& obs : observerList) {
        if (!obs.expired()) {
            obs.lock()->update();
        } else {
            cout << "观察者已销毁，跳过" << endl;
        }
    }

    return 0;
}''',
          description: '展示使用 weak_ptr 打破 Tree 节点的循环引用，以及 weak_ptr 的安全访问机制。',
          output: '''=== Tree 结构（weak_ptr 打破循环）===
root
  child1
    grandchild
  child2

=== 引用计数分析 ===
root use_count: 1
child1 use_count: 1
grandchild parent.expired: 0

=== weak_ptr 安全访问 ===
sp use_count: 1
wp.expired: 0
wp.lock() 成功: 42
sp.reset() 后:
wp.expired: 1
wp.lock() 返回空（对象已销毁）

=== 观察者模式示例 ===
通知所有观察者:
观察者1 收到通知!
观察者2 收到通知!
obs1 销毁后:
观察者已销毁，跳过
观察者2 收到通知!''',
        ),
        CodeExample(
          title: '自定义删除器与 enable_shared_from_this',
          code: '''#include <iostream>
#include <memory>
#include <functional>
using namespace std;

cout << "=== 自定义删除器 ===" << endl;

// 假设 FILE 是某种文件类型，这里用 struct 模拟
struct FakeFile {
    string name;
    FakeFile(const string& n) : name(n) { cout << "打开 " << name << endl; }
    void close() { cout << "关闭 " << name << endl; }
};

// 自定义删除器
auto fileDeleter = [](FakeFile* f) {
    f->close();
    delete f;
};

void testFileDeleter() {
    // 方式1: unique_ptr + 自定义删除器
    unique_ptr<FakeFile, decltype(fileDeleter)> 
        f1(new FakeFile("a.txt"), fileDeleter);

    // 方式2: 使用 function 作为删除器
    function<void(FakeFile*)> del = [](FakeFile* f) {
        f->close();
        delete f;
    };
    unique_ptr<FakeFile, function<void(FakeFile*)>> 
        f2(new FakeFile("b.txt"), del);
}

int main() {
    testFileDeleter();

    cout << "\\n=== 数组 unique_ptr ===" << endl;

    // C++14: make_unique<int[]>(n)
    auto intArr = make_unique<int[]>(5);
    for (int i = 0; i < 5; i++) intArr[i] = i * i;

    cout << "数组内容: ";
    for (int i = 0; i < 5; i++) cout << intArr[i] << " ";
    cout << endl;

    // C++17 可以 unique_ptr<int[]>
    unique_ptr<int[]> arr = make_unique<int[]>(5);

    cout << "\\n=== shared_ptr 数组 ===" << endl;

    // shared_ptr 也可以用于数组（但 C++20 前需要自定义删除器）
    shared_ptr<int[]> shArr(new int[5], [](int* p) { delete[] p; });
    for (int i = 0; i < 5; i++) shArr[i] = i;
    cout << "shared_ptr 数组: ";
    for (int i = 0; i < 5; i++) cout << shArr[i] << " ";
    cout << endl;

    cout << "\\n=== enable_shared_from_this ===" << endl;

    // 正确：继承 enable_shared_from_this
    class Good : public enable_shared_from_this<Good> {
    public:
        string name;
        Good(const string& n) : name(n) {}

        shared_ptr<Good> getptr() {
            return shared_from_this();  // 返回正确的 shared_ptr
        }

        void introduce() {
            cout << "我是 " << name << endl;
        }
    };

    auto g = make_shared<Good>("Good Object");
    auto g2 = g->getptr();

    cout << "g use_count: " << g.use_count() << endl;  // 2
    g->introduce();
    g2->introduce();

    // 错误做法
    class Bad : public std::enable_shared_from_this<Bad> {
    public:
        string name;
        Bad(const string& n) : name(n) {}

        shared_ptr<Bad> getptr() {
            return shared_ptr<Bad>(this);  // 危险！
        }
    };

    auto bad1 = make_shared<Bad>("Bad Object 1");
    auto bad2 = bad1->getptr();  // 运行时错误！bad1 和 bad2 独立，控制块冲突

    return 0;
}''',
          description: '展示自定义删除器、数组 unique_ptr 和 enable_shared_from_this 的正确用法。',
          output: '''=== 自定义删除器 ===
打开 a.txt
关闭 a.txt
打开 b.txt
关闭 b.txt

=== 数组 unique_ptr ===
数组内容: 0 1 4 9 16 

=== shared_ptr 数组 ===
shared_ptr 数组: 0 1 2 3 4 

=== enable_shared_from_this ===
g use_count: 2
我是 Good Object
我是 Good Object''',
        ),
      ],
      keyPoints: [
        'weak_ptr 不拥有对象，不增加 shared_ptr 的引用计数，用于打破循环引用',
        '循环引用（两个 shared_ptr 互相引用）会导致引用计数永远不为 0，造成内存泄漏',
        'weak_ptr 用 .lock() 安全访问对象，如果对象已销毁返回空的 shared_ptr',
        'enable_shared_from_this 用于类需要返回自己的 shared_ptr，继承它并使用 shared_from_this()',
        '自定义删除器允许智能指针管理非 new 的资源（文件、数组等），通过 unique_ptr<FILE, del> 使用',
      ],
    ),
  ],
);
