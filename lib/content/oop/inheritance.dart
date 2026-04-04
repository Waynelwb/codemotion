// 继承 - Inheritance
import '../course_data.dart';

/// 继承章节
const chapterInheritance = CourseChapter(
  id: 'oop_inheritance',
  title: '继承',
  description: '学习 C++ 中的继承机制，包括单继承、多层继承、访问控制和派生类的构造与析构。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.oop,
  lessons: [
    CourseLesson(
      id: 'oop_inheritance_basics',
      title: '继承基础',
      content: '''# 继承基础

继承是面向对象编程的三大特性之一，允许我们基于已有类创建新类。

## 继承的概念

- **基类 (Base Class)**：被继承的类，也称为父类
- **派生类 (Derived Class)**：继承而来的类，也称为子类
- **单继承**：只有一个直接基类
- **多继承**：有多个直接基类

## 继承语法

```cpp
class 派生类名 : 继承方式 基类名 {
    // 派生类新增成员
};
```

## 继承方式

| 方式 | 基类 public | 基类 protected | 基类 private |
|------|-------------|----------------|--------------|
| `public` | public | protected | 不可直接访问 |
| `protected` | protected | protected | 不可直接访问 |
| `private` | private | private | 不可直接访问 |

## 派生类的特点

1. 可以添加新的成员（数据/函数）
2. 可以重写基类的成员函数
3. 可以增加自己的构造函数和析构函数

## 派生类的构造和析构

- **构造函数**：先调用基类构造函数，再执行派生类构造函数
- **析构函数**：先执行派生类析构函数，再调用基类析构函数
''',
      codeExamples: [
        CodeExample(
          title: '简单的单继承',
          code: '''#include <iostream>
#include <string>
using namespace std;

// 基类 - 动物
class Animal {
protected:  // protected: 派生类可以访问，外部不可访问
    string name;
    int age;

public:
    Animal(const string& n = "未知", int a = 0)
        : name(n), age(a) {
        cout << "Animal 构造: " << name << endl;
    }

    virtual ~Animal() {
        cout << "Animal 析构: " << name << endl;
    }

    void eat() const {
        cout << name << " 正在吃东西" << endl;
    }

    void sleep() const {
        cout << name << " 正在睡觉" << endl;
    }
};

// 派生类 - 狗
class Dog : public Animal {
private:
    string breed;  // 品种

public:
    Dog(const string& n, int a, const string& b)
        : Animal(n, a), breed(b) {  // 调用基类构造函数
        cout << "Dog 构造: " << breed << endl;
    }

    ~Dog() {
        cout << "Dog 析构" << endl;
    }

    // 狗特有的行为
    void bark() const {
        cout << name << " 汪汪叫！" << endl;
    }

    // 狗的品种
    string getBreed() const { return breed; }
};

int main() {
    cout << "创建 Dog 对象:" << endl;
    Dog myDog("旺财", 3, "金毛");

    cout << "\\n调用成员函数:" << endl;
    myDog.eat();
    myDog.sleep();
    myDog.bark();

    cout << "\\n对象信息: " << myDog.getBreed() << " " << endl;

    cout << "\\n销毁 Dog 对象:" << endl;
    return 0;
}''',
          description: '展示基本的单继承结构，基类 Animal 和派生类 Dog 的关系。',
          output: '''创建 Dog 对象:
Animal 构造: 旺财
Dog 构造: 金毛

调用成员函数:
旺财 正在吃东西
旺财 正在睡觉
旺财 汪汪叫！

对象信息: 金毛 

销毁 Dog 对象:
Dog 析构
Animal 析构: 旺财''',
        ),
        CodeExample(
          title: '多层继承与访问控制',
          code: '''#include <iostream>
#include <string>
using namespace std;

// 基类
class Vehicle {
protected:
    string brand;

public:
    Vehicle(const string& b) : brand(b) {
        cout << "Vehicle 构造: " << brand << endl;
    }

    virtual ~Vehicle() {
        cout << "Vehicle 析构: " << brand << endl;
    }

    void run() const {
        cout << brand << " 行驶中" << endl;
    }
};

// 派生类 - 私有继承
class Car : private Vehicle {  // private 继承
private:
    int seats;

public:
    Car(const string& b, int s) : Vehicle(b), seats(s) {
        cout << "Car 构造: " << seats << " 座" << endl;
    }

    ~Car() {
        cout << "Car 析构" << endl;
    }

    void show() const {
        // private 继承后，基类的 public 成员变为 private
        // 派生类内部可以访问
        cout << brand << " 有 " << seats << " 个座位" << endl;
        run();  // 可以调用，因为 run() 在 Car 内是 private
    }
};

// 派生类 - 保护继承
class SportsCar : protected Car {
private:
    int topSpeed;

public:
    SportsCar(const string& b, int s, int speed)
        : Car(b, s), topSpeed(speed) {
        cout << "SportsCar 构造: 最高时速 " << topSpeed << endl;
    }

    ~SportsCar() {
        cout << "SportsCar 析构" << endl;
    }

    void showInfo() const {
        // protected 继承后，基类的成员在 SportsCar 内是 protected
        // 可以被 SportsCar 的成员函数访问
        show();  // 可以调用
        cout << brand << " 最高时速 " << topSpeed << " km/h" << endl;
    }
};

int main() {
    cout << "=== 创建 SportsCar ===" << endl;
    SportsCar sc("法拉利", 2, 350);

    cout << "\\n=== 调用 showInfo ===" << endl;
    sc.showInfo();

    cout << "\\n=== 销毁对象 ===" << endl;
    return 0;
}''',
          description: '展示多层继承（Vehicle -> Car -> SportsCar）和不同继承方式的影响。',
          output: '''=== 创建 SportsCar ===
Vehicle 构造: 法拉利
Car 构造: 2 座
SportsCar 构造: 最高时速 350

=== 调用 showInfo ===
法拉利 有 2 个座位
法拉利 行驶中
法拉利 最高时速 350 km/h

=== 销毁对象 ===
SportsCar 析构
Car 析构
Vehicle 析构: 法拉利''',
        ),
      ],
      keyPoints: [
        'public 继承保持基类成员的访问级别不变',
        'protected 继承将基类的 public 变为 protected',
        'private 继承将基类的 public 和 protected 都变为 private',
        '派生类构造先调用基类构造函数，再执行自己的构造函数',
        '析构函数顺序与构造相反：先派生类析构，再基类析构',
      ],
    ),

    CourseLesson(
      id: 'oop_inheritance_constructor',
      title: '派生类的构造与析构',
      content: '''# 派生类的构造与析构

## 构造函数调用顺序

1. 基类构造函数（按继承顺序）
2. 成员对象构造函数（按声明顺序）
3. 派生类自己的构造函数

## 析构函数调用顺序

与构造函数**完全相反**：
1. 派生类析构函数
2. 成员对象析构函数
3. 基类析构函数（按继承顺序的反序）

## 基类构造函数参数传递

派生类构造函数必须负责向基类构造函数传递参数：

```cpp
class Base {
public:
    Base(int x);
};

class Derived : public Base {
public:
    Derived(int x, int y) : Base(x) {  // 必须显式传递
        // ...
    }
};
```

## 隐式调用基类构造函数

如果基类有无参构造函数，派生类构造函数可以省略 `: Base()`。

## 多继承的构造顺序

多继承时，构造顺序只与**声明顺序**有关，与初始化列表顺序无关：

```cpp
class A {};
class B {};
class C : public A, public B {};  // 先构造 A，再构造 B
```

## 基类析构函数应为 virtual

如果一个类可能被继承，析构函数应声明为 `virtual`：

```cpp
virtual ~Base() {}
```

这样才能通过基类指针正确删除派生类对象（防止切片）。
''',
      codeExamples: [
        CodeExample(
          title: '构造析构顺序与基类指针',
          code: '''#include <iostream>
#include <string>
using namespace std;

class Base {
protected:
    string name;

public:
    Base(const string& n) : name(n) {
        cout << "Base 构造: " << name << endl;
    }

    virtual ~Base() {  // virtual 析构函数
        cout << "Base 析构: " << name << endl;
    }

    virtual void display() const {
        cout << "Base: " << name << endl;
    }
};

class Derived : public Base {
private:
    int value;

public:
    Derived(const string& n, int v) : Base(n), value(v) {
        cout << "Derived 构造: value=" << value << endl;
    }

    ~Derived() {
        cout << "Derived 析构: " << name << endl;
    }

    void display() const override {
        cout << "Derived: " << name << ", value=" << value << endl;
    }
};

int main() {
    cout << "=== 通过基类指针删除派生类 ===" << endl;
    Base* ptr = new Derived("测试对象", 42);
    ptr->display();

    cout << "\\n删除对象 (virtual 析构确保正确调用):" << endl;
    delete ptr;  // 如果析构函数不是 virtual，这里会只调用 Base 析构

    cout << "\\n=== 构造/析构顺序验证 ===" << endl;
    cout << "创建 Derived 对象..." << endl;
    {
        Derived d("局部对象", 100);
    }
    cout << "作用域结束，对象已销毁" << endl;

    return 0;
}''',
          description: '展示派生类构造析构顺序，以及为什么基类析构函数应该是 virtual。',
          output: '''=== 通过基类指针删除派生类 ===
Base 构造: 测试对象
Derived 构造: value=42
Derived: 测试对象, value=42

删除对象 (virtual 析构确保正确调用):
Derived 析构: 测试对象
Base 析构: 测试对象

=== 构造/析构顺序验证 ===
创建 Derived 对象...
Base 构造: 局部对象
Derived 构造: value=100
Derived 析构: 局部对象
Base 析构: 局部对象
作用域结束，对象已销毁''',
        ),
        CodeExample(
          title: '多继承构造顺序',
          code: '''#include <iostream>
using namespace std;

class A {
public:
    A() { cout << "A 构造" << endl; }
    ~A() { cout << "A 析构" << endl; }
};

class B {
public:
    B() { cout << "B 构造" << endl; }
    ~B() { cout << "B 析构" << endl; }
};

class C {
public:
    C() { cout << "C 构造" << endl; }
    ~C() { cout << "C 析构" << endl; }
};

class D : public A, public B {  // 声明顺序: A, B
public:
    D() { cout << "D 构造" << endl; }
    ~D() { cout << "D 析构" << endl; }
};

class E : public B, public A {  // 声明顺序: B, A
public:
    E() { cout << "E 构造" << endl; }
    ~E() { cout << "E 析构" << endl; }
};

class F : public D, public C {  // 多层多继承
public:
    F() { cout << "F 构造" << endl; }
    ~F() { cout << "F 析构" << endl; }
};

int main() {
    cout << "=== D (继承 A, B) ===" << endl;
    D d;

    cout << "\\n=== E (继承 B, A) ===" << endl;
    E e;

    cout << "\\n=== F (继承 D, C) ===" << endl;
    F f;

    cout << "\\n=== 析构顺序 ===" << endl;
    return 0;
}''',
          description: '展示多继承时的构造和析构顺序，按声明顺序构造，按相反顺序析构。',
          output: '''=== D (继承 A, B) ===
A 构造
B 构造
D 构造

=== E (继承 B, A) ===
B 构造
A 构造
E 构造

=== F (继承 D, C) ===
A 构造
B 构造
D 构造
C 构造
F 构造

=== 析构顺序 ===
F 析构
C 析构
D 析构
B 析构
A 析构
E 析构
A 析构
B 析构
D 析构
A 析构
B 析构''',
        ),
      ],
      keyPoints: [
        '派生类构造函数必须显式调用基类构造函数并传递参数',
        '构造顺序：基类 -> 成员对象 -> 派生类；析构顺序相反',
        '多继承时构造顺序只与声明顺序有关，与初始化列表无关',
        '基类析构函数应为 virtual，确保通过基类指针删除派生类时正确析构',
        '如果不使用 virtual 析构，可能导致派生类部分未被销毁（对象切片）',
      ],
    ),
  ],
);
