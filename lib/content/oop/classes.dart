// 类与对象 - Classes and Objects
import '../course_data.dart';

/// 类与对象章节
const chapterClasses = CourseChapter(
  id: 'oop_classes',
  title: '类与对象',
  description: '学习 C++ 中面向对象编程的核心概念：类的定义、对象的创建、构造函数和成员函数。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.oop,
  lessons: [
    CourseLesson(
      id: 'oop_classes_definition',
      title: '类的定义与对象创建',
      content: '''# 类的定义与对象创建

## 类 (Class) 的概念

类是一种用户自定义的数据类型，用于封装数据和操作数据的函数。

## 类的组成

```cpp
class 类名 {
public:           // 公有成员
    // 构造函数
    类名(参数);

    // 公有成员函数
    void method();

    // 公有数据成员
    int publicData;
private:          // 私有成员
    // 私有数据成员
    int privateData;

    // 私有成员函数
    void helper();
};
```

## 访问控制

| 关键字 | 访问权限 |
|--------|----------|
| `public` | 公有成员，类内外部都可访问 |
| `private` | 私有成员，只有类内成员函数可访问 |
| `protected` | 受保护成员，类和派生类可访问 |

## 对象的创建

```cpp
// 在栈上创建
ClassName obj;

// 在堆上创建
ClassName* ptr = new ClassName();
delete ptr;  // 记得释放内存
```

## 成员访问

```cpp
obj.publicMember;           // 对象访问成员
ptr->publicMember;          // 指针访问成员
```
''',
      codeExamples: [
        CodeExample(
          title: '简单的类定义',
          code: '''#include <iostream>
#include <string>
using namespace std;

// 定义学生类
class Student {
public:
    // 公有成员函数
    void setInfo(const string& name, int age, double score) {
        this->name = name;
        this->age = age;
        this->score = score;
    }

    void display() {
        cout << "姓名: " << name << endl;
        cout << "年龄: " << age << endl;
        cout << "成绩: " << score << endl;
    }

    // 判断是否及格
    bool isPassing() const {
        return score >= 60.0;
    }

    // 获取信息（getter）
    string getName() const { return name; }
    int getAge() const { return age; }
    double getScore() const { return score; }

private:
    // 私有数据成员
    string name;
    int age;
    double score;
};

int main() {
    // 在栈上创建对象
    Student s1;
    s1.setInfo("张三", 20, 85.5);
    cout << "学生 1:" << endl;
    s1.display();
    cout << "及格: " << (s1.isPassing() ? "是" : "否") << endl;

    cout << endl;

    // 再次创建并使用
    Student s2;
    s2.setInfo("李四", 22, 55.0);
    cout << "学生 2:" << endl;
    s2.display();
    cout << "及格: " << (s2.isPassing() ? "是" : "否") << endl;

    // 在堆上创建对象
    cout << endl << "堆上创建对象:" << endl;
    Student* s3 = new Student();
    s3->setInfo("王五", 19, 92.0);
    s3->display();
    delete s3;  // 释放内存

    return 0;
}''',
          description: '展示类的基本定义，包括公有成员函数和私有数据成员，以及栈和堆上创建对象的区别。',
          output: '''学生 1:
姓名: 张三
年龄: 20
成绩: 85.5
及格: 是

学生 2:
姓名: 李四
年龄: 22
成绩: 55
及格: 否

堆上创建对象:
姓名: 王五
年龄: 19
成绩: 92
及格: 是''',
        ),
        CodeExample(
          title: 'this 指针与 const 成员函数',
          code: '''#include <iostream>
#include <string>
using namespace std;

class Point {
private:
    double x;
    double y;

public:
    // 构造函数
    Point(double x = 0, double y = 0) {
        this->x = x;  // 使用 this 指针区分成员和参数
        this->y = y;
    }

    // 设置坐标
    void setXY(double x, double y) {
        this->x = x;
        this->y = y;
    }

    // 获取坐标 (const 成员函数 - 不会修改对象)
    double getX() const {
        // x = 10;  // 错误！const 成员函数不能修改成员
        return x;
    }

    double getY() const {
        return y;
    }

    // 计算到原点的距离
    double distanceToOrigin() const {
        return sqrt(x * x + y * y);
    }

    // 计算到另一点的距离
    double distanceTo(const Point& other) const {
        double dx = this->x - other.x;
        double dy = this->y - other.y;
        return sqrt(dx * dx + dy * dy);
    }

    // 打印点信息
    void print() const {
        cout << "(" << x << ", " << y << ")";
    }
};

int main() {
    Point p1(3.0, 4.0);
    Point p2(0.0, 0.0);
    Point p3(6.0, 8.0);

    cout << "点 p1: ";
    p1.print();
    cout << endl;

    cout << "p1 到原点距离: " << p1.distanceToOrigin() << endl;
    cout << "p1 到 p3 距离: " << p1.distanceTo(p3) << endl;

    // const 对象只能调用 const 成员函数
    const Point p4(5, 12);
    cout << "const 点 p4: ";
    p4.print();
    cout << endl;
    cout << "p4 到原点距离: " << p4.distanceToOrigin() << endl;

    // 链式调用演示 (返回引用)
    Point p5;
    p5.setXY(1, 2).setXY(3, 4);  // 如果 setXY 返回 *this
    // 注意：上面的调用假设 setXY 返回 Point&
    p5.print();
    cout << endl;

    return 0;
}''',
          description: '演示 this 指针的使用、const 成员函数的意义，以及 getter 函数的设计。',
          output: '''点 p1: (3, 4)
p1 到原点距离: 5
p1 到 p3 距离: 3
const 点 p4: (5, 12)
p4 到原点距离: 13
(3, 4)''',
        ),
      ],
      keyPoints: [
        '类通过 public/private/protected 控制成员访问权限',
        'private 成员只能在类内部访问，public 成员可以在类外部访问',
        'this 指针指向当前对象，用于区分成员变量和同名参数',
        'const 成员函数承诺不会修改对象，const 对象只能调用 const 成员函数',
        '在堆上创建的对象使用完后必须 delete 释放内存',
      ],
    ),

    CourseLesson(
      id: 'oop_classes_constructors',
      title: '构造函数与析构函数',
      content: '''# 构造函数与析构函数

## 构造函数 (Constructor)

特殊成员函数，在创建对象时自动调用，用于初始化对象。

### 特点
- 函数名与类名相同
- 没有返回类型
- 对象创建时自动调用

### 分类

1. **默认构造函数**：无参数
2. **带参构造函数**：有参数
3. **拷贝构造函数**：以同类对象为参数
4. **委托构造函数** (C++11)：调用其他构造函数
5. **移动构造函数** (C++11)：移动而非拷贝

## 初始化列表 (Initializer List)

```cpp
class A {
    int x;
    double y;
public:
    A() : x(0), y(0.0) {}  // 初始化列表
    A(int x, double y) : x(x), y(y) {}
};
```

**注意**：const 成员和引用成员必须在初始化列表中初始化。

## 析构函数 (Destructor)

在对象销毁时自动调用，用于清理资源。

```cpp
~类名() {
    // 清理代码
}
```

- 函数名前加 `~`
- 没有返回类型和参数
- 一个类只能有一个析构函数

## 拷贝构造函数调用时机

1. 用一个对象初始化另一个对象：`A b(a);`
2. 函数参数传递（按值传递）：`void f(A a)`
3. 函数返回值（按值返回）

## 深拷贝 vs 浅拷贝

- **浅拷贝**：简单复制成员值（指针只复制地址）
- **深拷贝**：复制指针指向的内容（需要自定义拷贝构造函数）
''',
      codeExamples: [
        CodeExample(
          title: '构造函数详解',
          code: '''#include <iostream>
#include <string>
#include <cstring>
using namespace std;

class String {
private:
    char* data;
    size_t length;

public:
    // 默认构造函数
    String() : data(nullptr), length(0) {
        cout << "默认构造函数" << endl;
    }

    // 带参构造函数
    String(const char* str) {
        cout << "带参构造函数" << endl;
        length = strlen(str);
        data = new char[length + 1];
        strcpy(data, str);
    }

    // 拷贝构造函数 (深拷贝)
    String(const String& other) {
        cout << "拷贝构造函数" << endl;
        length = other.length;
        data = new char[length + 1];
        strcpy(data, other.data);
    }

    // 移动构造函数 (C++11)
    String(String&& other) noexcept {
        cout << "移动构造函数" << endl;
        data = other.data;
        length = other.length;
        other.data = nullptr;  // 避免析构时删除
        other.length = 0;
    }

    // 赋值运算符
    String& operator=(const String& other) {
        cout << "赋值运算符" << endl;
        if (this != &other) {  // 防止自我赋值
            delete[] data;
            length = other.length;
            data = new char[length + 1];
            strcpy(data, other.data);
        }
        return *this;
    }

    // 析构函数
    ~String() {
        cout << "析构函数" << endl;
        delete[] data;
    }

    void print() const {
        if (data) cout << data;
        else cout << "(空)";
    }
};

int main() {
    cout << "1. 默认构造:" << endl;
    String s1;

    cout << "\\n2. 带参构造:" << endl;
    String s2("Hello");

    cout << "\\n3. 拷贝构造:" << endl;
    String s3(s2);

    cout << "\\n4. 移动构造:" << endl;
    String s4(String("World"));  // 临时对象，移动构造

    cout << "\\n5. 赋值运算:" << endl;
    s1 = s2;

    cout << "\\n6. 打印结果:" << endl;
    cout << "s2: "; s2.print(); cout << endl;
    cout << "s3: "; s3.print(); cout << endl;
    cout << "s4: "; s4.print(); cout << endl;
    cout << "s1: "; s1.print(); cout << endl;

    cout << "\\n7. 函数返回前:" << endl;
    return 0;
}''',
          description: '展示构造函数、拷贝构造函数、移动构造函数、赋值运算符和析构函数的调用时机。',
          output: '''1. 默认构造:
默认构造函数

2. 带参构造:
带参构造函数

3. 拷贝构造:
拷贝构造函数

4. 移动构造:
带参构造函数
移动构造函数

5. 赋值运算:
赋值运算符

6. 打印结果:
s2: Hello
s3: Hello
s4: World
s1: Hello

7. 函数返回前:
析构函数 (s4)
析构函数 (s3)
析构函数 (s1)
析构函数 (s2)''',
        ),
        CodeExample(
          title: '初始化列表与委托构造',
          code: '''#include <iostream>
#include <string>
using namespace std;

class Person {
private:
    const string name;
    int age;
    int& refAge;  // 引用成员必须在初始化列表初始化

public:
    // 使用初始化列表初始化常引用成员
    Person(const string& n, int& ageRef)
        : name(n), age(0), refAge(ageRef) {
        refAge = 0;
        cout << "Person(name, ageRef) 构造" << endl;
    }

    // 委托构造函数 (C++11) - 委托给上面的构造函数
    Person(const string& name)
        : Person(name, age) {  // 必须放在初始化列表第一项
        cout << "Person(name) 委托构造" << endl;
    }

    // 默认构造函数委托
    Person()
        : Person("匿名") {
        cout << "Person() 委托构造" << endl;
    }

    void display() const {
        cout << "姓名: " << name << ", 年龄: " << age << endl;
    }
};

class Rectangle {
private:
    double width;
    double height;

public:
    // 多成员初始化列表
    Rectangle()
        : width(0.0), height(0.0) {
        cout << "Rectangle 默认构造: " << width << "x" << height << endl;
    }

    Rectangle(double w, double h)
        : width(w), height(h) {
        cout << "Rectangle 带参构造: " << width << "x" << height << endl;
    }

    // 单参数构造建议使用 explicit 防止隐式转换
    explicit Rectangle(double size)
        : width(size), height(size) {
        cout << "Rectangle 正方形: " << width << "x" << height << endl;
    }

    double area() const { return width * height; }
};

int main() {
    int externalAge = 0;

    cout << "创建 Person p1 (name, ref):" << endl;
    Person p1("张三", externalAge);

    cout << "\\n创建 Person p2 (name):" << endl;
    Person p2("李四");

    cout << "\\n创建 Person p3 (默认):" << endl;
    Person p3();

    cout << "\\nRectangle 测试:" << endl;
    Rectangle r1;
    Rectangle r2(3.0, 4.0);
    Rectangle r3(5.0);

    cout << "\\n面积: r2=" << r2.area() << ", r3=" << r3.area() << endl;

    return 0;
}''',
          description: '展示初始化列表的用法、引用和 const 成员的初始化，以及委托构造函数。',
          output: '''创建 Person p1 (name, ref):
Person(name, ageRef) 构造

创建 Person p2 (name):
Person(name) 委托构造

创建 Person p3 (默认):
Person(name) 委托构造
Person() 委托构造

Rectangle 测试:
Rectangle 默认构造: 0x0
Rectangle 带参构造: 3x4
Rectangle 正方形: 5x5

面积: r2=12, r3=25''',
        ),
      ],
      keyPoints: [
        '构造函数用于初始化对象，析构函数用于清理资源',
        'const 成员和引用成员必须在初始化列表中初始化',
        '拷贝构造函数实现深拷贝，防止指针成员出现悬空问题',
        '移动构造函数可以高效地转移资源所有权（C++11）',
        '单参数构造函数建议使用 explicit 防止隐式类型转换',
      ],
    ),
  ],
);
