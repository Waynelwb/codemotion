// 运算符 - Operators
import '../course_data.dart';

/// 运算符章节
const chapterOperators = CourseChapter(
  id: 'basics_operators',
  title: '运算符',
  description: '学习 C++ 中的各种运算符，包括算术运算符、关系运算符、逻辑运算符和位运算符。',
  difficulty: DifficultyLevel.beginner,
  category: CourseCategory.basics,
  lessons: [
    CourseLesson(
      id: 'basics_operators_arithmetic',
      title: '算术运算符',
      content: '''# 算术运算符

算术运算符用于执行基本的数学运算。

## 基本算术运算符

| 运算符 | 说明 | 示例 |
|--------|------|------|
| `+` | 加法 | `a + b` |
| `-` | 减法 | `a - b` |
| `*` | 乘法 | `a * b` |
| `/` | 除法 | `a / b` |
| `%` | 取模（取余） | `a % b` |

## 运算符优先级

乘、除、取模优先级高于加、减。

```cpp
int result = 2 + 3 * 4;  // result = 14, 先算乘法
```

## 自增/自减运算符

| 运算符 | 说明 |
|--------|------|
| `++a` | 前置自增（先加后用） |
| `a++` | 后置自增（先用后加） |
| `--a` | 前置自减（先减后用） |
| `a--` | 后置自减（先用后减） |

## 复合赋值运算符

| 运算符 | 等价于 |
|--------|--------|
| `a += b` | `a = a + b` |
| `a -= b` | `a = a - b` |
| `a *= b` | `a = a * b` |
| `a /= b` | `a = a / b` |
| `a %= b` | `a = a % b` |

## 数学函数

`<cmath>` 库提供了丰富的数学函数：

- `abs(x)` - 绝对值
- `sqrt(x)` - 平方根
- `pow(x, y)` - x 的 y 次方
- `sin(x)`, `cos(x)`, `tan(x)` - 三角函数
- `log(x)`, `log10(x)` - 对数函数
''',
      codeExamples: [
        CodeExample(
          title: '基本算术运算',
          code: '''#include <iostream>
#include <cmath>
using namespace std;

int main() {
    int a = 17, b = 5;

    // 基本算术运算
    cout << "基本算术运算 (a=17, b=5):" << endl;
    cout << "a + b = " << (a + b) << endl;  // 22
    cout << "a - b = " << (a - b) << endl;  // 12
    cout << "a * b = " << (a * b) << endl;  // 85
    cout << "a / b = " << (a / b) << endl;  // 3 (整数除法)
    cout << "a % b = " << (a % b) << endl;  // 2 (取余)

    // 浮点除法
    double x = 17.0, y = 5.0;
    cout << "\\n浮点除法 (x=17.0, y=5.0):" << endl;
    cout << "x / y = " << (x / y) << endl;  // 3.4

    // 复合赋值运算符
    int n = 10;
    n += 5;   // n = 15
    n *= 2;   // n = 30
    n -= 10;  // n = 20
    n /= 4;   // n = 5
    cout << "\\n复合赋值运算后 n = " << n << endl;

    // 自增/自减运算符
    int i = 5;
    cout << "\\n自增自减演示 (i=5):" << endl;
    cout << "i++ = " << i++ << " (i 现在是 " << i << ")" << endl;
    cout << "++i = " << ++i << " (i 现在是 " << i << ")" << endl;
    cout << "i-- = " << i-- << " (i 现在是 " << i << ")" << endl;
    cout << "--i = " << --i << " (i 现在是 " << i << ")" << endl;

    // 数学函数
    cout << "\\n数学函数:" << endl;
    cout << "abs(-10) = " << abs(-10) << endl;
    cout << "sqrt(16) = " << sqrt(16) << endl;
    cout << "pow(2, 8) = " << pow(2, 8) << endl;
    cout << "sin(PI/2) = " << sin(3.14159/2) << endl;

    return 0;
}''',
          description: '演示基本算术运算符、自增自减运算符和复合赋值运算符的使用。',
          output: '''基本算术运算 (a=17, b=5):
a + b = 22
a - b = 12
a * b = 85
a / b = 3
a % b = 2

浮点除法 (x=17.0, y=5.0):
x / y = 3.4

复合赋值运算后 n = 5

自增自减演示 (i=5):
i++ = 5 (i 现在是 6)
++i = 7 (i 现在是 7)
i-- = 7 (i 现在是 6)
--i = 5 (i 现在是 5)

数学函数:
abs(-10) = 10
sqrt(16) = 4
pow(2, 8) = 256
sin(PI/2) = 1''',
        ),
        CodeExample(
          title: '运算符优先级',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 运算符优先级演示
    int result;

    // 乘除高于加减
    result = 2 + 3 * 4;
    cout << "2 + 3 * 4 = " << result << " (先算 3*4=12, 再加 2)" << endl;

    // 使用括号改变优先级
    result = (2 + 3) * 4;
    cout << "(2 + 3) * 4 = " << result << " (先算 2+3=5, 再乘 4)" << endl;

    // 复杂表达式
    result = 10 + 20 / 4 - 2 * 3;
    // 等价于: 10 + 5 - 6 = 9
    cout << "10 + 20 / 4 - 2 * 3 = " << result << endl;

    // 自增运算符的优先级
    int a = 5;
    int b = a++ * 2;  // 等价于 b = a * 2; a++;
    cout << "\\na=5, b = a++ * 2" << endl;
    cout << "b = " << b << " (先用 a=5, 再自增)" << endl;

    a = 5;
    int c = ++a * 2;  // 等价于 a++; c = a * 2;
    cout << "\\na=5, c = ++a * 2" << endl;
    cout << "c = " << c << " (先自增 a=6, 再乘 2)" << endl;

    // 赋值运算符的右结合性
    int x, y, z;
    x = y = z = 100;  // 从右向左赋值
    cout << "\\n链式赋值 x = y = z = 100" << endl;
    cout << "x = " << x << ", y = " << y << ", z = " << z << endl;

    return 0;
}''',
          description: '展示运算符优先级的规则，以及如何使用括号改变计算顺序。',
          output: '''2 + 3 * 4 = 14 (先算 3*4=12, 再加 2)
(2 + 3) * 4 = 20 (先算 2+3=5, 再乘 4)
10 + 20 / 4 - 2 * 3 = 9

a=5, b = a++ * 2
b = 10 (先用 a=5, 再自增)

a=5, c = ++a * 2
c = 12 (先自增 a=6, 再乘 2)

链式赋值 x = y = z = 100
x = 100, y = 100, z = 100''',
        ),
      ],
      keyPoints: [
        '算术运算符包括：+、-、*、/、%',
        '整数除法会截断小数部分，浮点除法保留小数',
        '取模运算符 % 用于获取除法余数，只能用于整数',
        '前置 ++a 先自增再使用，后置 a++ 先使用再自增',
        '乘除优先级高于加减，括号可以改变优先级',
      ],
    ),

    CourseLesson(
      id: 'basics_operators_relational_logical',
      title: '关系与逻辑运算符',
      content: '''# 关系与逻辑运算符

## 关系运算符（比较运算符）

用于比较两个值的大小关系。

| 运算符 | 说明 | 示例 |
|--------|------|------|
| `==` | 等于 | `a == b` |
| `!=` | 不等于 | `a != b` |
| `>` | 大于 | `a > b` |
| `<` | 小于 | `a < b` |
| `>=` | 大于等于 | `a >= b` |
| `<=` | 小于等于 | `a <= b` |

**注意**：`==` 是比较，`=` 是赋值！

## 逻辑运算符

用于组合多个条件表达式。

| 运算符 | 说明 | 说明 |
|--------|------|------|
| `&&` | 逻辑与 | 两个条件都为真才为真 |
| `\|\|` | 逻辑或 | 任一条件为真就为真 |
| `!` | 逻辑非 | 取反，真变假，假变真 |

## 短路求值 (Short-Circuit Evaluation)

- `&&`：左边为 false 时，右边不计算
- `||`：左边为 true 时，右边不计算

## 比较浮点数

**警告**：浮点数比较不应直接使用 `==`，因为浮点数有精度误差。

正确方法：
- 使用 epsilon 误差范围：`fabs(a - b) < 1e-9`
- 使用 `std::fabs()` 计算绝对值

## 三目运算符 (Ternary Operator)

```cpp
条件 ? 值1 : 值2
```

如果条件为 true，返回值1，否则返回值2。
''',
      codeExamples: [
        CodeExample(
          title: '关系与逻辑运算符',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 关系运算符
    int a = 10, b = 20;

    cout << "关系运算符 (a=10, b=20):" << endl;
    cout << "a == b: " << (a == b) << endl;  // 0 (false)
    cout << "a != b: " << (a != b) << endl;  // 1 (true)
    cout << "a < b:  " << (a < b) << endl;   // 1 (true)
    cout << "a > b:  " << (a > b) << endl;   // 0 (false)
    cout << "a <= b: " << (a <= b) << endl;  // 1 (true)
    cout << "a >= b: " << (a >= b) << endl;  // 0 (false)

    // 逻辑运算符
    bool x = true, y = false;

    cout << "\\n逻辑运算符 (x=true, y=false):" << endl;
    cout << "x && y (AND): " << (x && y) << endl;   // 0 (false)
    cout << "x || y (OR):  " << (x || y) << endl;   // 1 (true)
    cout << "!x (NOT):    " << (!x) << endl;       // 0 (false)

    // 短路求值演示
    cout << "\\n短路求值:" << endl;
    int m = 5, n = 10;
    if (m > 10 && ++n > 10) {
        // m > 10 为 false，++n 不会执行
    }
    cout << "m=5, n after m>10 && ++n>10: " << n << endl;

    m = 5;
    n = 10;
    if (m < 10 || ++n > 10) {
        // m < 10 为 true，++n 不会执行
    }
    cout << "m=5, n after m<10 || ++n>10: " << n << endl;

    // 三目运算符
    cout << "\\n三目运算符:" << endl;
    int score = 85;
    char grade = (score >= 60) ? 'P' : 'F';
    cout << "分数 " << score << " -> 等级 " << grade << endl;

    // 求最大值
    int p = 100, q = 200;
    int max = (p > q) ? p : q;
    cout << "最大值: " << max << endl;

    return 0;
}''',
          description: '演示关系运算符、逻辑运算符、短路求值和三目运算符的使用。',
          output: '''关系运算符 (a=10, b=20):
a == b: 0
a != b: 1
a < b:  1
a > b:  0
a <= b: 1
a >= b: 0

逻辑运算符 (x=true, y=false):
x && y (AND): 0
x || y (OR):  1
!x (NOT):    0

短路求值:
m=5, n after m>10 && ++n>10: 10
m=5, n after m<10 || ++n>10: 10

三目运算符:
分数 85 -> 等级 P
最大值: 200''',
        ),
        CodeExample(
          title: '浮点数比较与复杂条件',
          code: '''#include <iostream>
#include <cmath>
using namespace std;

int main() {
    // 浮点数比较的陷阱
    double d1 = 0.1 + 0.2;
    double d2 = 0.3;

    cout << "浮点数比较陷阱:" << endl;
    cout << "d1 = 0.1 + 0.2 = " << d1 << endl;
    cout << "d2 = 0.3 = " << d2 << endl;
    cout << "d1 == d2: " << (d1 == d2) << endl;  // 可能是 false!

    // 正确的方法：使用 epsilon 比较
    const double EPSILON = 1e-9;
    cout << "fabs(d1 - d2) < EPSILON: " << (fabs(d1 - d2) < EPSILON) << endl;

    // 复杂条件判断 - 判断年份是否为闰年
    cout << "\\n闰年判断 (year % 4 == 0 && year % 100 != 0 || year % 400 == 0):" << endl;
    int years[] = {2000, 2020, 2022, 1900, 2004};
    for (int year : years) {
        bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        cout << year << " 年: " << (isLeap ? "闰年" : "平年") << endl;
    }

    // 组合多个条件
    cout << "\\n年龄分组:" << endl;
    int age = 25;
    if (age < 0 || age > 150) {
        cout << "无效年龄" << endl;
    } else if (age < 18) {
        cout << "未成年人" << endl;
    } else if (age < 60) {
        cout << "成年人" << endl;
    } else {
        cout << "老年人" << endl;
    }

    // 德摩根定律验证
    // !(A || B) == (!A && !B)
    // !(A && B) == (!A || !B)
    bool A = true, B = false;
    cout << "\\n德摩根定律验证:" << endl;
    cout << "!(true || false) = " << !(A || B) << endl;
    cout << "!true && !false = " << (!A && !B) << endl;

    return 0;
}''',
          description: '展示浮点数比较的正确方法，以及复杂条件判断的实际应用。',
          output: '''浮点数比较陷阱:
d1 = 0.1 + 0.2 = 0.3
d2 = 0.3 = 0.3
d1 == d2: 0
fabs(d1 - d2) < EPSILON: 1

闰年判断 (year % 4 == 0 && year % 100 != 0 || year % 400 == 0):
2000 年: 闰年
2020 年: 闰年
2022 年: 平年
1900 年: 平年
2004 年: 闰年

年龄分组:
成年人

德摩根定律验证:
!(true || false) = 0
!true && !false = 0''',
        ),
      ],
      keyPoints: [
        '关系运算符返回 bool 值（true=1, false=0）',
        '逻辑与 && 和逻辑或 || 具有短路求值特性',
        '浮点数比较应使用 epsilon 误差范围，避免直接用 ==',
        '三目运算符适合简单的条件赋值',
        '德摩根定律：!(A||B) 等价于 !A&&!B，!(A&&B) 等价于 !A||!B',
      ],
    ),

    CourseLesson(
      id: 'basics_operators_bitwise',
      title: '位运算符',
      content: '''# 位运算符

位运算符直接操作二进制位，是底层编程和性能优化的重要工具。

## 按位运算符

| 运算符 | 说明 | 示例 |
|--------|------|------|
| `&` | 按位与 (AND) | 两位都为 1 时结果为 1 |
| `\|` | 按位或 (OR) | 任一位为 1 时结果为 1 |
| `^` | 按位异或 (XOR) | 两位不同时结果为 1 |
| `~` | 按位取反 (NOT) | 0 变 1，1 变 0 |

## 移位运算符

| 运算符 | 说明 | 示例 |
|--------|------|------|
| `<<` | 左移 | `a << n` 将 a 的二进制左移 n 位 |
| `>>` | 右移 | `a >> n` 将 a 的二进制右移 n 位 |

## 原码、反码、补码

- 正数：原码 = 反码 = 补码
- 负数：补码 = 反码 + 1

**注意**：右移时，负数可能使用算术右移（符号位填充）。

## 位运算符应用

- `& 1`：判断奇偶
- `| 1`：强制将最低位设为 1
- `^ 1`：翻转最低位
- `<< n`：乘以 2ⁿ
- `>> n`：除以 2ⁿ（向下取整）

## 常用技巧

```cpp
// 设置第 n 位为 1
flag |= (1 << n);

// 清除第 n 位（设为 0）
flag &= ~(1 << n);

// 切换第 n 位
flag ^= (1 << n);

// 检查第 n 位是否为 1
if (flag & (1 << n))

// 获取第 n 位的值
(flag >> n) & 1
```
''',
      codeExamples: [
        CodeExample(
          title: '位运算基础',
          code: '''#include <iostream>
using namespace std;

void printBinary(unsigned int value, int bits = 8) {
    // 打印整数的二进制表示
    for (int i = bits - 1; i >= 0; i--) {
        cout << ((value >> i) & 1);
    }
}

int main() {
    unsigned int a = 12;  // 1100
    unsigned int b = 10;  // 1010

    cout << "位运算符演示 (a=12=1100, b=10=1010):" << endl;
    cout << endl;

    // 按位与 &
    unsigned int andResult = a & b;
    cout << "a & b  = ";
    printBinary(andResult);
    cout << " = " << andResult << " (对应位都为1才为1)" << endl;

    // 按位或 |
    unsigned int orResult = a | b;
    cout << "a | b  = ";
    printBinary(orResult);
    cout << " = " << orResult << " (任一位为1就为1)" << endl;

    // 按位异或 ^
    unsigned int xorResult = a ^ b;
    cout << "a ^ b  = ";
    printBinary(xorResult);
    cout << " = " << xorResult << " (位不同时为1)" << endl;

    // 按位取反 ~
    unsigned int notResult = ~a;
    cout << "~a     = ";
    printBinary(notResult, 8);
    cout << " = " << notResult << " (0变1,1变0)" << endl;

    // 左移 <<
    unsigned int leftShift = a << 2;
    cout << "a << 2 = ";
    printBinary(leftShift);
    cout << " = " << leftShift << " (左移2位，等于乘4)" << endl;

    // 右移 >>
    unsigned int rightShift = a >> 2;
    cout << "a >> 2 = ";
    printBinary(rightShift);
    cout << " = " << rightShift << " (右移2位，等于除4)" << endl;

    return 0;
}''',
          description: '演示按位与、或、异或、取反以及移位运算符的运算过程。',
          output: '''位运算符演示 (a=12=1100, b=10=1010):

a & b  = 00001000 = 8 (对应位都为1才为1)
a | b  = 00001110 = 14 (任一位为1就为1)
a ^ b  = 00000110 = 6 (位不同时为1)
~a     = 11110011 = 4294967283 (0变1,1变0)
a << 2 = 00110000 = 48 (左移2位，等于乘4)
a >> 2 = 00000011 = 3 (右移2位，等于除4)''',
        ),
        CodeExample(
          title: '位运算实用技巧',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 1. 判断奇偶数 (用 & 1)
    cout << "1. 判断奇偶数:" << endl;
    int num = 7;
    cout << num << " 是" << ((num & 1) ? "奇数" : "偶数") << endl;
    num = 8;
    cout << num << " 是" << ((num & 1) ? "奇数" : "偶数") << endl;

    // 2. 交换两个数 (不用临时变量)
    cout << "\\n2. 交换两个数 (使用异或):" << endl;
    int x = 5, y = 9;
    cout << "交换前: x=" << x << ", y=" << y << endl;
    x = x ^ y;
    y = x ^ y;  // y = (x^y)^y = x
    x = x ^ y;  // x = (x^y)^x = y
    cout << "交换后: x=" << x << ", y=" << y << endl;

    // 3. 获取第 n 位的值 (0 或 1)
    cout << "\\n3. 获取第 n 位的值:" << endl;
    unsigned int flag = 0b10110010;
    for (int n = 7; n >= 0; n--) {
        int bit = (flag >> n) & 1;
        cout << "第 " << n << " 位: " << bit << endl;
    }

    // 4. 设置、清除、切换位
    cout << "\\n4. 位操作技巧:" << endl;
    unsigned int data = 0b00001000;  // 第3位为1

    // 设置第1位为1
    unsigned int set = data | (1 << 1);
    cout << "设置第1位: " << set << " (二进制: ";
    for (int i = 7; i >= 0; i--) cout << ((set >> i) & 1);
    cout << ")" << endl;

    // 清除第3位为0
    unsigned int clear = data & ~(1 << 3);
    cout << "清除第3位: " << clear << " (二进制: ";
    for (int i = 7; i >= 0; i--) cout << ((clear >> i) & 1);
    cout << ")" << endl;

    // 切换第2位
    unsigned int toggle = data ^ (1 << 2);
    cout << "切换第2位: " << toggle << " (二进制: ";
    for (int i = 7; i >= 0; i--) cout << ((toggle >> i) & 1);
    cout << ")" << endl;

    // 5. 判断某位是否为1
    cout << "\\n5. 判断第3位是否为1:" << endl;
    unsigned int test = 0b00001100;
    if (test & (1 << 3)) {
        cout << "第3位是 1" << endl;
    } else {
        cout << "第3位是 0" << endl;
    }

    return 0;
}''',
          description: '展示位运算在判断奇偶、交换变量、位操作等实际场景中的应用。',
          output: '''1. 判断奇偶数:
7 是奇数
8 是偶数

2. 交换两个数 (使用异或):
交换前: x=5, y=9
交换后: x=9, y=5

3. 获取第 n 位的值:
第 7 位: 1
第 6 位: 0
第 5 位: 1
第 4 位: 1
第 3 位: 0
第 2 位: 0
第 1 位: 1
第 0 位: 0

4. 位操作技巧:
设置第1位: 10 (二进制: 00001010)
清除第3位: 0 (二进制: 00000000)
切换第2位: 12 (二进制: 00001100)

5. 判断第3位是否为1:
第3位是 1''',
        ),
      ],
      keyPoints: [
        '位运算符直接操作二进制位：&(与)、|(或)、^(异或)、~(取反)',
        '移位运算符：<< 左移（乘以2ⁿ）、>> 右移（除以2ⁿ向下取整）',
        'a ^ a = 0，利用异或可以实现无临时变量交换',
        '& 1 可以判断奇偶数，最低位为1则是奇数',
        '使用 (1 << n) 创建掩码来操作特定位',
      ],
    ),
  ],
);
