// 封装 - Encapsulation
import '../course_data.dart';

/// 封装章节
const chapterEncapsulation = CourseChapter(
  id: 'oop_encapsulation',
  title: '封装',
  description: '学习 C++ 中的封装机制，包括访问控制、友元、getter/setter 以及类的友元声明。',
  difficulty: DifficultyLevel.intermediate,
  lessons: [
    CourseLesson(
      id: 'oop_encapsulation_access',
      title: '访问控制详解',
      content: '''# 访问控制详解

## 访问控制关键字

| 关键字 | 类内访问 | 派生类访问 | 类外访问 |
|--------|----------|------------|----------|
| `public` | ✓ | ✓ | ✓ |
| `protected` | ✓ | ✓ | ✗ |
| `private` | ✓ | ✗ | ✗ |

## 类的默认访问级别

- `class` 默认是 `private`
- `struct` 默认是 `public`

```cpp
class A {     // 默认 private
    int x;    // private
};

struct B {    // 默认 public
    int x;    // public
};
```

## 封装的优点

1. **数据隐藏**：内部实现细节对外部隐藏
2. **接口清晰**：只暴露必要的 public 接口
3. **易于维护**：修改内部实现不影响外部代码
4. **安全性**：防止意外或非法的数据修改

## 成员函数访问控制

成员函数也有访问级别，它能访问的成员取决于类的完整性：

```cpp
class A {
private:
    int data;
public:
    void setData(int d) {  // public 成员函数
        data = d;          // 可以访问 private 成员
    }
};
```

## 内联函数 (Inline)

对于简短的成员函数，可以声明为内联函数：

```cpp
class A {
    int x;
public:
    int getX() const { return x; }  // 隐式内联
};

// 显式内联
inline int getValue() { return 42; }
```

## 静态成员 (Static Members)

- `static` 数据成员：所有对象共享
- `static` 成员函数：不依赖 this 指针

```cpp
class Counter {
private:
    static int count;  // 类变量，所有对象共享
public:
    Counter() { count++; }
    static int getCount() { return count; }
};
int Counter::count = 0;  // 静态成员定义和初始化
```
''',
      codeExamples: [
        CodeExample(
          title: '访问控制与封装',
          code: '''#include <iostream>
using namespace std;

class BankAccount {
private:
    // 私有数据 - 封装
    string accountNumber;
    string ownerName;
    double balance;

    // 私有辅助函数
    bool isValidAmount(double amount) const {
        return amount > 0;
    }

public:
    // 构造函数
    BankAccount(const string& num, const string& name, double initial = 0)
        : accountNumber(num), ownerName(name), balance(initial) {}

    // getter 函数 - 只读访问
    string getAccountNumber() const { return accountNumber; }
    string getOwnerName() const { return ownerName; }
    double getBalance() const { return balance; }

    // setter 函数 - 验证后写入
    bool deposit(double amount) {
        if (isValidAmount(amount)) {
            balance += amount;
            return true;
        }
        return false;
    }

    bool withdraw(double amount) {
        if (isValidAmount(amount) && amount <= balance) {
            balance -= amount;
            return true;
        }
        return false;
    }

    // 打印信息
    void display() const {
        cout << "账号: " << accountNumber << endl;
        cout << "户主: " << ownerName << endl;
        cout << "余额: " << balance << endl;
    }
};

// 静态成员示例
class Counter {
private:
    static int objectCount;  // 所有对象共享
    int id;

public:
    Counter() {
        id = ++objectCount;
        cout << "Counter #" << id << " 创建" << endl;
    }

    static int getCount() {
        return objectCount;
    }

    int getId() const { return id; }
};

int Counter::objectCount = 0;  // 静态成员定义和初始化

int main() {
    cout << "=== 银行账户封装 ===" << endl;
    BankAccount account("123456789", "张三", 1000);

    account.display();
    cout << endl;

    cout << "存入 500..." << (account.deposit(500) ? "成功" : "失败") << endl;
    cout << "取出 300..." << (account.withdraw(300) ? "成功" : "失败") << endl;
    cout << "取出 2000..." << (account.withdraw(2000) ? "成功" : "失败") << endl;

    account.display();

    cout << "\\n=== 静态成员 ===" << endl;
    cout << "当前对象数量: " << Counter::getCount() << endl;

    Counter c1, c2, c3;

    cout << "创建 3 个对象后: " << Counter::getCount() << endl;
    cout << "c1 id: " << c1.getId() << endl;
    cout << "c2 id: " << c2.getId() << endl;
    cout << "c3 id: " << c3.getId() << endl;

    return 0;
}''',
          description: '展示如何通过封装修剪银行账户类，以及静态成员变量的使用。',
          output: '''=== 银行账户封装 ===
账号: 123456789
户主: 张三
余额: 1000

存入 500...成功
取出 300...成功
取出 2000...失败
账号: 123456789
户主: 张三
余额: 1200

=== 静态成员 ===
当前对象数量: 0
Counter #1 创建
Counter #2 创建
Counter #3 创建
创建 3 个对象后: 3
c1 id: 1
c2 id: 2
c3 id: 3''',
        ),
        CodeExample(
          title: '友元函数与友元类',
          code: '''#include <iostream>
#include <cmath>
using namespace std;

// 前向声明
class Point;

class PointUtils {
public:
    // 友元函数 - 可以访问 Point 的私有成员
    static double distance(const Point& p1, const Point& p2);

    static void resetPoint(Point& p);
};

class Point {
private:
    double x, y;

public:
    Point(double px = 0, double py = 0) : x(px), y(py) {}

    // 友元声明
    friend double PointUtils::distance(const Point&, const Point&);
    friend void PointUtils::resetPoint(Point&);

    // 友元类
    friend class PointPrinter;

    void display() const {
        cout << "(" << x << ", " << y << ")" << endl;
    }
};

// 友元函数的实现
double PointUtils::distance(const Point& p1, const Point& p2) {
    // 直接访问 Point 的私有成员 x, y
    double dx = p1.x - p2.x;
    double dy = p1.y - p2.y;
    return sqrt(dx * dx + dy * dy);
}

void PointUtils::resetPoint(Point& p) {
    p.x = 0;  // 直接访问私有成员
    p.y = 0;
}

// 友元类
class PointPrinter {
public:
    void printAll(const Point& p) const {
        // 可以访问 Point 的所有成员
        cout << "PointPrinter: x=" << p.x << ", y=" << p.y << endl;
    }

    void modify(Point& p, double newX, double newY) const {
        p.x = newX;
        p.y = newY;
    }
};

int main() {
    cout << "=== 友元函数 ===" << endl;
    Point p1(3, 4);
    Point p2(0, 0);

    cout << "p1: ";
    p1.display();
    cout << "p2: ";
    p2.display();
    cout << "距离: " << PointUtils::distance(p1, p2) << endl;

    cout << "\\n=== 友元类 ===" << endl;
    PointPrinter printer;
    printer.printAll(p1);

    printer.modify(p1, 10, 20);
    cout << "修改后: ";
    p1.display();

    cout << "\\n=== resetPoint ===" << endl;
    PointUtils::resetPoint(p1);
    cout << "重置后: ";
    p1.display();

    return 0;
}''',
          description: '展示友元函数和友元类的使用，可以访问其他类的私有成员。',
          output: '''=== 友元函数 ===
p1: (3, 4)
p2: (0, 0)
距离: 5

=== 友元类 ===
PointPrinter: x=3, y=4
修改后: (10, 20)

=== resetPoint ===
重置后: (0, 0)''',
        ),
      ],
      keyPoints: [
        'private 成员只能被本类成员函数和友元访问',
        'protected 成员可以被派生类访问，但不能被类外访问',
        '友元函数/类可以访问对应类的所有成员，包括 private',
        '静态成员属于类本身，不属于单个对象，所有对象共享',
        '封装通过隐藏实现细节，提高代码的安全性和可维护性',
      ],
    ),
  ],
);
