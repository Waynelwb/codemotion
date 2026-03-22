// 变量与数据类型 - Variables and Data Types
import '../course_data.dart';

/// 变量与数据类型章节
const chapterVariables = CourseChapter(
  id: 'basics_variables',
  title: '变量与数据类型',
  description: '学习 C++ 中的基本数据类型和变量声明，包括整型、浮点型、字符型、布尔型和字符串。',
  difficulty: DifficultyLevel.beginner,
  lessons: [
    // Lesson 1: 基础数据类型
    CourseLesson(
      id: 'basics_variables_basic',
      title: '基础数据类型',
      content: '''# 基础数据类型

C++ 是一种强类型语言，每个变量都必须有明确的数据类型。基本数据类型是构建程序的基础。

## 整型 (Integer Types)

| 类型 | 说明 | 典型范围 |
|------|------|----------|
| `int` | 整型 | -2,147,483,648 ~ 2,147,483,647 |
| `short` | 短整型 | -32,768 ~ 32,767 |
| `long` | 长整型 | 平台相关 |
| `long long` | 更长整型 | -9×10¹⁸ ~ 9×10¹⁸ |

## 浮点型 (Floating-Point Types)

| 类型 | 说明 | 精度 |
|------|------|------|
| `float` | 单精度浮点 | 约 6-7 位有效数字 |
| `double` | 双精度浮点 | 约 15 位有效数字 |
| `long double` | 扩展精度 | 更高精度 |

## 字符型 (Character Type)

- `char`: 存储单个字符，占 1 字节
- 使用单引号：`'A'`, `'x'`, `'3'`

## 布尔型 (Boolean Type)

- `bool`: 只有两个值 `true` 和 `false`
- 本质上 `true` = 1, `false` = 0

## 有符号 vs 无符号

- `int` / `unsigned int`: 有符号/无符号整型
- 无符号类型只能表示非负数，但范围更大

## 变量命名规则

1. 变量名只能包含字母、数字和下划线
2. 不能以数字开头
3. 不能使用保留字（如 `int`, `class`, `return` 等）
4. 区分大小写
5. 建议使用有意义的名称，使用驼峰命名或下划线分隔

## 类型转换

C++ 中可以进行显式和隐式类型转换：
- **隐式转换**：编译器自动进行，较小类型 → 较大类型
- **显式转换**：使用 `static_cast<类型>(值)` 强制转换
''',
      codeExamples: [
        CodeExample(
          title: '基本数据类型演示',
          code: '''#include <iostream>
#include <climits>  // 用于 INT_MAX 等常量
using namespace std;

int main() {
    // 整型变量
    int age = 25;
    short score = 100;
    long population = 7800000000L;

    // 浮点型变量
    double pi = 3.141592653589793;
    float gravity = 9.8f;  // float 常量要加 f 后缀

    // 字符型
    char grade = 'A';

    // 布尔型
    bool isStudent = true;
    bool isPassed = false;

    // 输出各类型变量
    cout << "年龄: " << age << endl;
    cout << "圆周率: " << pi << endl;
    cout << "等级: " << grade << endl;
    cout << "是学生吗: " << (isStudent ? "是" : "否") << endl;

    // sizeof 操作符 - 查看类型字节大小
    cout << "\\n类型大小 (字节):" << endl;
    cout << "int: " << sizeof(int) << endl;
    cout << "double: " << sizeof(double) << endl;
    cout << "char: " << sizeof(char) << endl;
    cout << "bool: " << sizeof(bool) << endl;

    return 0;
}''',
          description: '展示 C++ 中各种基本数据类型的声明和使用，包括 sizeof 查看类型大小。',
          output: '''年龄: 25
圆周率: 3.14159
等级: A
是学生吗: 是

类型大小 (字节):
int: 4
double: 8
char: 1
bool: 1''',
        ),
        CodeExample(
          title: '类型转换示例',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 隐式转换 - 自动提升
    int a = 10;
    double b = a;  // int → double，自动转换
    cout << "隐式转换 (int→double): " << b << endl;

    // 显式转换 - 强制转换
    double x = 9.7;
    int y = (int)x;  // C 风格转换，double → int
    cout << "强制转换 (double→int): " << y << endl;

    // 使用 static_cast 进行类型转换 (推荐方式)
    double m = 3.99;
    int n = static_cast<int>(m);  // C++ 风格转换
    cout << "static_cast 转换: " << n << endl;

    // 除法中的类型转换
    int p = 7, q = 2;
    cout << "整数除法 (7/2): " << (p / q) << endl;
    cout << "浮点除法 (7.0/2): " << (7.0 / 2) << endl;
    cout << "强制转换除法: " << (static_cast<double>(p) / q) << endl;

    return 0;
}''',
          description: '演示隐式类型转换和显式类型转换的区别，以及 static_cast 的使用。',
          output: '''隐式转换 (int→double): 10
强制转换 (double→int): 9
static_cast 转换: 9
整数除法 (7/2): 3
浮点除法 (7.0/2): 3.5
强制转换除法: 3.5''',
        ),
      ],
      keyPoints: [
        'C++ 基本数据类型包括：int、double、char、bool',
        'int 通常占 4 字节，double 占 8 字节',
        '变量命名应遵循标识符规则，建议使用有意义的名称',
        '隐式转换由编译器自动完成，显式转换使用 static_cast',
        '整数除法会丢失小数部分，需转换为浮点型保留小数',
      ],
    ),

    // Lesson 2: 常量与变量
    CourseLesson(
      id: 'basics_variables_constants',
      title: '常量与变量',
      content: '''# 常量与变量

## 变量 (Variables)

变量是存储数据的容器，其值可以在程序运行过程中改变。

```cpp
int count = 10;  // 声明并初始化变量
count = 20;      // 可以重新赋值
```

## 常量 (Constants)

常量是不可改变的值，一旦定义就不能修改。

### const 关键字

```cpp
const int MAX_SIZE = 100;
const double PI = 3.14159;
```

### constexpr 关键字 (C++11)

用于编译时常量表达式：

```cpp
constexpr int ARRAY_SIZE = 100;
constexpr double GRAVITY = 9.8;
```

### 宏定义 (#define)

```cpp
#define MAX_BUFFER 1024
#define DEBUG_MODE true
```

**注意**：宏定义没有类型安全检查，不推荐在新代码中使用。

## 字面量 (Literals)

直接写在代码中的值：

- `42` - 整数字面量 (int)
- `3.14` - 浮点字面量 (double)
- `'A'` - 字符字面量 (char)
- `"hello"` - 字符串字面量 (const char[])
- `true` / `false` - 布尔字面量

### 后缀

- `u` / `U` - unsigned
- `l` / `L` - long
- `f` / `F` - float
- `ll` / `LL` - long long

```cpp
100u      // unsigned int
3.14f     // float
1000000L  // long
```

## 初始化方式

```cpp
int a = 10;        // copy initialization
int b(20);         // direct initialization
int c{30};         // brace initialization (C++11)
int d = {40};      // copy brace initialization
```

**推荐使用大括号初始化 `{}`**，因为它更安全，可以防止类型 narrowing（窄化）。
''',
      codeExamples: [
        CodeExample(
          title: '常量的使用',
          code: '''#include <iostream>
using namespace std;

int main() {
    // const 常量 - 运行时常量
    const int MAX_RETRY = 3;
    const double TAX_RATE = 0.13;

    // constexpr - 编译时常量 (C++11)
    constexpr int BUFFER_SIZE = 1024;
    constexpr double PI = 3.14159265358979;

    // 尝试修改常量会导致编译错误
    // MAX_RETRY = 5;  // Error!

    cout << "最大重试次数: " << MAX_RETRY << endl;
    cout << "税率: " << TAX_RATE << endl;
    cout << "缓冲区大小: " << BUFFER_SIZE << endl;
    cout << "圆周率: " << PI << endl;

    // 整数字面量后缀
    unsigned int positive = 100u;
    long bigNumber = 1000000L;

    // 浮点字面量后缀
    float smallPi = 3.14f;  // float 需要 f 后缀
    double largePi = 3.141592653589793;  // double 默认

    cout << "\\n小 pi (float): " << smallPi << endl;
    cout << "大 pi (double): " << largePi << endl;

    // 字面量进制
    int decimal = 42;      // 十进制
    int octal = 042;       // 八进制 (以 0 开头)
    int hex = 0x2A;        // 十六进制 (以 0x 开头)
    int binary = 0b101010; // 二进制 (以 0b 开头，C++14)

    cout << "\\n十进制 42 = " << decimal << endl;
    cout << "八进制 042 = " << octal << endl;
    cout << "十六进制 0x2A = " << hex << endl;
    cout << "二进制 0b101010 = " << binary << endl;

    return 0;
}''',
          description: '展示 const、constexpr 常量的使用，以及各种字面量的表示方法（进制转换、后缀等）。',
          output: '''最大重试次数: 3
税率: 0.13
缓冲区大小: 1024
圆周率: 3.14159

小 pi (float): 3.14
大 pi (double): 3.14159
十进制 42 = 42
八进制 042 = 34
十六进制 0x2A = 42
二进制 0b101010 = 42''',
        ),
        CodeExample(
          title: '大括号初始化演示',
          code: '''#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 大括号初始化 - 推荐方式
    int a{100};
    double b{3.14};
    char c{'X'};

    cout << "大括号初始化: " << a << ", " << b << ", " << c << endl;

    // 列表初始化 - 防止 narrowing
    int x = 3.14;    // 警告：double → int，丢失小数部分
    // int y{3.14};  // 错误：narrowing conversion，不允许

    // vector 列表初始化
    vector<int> numbers{1, 2, 3, 4, 5};
    cout << "Vector 内容: ";
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    // 数组初始化
    int arr[5] = {1, 2, 3};  // 未指定的元素自动设为 0
    cout << "数组: ";
    for (int i = 0; i < 5; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;

    // auto 类型推导 + 大括号初始化
    auto name = string{"Alice"};  // 自动推断为 string
    auto age = 25;                  // 自动推断为 int

    cout << "姓名: " << name << ", 年龄: " << age << endl;

    return 0;
}''',
          description: '展示大括号初始化的优势，包括防止 narrowing conversion，以及在容器和数组中的使用。',
          output: '''大括号初始化: 100, 3.14, X
Vector 内容: 1 2 3 4 5 
数组: 1 2 3 0 0 
姓名: Alice, 年龄: 25''',
        ),
      ],
      keyPoints: [
        'const 用于定义运行时常量，constexpr 用于编译时常量',
        '字面量可以用不同进制表示（十进制、八进制 0、十六进制 0x、二进制 0b）',
        '推荐使用大括号 {} 进行初始化，可以防止类型 narrowing',
        'auto 关键字可以自动推导变量类型',
        '整数字面量加 u 表示 unsigned，浮点加 f 表示 float',
      ],
    ),
  ],
);
