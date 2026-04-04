// 多态 - Polymorphism
import '../course_data.dart';

/// 多态章节
const chapterPolymorphism = CourseChapter(
  id: 'oop_polymorphism',
  title: '多态',
  description: '学习 C++ 中的多态特性，包括虚函数、纯虚函数、抽象类和接口的实现。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.oop,
  lessons: [
    CourseLesson(
      id: 'oop_polymorphism_virtual',
      title: '虚函数与多态',
      content: '''# 虚函数与多态

## 多态 (Polymorphism) 的概念

多态是指同一个接口表现出不同的行为。在 C++ 中主要通过虚函数实现。

## 虚函数 (Virtual Function)

用 `virtual` 关键字声明的成员函数，允许派生类重写 (override)。

```cpp
class Base {
public:
    virtual void show() const;  // 虚函数
    virtual ~Base() {}          // 虚析构函数
};
```

## 运行时多态

通过基类指针或引用调用虚函数时，实际调用的是指针指向对象的版本：

```cpp
Base* ptr = new Derived();
ptr->show();  // 调用 Derived::show()，不是 Base::show()
```

## override 说明符 (C++11)

在派生类中显式声明要重写基类虚函数：

```cpp
class Derived : public Base {
    void show() const override {  // 编译检查是否真的在重写
        // ...
    }
};
```

## 虚函数规则

1. 构造函数不能是虚函数
2. 析构函数可以是虚函数（应该设为虚函数）
3. 静态成员函数不能是虚函数
4. 私有虚函数可以被重写但不可通过指针调用

## 虚函数表 (vtable)

每个包含虚函数的类都有一个虚函数表，存储虚函数的地址。对象通过虚指针 (vptr) 访问虚函数表。
''',
      codeExamples: [
        CodeExample(
          title: '虚函数实现多态',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 基类 - 形状
class Shape {
protected:
    string color;

public:
    Shape(const string& c = "白色") : color(c) {}

    // 虚析构函数 - 重要！
    virtual ~Shape() {
        cout << "Shape 析构" << endl;
    }

    // 纯虚函数 - 计算面积
    virtual double area() const = 0;

    // 虚函数 - 打印信息
    virtual void display() const {
        cout << "形状，颜色: " << color;
    }
};

// 派生类 - 圆形
class Circle : public Shape {
private:
    double radius;

public:
    Circle(const string& c, double r) : Shape(c), radius(r) {}

    ~Circle() {
        cout << "Circle 析构" << endl;
    }

    // 重写虚函数
    double area() const override {
        return 3.14159 * radius * radius;
    }

    void display() const override {
        cout << "圆形，半径: " << radius << "，颜色: " << color;
        cout << "，面积: " << area() << endl;
    }
};

// 派生类 - 矩形
class Rectangle : public Shape {
private:
    double width;
    double height;

public:
    Rectangle(const string& c, double w, double h)
        : Shape(c), width(w), height(h) {}

    ~Rectangle() {
        cout << "Rectangle 析构" << endl;
    }

    double area() const override {
        return width * height;
    }

    void display() const override {
        cout << "矩形，宽: " << width << "，高: " << height;
        cout << "，颜色: " << color << "，面积: " << area() << endl;
    }
};

int main() {
    cout << "=== 多态数组 ===" << endl;
    vector<Shape*> shapes;

    // 通过基类指针存储不同派生类对象
    shapes.push_back(new Circle("红色", 5.0));
    shapes.push_back(new Rectangle("蓝色", 4.0, 6.0));
    shapes.push_back(new Circle("绿色", 3.0));

    // 统一接口调用 - 多态
    cout << "所有形状信息:" << endl;
    for (const Shape* s : shapes) {
        s->display();  // 调用的是实际对象的版本
    }

    // 计算总面积 - 多态的应用
    double totalArea = 0;
    for (const Shape* s : shapes) {
        totalArea += s->area();  // 多态调用
    }
    cout << "\\n总面积: " << totalArea << endl;

    // 正确删除 - 虚析构函数确保调用派生类析构
    cout << "\\n删除对象:" << endl;
    for (Shape* s : shapes) {
        delete s;
    }

    return 0;
}''',
          description: '展示虚函数实现多态，通过基类指针调用派生类的重写函数。',
          output: '''=== 多态数组 ===
所有形状信息:
圆形，半径: 5，颜色: 红色，面积: 78.5397
矩形，宽: 4，高: 6，颜色: 蓝色，面积: 24
圆形，半径: 3，颜色: 绿色，面积: 28.2743

总面积: 130.814

删除对象:
Circle 析构
Shape 析构
Rectangle 析构
Shape 析构
Circle 析构
Shape 析构''',
        ),
        CodeExample(
          title: 'override 与 final',
          code: '''#include <iostream>
#include <string>
using namespace std;

class Base {
public:
    virtual void method() const {
        cout << "Base::method()" << endl;
    }

    virtual void finalMethod() const {
        cout << "Base::finalMethod() - 不能被重写" << endl;
    }

    virtual ~Base() {}
};

// override 说明符
class Derived : public Base {
public:
    // 正确使用 override
    void method() const override {
        cout << "Derived::method() override" << endl;
    }

    // 错误示例：参数类型不匹配，会触发编译错误
    // void method(int x) const override { }  // 错误！不是重写

    // final 关键字 - 禁止继续重写
    void finalMethod() const override {
        cout << "Derived::finalMethod() 但仍是 override" << endl;
    }
};

// 使用 final 禁止派生
class FinalClass {
public:
    virtual void doSomething() const {
        cout << "FinalClass::doSomething()" << endl;
    }
};

class CantDerive final : public FinalClass {
public:
    // 错误！CannotDerive 已经声明为 final，不能被继承
    // class CannotDerive : public FinalClass {};  // 编译错误
};

int main() {
    cout << "=== override 检查 ===" << endl;
    Base* ptr = new Derived();
    ptr->method();  // 调用 Derived::method

    cout << "\\n=== 多态行为 ===" << endl;
    ptr->finalMethod();

    cout << "\\n=== 对象切片 vs 多态 ===" << endl;
    // 直接赋值对象（不是指针）会发生切片
    // Derived d; Base b = d;  // 切片！只复制基类部分

    // 正确做法：用指针或引用保持多态
    Derived d;
    Base& ref = d;
    ref.method();  // 调用 Derived::method

    delete ptr;
    return 0;
}''',
          description: '展示 override 说明符确保正确重写，以及 final 关键字的用法。',
          output: '''=== override 检查 ===
Derived::method() override

=== 多态行为 ===
Derived::finalMethod() 但仍是 override

=== 对象切片 vs 多态 ===
Derived::method() override''',
        ),
      ],
      keyPoints: [
        '虚函数通过 virtual 关键字声明，允许派生类重写',
        '通过基类指针调用虚函数时，实际调用的是派生类的版本（运行时多态）',
        '派生类重写虚函数时返回类型必须兼容（协变返回类型除外）',
        'override 说明符确保函数确实重写了基类虚函数，否则编译错误',
        '基类析构函数应设为 virtual，确保通过基类指针删除时正确析构派生类',
      ],
    ),

    CourseLesson(
      id: 'oop_polymorphism_pure_virtual',
      title: '纯虚函数与抽象类',
      content: '''# 纯虚函数与抽象类

## 纯虚函数 (Pure Virtual Function)

没有实际实现的虚函数，只提供接口规范：

```cpp
virtual 返回类型 函数名(参数) = 0;
```

`= 0` 是纯虚函数的标志。

## 抽象类 (Abstract Class)

包含至少一个纯虚函数的类称为抽象类。

### 特点

1. **不能实例化**：不能创建抽象类的对象
2. **可以作为基类**：提供接口规范
3. **可以有实现**：纯虚函数可以有默认实现

## 抽象类的应用

抽象类定义接口，派生类负责实现：

```cpp
class Animal {
public:
    virtual void speak() = 0;  // 纯虚函数
};

class Dog : public Animal {
public:
    void speak() override {
        cout << "汪汪！" << endl;
    }
};
```

## 接口 (Interface)

在 C++ 中，接口通常用抽象类表示：

- 所有成员函数都是 public
- 所有成员函数都是纯虚函数（可选有默认实现）
- 没有数据成员

## 纯虚函数的默认实现

派生类可以选择调用基类的默认实现：

```cpp
class Base {
public:
    virtual void method() = 0;
};

void Base::method() {  // 纯虚函数可以有默认实现
    cout << "默认实现" << endl;
}
```
''',
      codeExamples: [
        CodeExample(
          title: '抽象类与接口',
          code: '''#include <iostream>
#include <vector>
#include <memory>
using namespace std;

// 接口 - 可绘制的
class Drawable {
public:
    virtual ~Drawable() = default;

    // 纯虚函数 - 必须实现
    virtual void draw() const = 0;

    // 纯虚函数带默认实现
    virtual void move(double x, double y) = 0;
};

// 点 - 实现 Drawable 接口
class Point : public Drawable {
private:
    double x, y;

public:
    Point(double px = 0, double py = 0) : x(px), y(py) {}

    void draw() const override {
        cout << "绘制点 (" << x << ", " << y << ")" << endl;
    }

    void move(double dx, double dy) override {
        x += dx;
        y += dy;
        cout << "移动点到 (" << x << ", " << y << ")" << endl;
    }
};

// 线段 - 实现 Drawable 接口
class Line : public Drawable {
private:
    Point p1, p2;

public:
    Line(const Point& a, const Point& b) : p1(a), p2(b) {}

    void draw() const override {
        cout << "绘制线段" << endl;
        p1.draw();
        cout << "  到 ";
        p2.draw();
    }

    void move(double dx, double dy) override {
        cout << "移动线段:" << endl;
        p1.move(dx, dy);
        p2.move(dx, dy);
    }
};

// 抽象类作为基类 - 带部分实现
class Animal {
protected:
    string name;

public:
    Animal(const string& n) : name(n) {}

    // 纯虚函数 - 子类必须实现
    virtual void speak() const = 0;

    // 普通虚函数 - 子类可选重写
    virtual void showInfo() const {
        cout << name << " 相关信息" << endl;
    }

    virtual ~Animal() {}
};

class Cat : public Animal {
public:
    Cat(const string& n) : Animal(n) {}

    void speak() const override {
        cout << name << " 说: 喵~" << endl;
    }
};

class Dog : public Animal {
public:
    Dog(const string& n) : Animal(n) {}

    void speak() const override {
        cout << name << " 说: 汪汪!" << endl;
    }

    void showInfo() const override {
        cout << name << " 是一只狗，很忠诚" << endl;
    }
};

int main() {
    cout << "=== 接口示例 ===" << endl;
    vector<unique_ptr<Drawable>> shapes;

    shapes.push_back(make_unique<Point>(1, 2));
    shapes.push_back(make_unique<Line>(Point(0, 0), Point(3, 4)));

    for (const auto& s : shapes) {
        s->draw();
        s->move(10, 10);
    }

    cout << "\\n=== 抽象类示例 ===" << endl;
    vector<unique_ptr<Animal>> animals;

    animals.push_back(make_unique<Cat>("小喵"));
    animals.push_back(make_unique<Dog>("旺财"));

    for (const auto& a : animals) {
        a->speak();
        a->showInfo();
    }

    return 0;
}''',
          description: '展示抽象类和接口的实现，包含纯虚函数和带默认实现的纯虚函数。',
          output: '''=== 接口示例 ===
绘制点 (1, 2)
移动点到 (11, 12)
绘制线段
绘制点 (0, 0)  到 绘制点 (3, 4)
移动线段:
移动点到 (10, 10)
移动点到 (10, 10)

=== 抽象类示例 ===
小喵 说: 喵~
小喵 相关信息
旺财 说: 汪汪!
旺财 是一只狗，很忠诚''',
        ),
      ],
      keyPoints: [
        '纯虚函数 (= 0) 声明接口，派生类必须实现',
        '包含纯虚函数的类是抽象类，不能实例化',
        '抽象类可以作为类型使用，通过指针/引用指向派生类对象',
        '纯虚函数可以有默认实现，派生类可以选择调用基类实现',
        '使用 unique_ptr 管理抽象类指针，避免内存泄漏',
      ],
    ),
  ],
);
