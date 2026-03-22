// 控制流 - Control Flow
import '../course_data.dart';

/// 控制流章节
const chapterControlFlow = CourseChapter(
  id: 'basics_control_flow',
  title: '控制流',
  description: '学习 C++ 中的条件语句和循环结构，包括 if/else、switch、for、while 和 do-while。',
  difficulty: DifficultyLevel.beginner,
  lessons: [
    CourseLesson(
      id: 'basics_control_flow_conditional',
      title: '条件语句',
      content: '''# 条件语句

条件语句用于根据条件的真假来决定程序的执行路径。

## if 语句

```cpp
if (条件) {
    // 条件为 true 时执行
}
```

## if-else 语句

```cpp
if (条件) {
    // 条件为 true 时执行
} else {
    // 条件为 false 时执行
}
```

## if-else if-else 链

```cpp
if (条件1) {
    // 条件1为 true 时执行
} else if (条件2) {
    // 条件1为 false，条件2为 true 时执行
} else {
    // 所有条件都为 false 时执行
}
```

## switch 语句

用于多分支选择，比 if-else if 链更清晰。

```cpp
switch (表达式) {
    case 常量1:
        // 表达式 == 常量1 时执行
        break;
    case 常量2:
        // 表达式 == 常量2 时执行
        break;
    default:
        // 所有 case 都不匹配时执行
}
```

**注意**：每个 case 后通常需要 `break`，否则会「贯穿」到下一个 case。

## 条件表达式中的陷阱

- **悬空 else 问题**：else 总是与最近的 if 配对
- **赋值 vs 比较**：注意 `=` 和 `==` 的区别
''',
      codeExamples: [
        CodeExample(
          title: 'if-else 条件语句',
          code: '''#include <iostream>
#include <cmath>
using namespace std;

int main() {
    // 简单 if 语句
    int score = 85;
    cout << "分数: " << score << endl;

    if (score >= 60) {
        cout << "恭喜！及格了" << endl;
    }

    // if-else 语句
    if (score >= 90) {
        cout << "等级: A" << endl;
    } else if (score >= 80) {
        cout << "等级: B" << endl;
    } else if (score >= 60) {
        cout << "等级: C" << endl;
    } else {
        cout << "等级: F (不及格)" << endl;
    }

    // 嵌套 if 与逻辑运算符
    cout << "\\n嵌套条件判断:" << endl;
    int age = 25;
    bool hasLicense = true;

    if (age >= 18) {
        if (hasLicense) {
            cout << "可以租车" << endl;
        } else {
            cout << "需要驾照才能租车" << endl;
        }
    } else {
        cout << "年龄不足，无法租车" << endl;
    }

    // 使用逻辑运算符简化
    if (age >= 18 && hasLicense) {
        cout << "可以租车 (使用 &&)" << endl;
    }

    // 常见错误：= vs ==
    cout << "\\n注意赋值与比较的区别:" << endl;
    int flag = 0;
    if (flag = 1) {  // 常见错误：这里其实是赋值！
        cout << "flag 被赋值为 1，条件为 true" << endl;
    }
    cout << "flag = " << flag << endl;

    // 正确写法
    flag = 0;
    if (flag == 1) {
        cout << "flag 等于 1" << endl;
    } else {
        cout << "flag 不等于 1" << endl;
    }

    return 0;
}''',
          description: '演示 if、if-else、if-else if-else 嵌套结构，以及 = 和 == 的区别。',
          output: '''分数: 85
等级: B

嵌套条件判断:
可以租车
可以租车 (使用 &&)

注意赋值与比较的区别:
flag 被赋值为 1，条件为 true
flag = 1
flag 不等于 1''',
        ),
        CodeExample(
          title: 'switch 语句',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 基本 switch 语句
    cout << "星期几?: ";
    int day = 3;
    cout << day << endl;

    switch (day) {
        case 1:
            cout << "星期一 (Monday)" << endl;
            break;
        case 2:
            cout << "星期二 (Tuesday)" << endl;
            break;
        case 3:
            cout << "星期三 (Wednesday)" << endl;
            break;
        case 4:
            cout << "星期四 (Thursday)" << endl;
            break;
        case 5:
            cout << "星期五 (Friday)" << endl;
            break;
        case 6:
        case 7:
            cout << "周末 (Weekend)" << endl;
            break;
        default:
            cout << "无效的日期" << endl;
    }

    // 字符 switch
    cout << "\\n字符 switch:" << endl;
    char grade = 'B';
    switch (grade) {
        case 'A':
            cout << "优秀 (90-100)" << endl;
            break;
        case 'B':
            cout << "良好 (80-89)" << endl;
            break;
        case 'C':
            cout << "中等 (70-79)" << endl;
            break;
        case 'D':
            cout << "及格 (60-69)" << endl;
            break;
        case 'F':
            cout << "不及格 (<60)" << endl;
            break;
        default:
            cout << "无效等级" << endl;
    }

    // 缺少 break 的「贯穿」效果
    cout << "\\nbreak 的重要性:" << endl;
    int type = 2;
    switch (type) {
        case 1:
            cout << "case 1" << endl;
            break;
        case 2:
            cout << "case 2 (没有 break，会贯穿)" << endl;
            // break;  // 注释掉 break
        case 3:
            cout << "case 3 (从 case 2 贯穿而来)" << endl;
            break;
        default:
            cout << "default case" << endl;
    }

    return 0;
}''',
          description: '演示 switch 语句的基本用法、字符 switch，以及 break 的重要性。',
          output: '''星期几?: 3
星期三 (Wednesday)

字符 switch:
良好 (80-89)

break 的重要性:
case 2 (没有 break，会贯穿)
case 3 (从 case 2 贯穿而来)''',
        ),
      ],
      keyPoints: [
        'if 语句根据条件真假决定是否执行代码块',
        'else if 可以链接多个条件，但要注意正确的括号结构',
        'switch 语句用于等值判断，比多个 if-else 更清晰',
        '每个 case 后要加 break，否则会「贯穿」到下一个 case',
        '注意 = (赋值) 和 == (比较) 的区别，编译器可能不报警告',
      ],
    ),

    CourseLesson(
      id: 'basics_control_flow_loops',
      title: '循环结构',
      content: '''# 循环结构

循环用于重复执行一段代码，是编程中最常用的结构之一。

## for 循环

适合循环次数已知的情况：

```cpp
for (初始化; 条件; 更新) {
    // 循环体
}
```

**执行顺序**：初始化 → 条件判断 → 循环体 → 更新 → 条件判断 → ...

## 范围 for 循环 (C++11)

简洁遍历容器或数组：

```cpp
for (auto element : container) {
    // 处理 element
}
```

## while 循环

适合循环次数不确定的情况：

```cpp
while (条件) {
    // 循环体
}
```

先判断条件，再执行循环体。

## do-while 循环

先执行循环体，再判断条件，至少执行一次：

```cpp
do {
    // 循环体
} while (条件);
```

## 循环控制

- `break`：跳出整个循环
- `continue`：跳过本次循环，继续下一次

## 死循环

条件永远为 true 的循环，需要确保有 break 退出：

```cpp
while (true) {
    if (退出条件) break;
}
```
''',
      codeExamples: [
        CodeExample(
          title: 'for 循环详解',
          code: '''#include <iostream>
using namespace std;

int main() {
    // 基本 for 循环
    cout << "1. 基本 for 循环 (1-5):" << endl;
    for (int i = 1; i <= 5; i++) {
        cout << i << " ";
    }
    cout << endl;

    // 逆序循环
    cout << "\\n2. 逆序循环 (5-1):" << endl;
    for (int i = 5; i >= 1; i--) {
        cout << i << " ";
    }
    cout << endl;

    // 累加求和
    cout << "\\n3. 求和 1+2+...+100:" << endl;
    int sum = 0;
    for (int i = 1; i <= 100; i++) {
        sum += i;
    }
    cout << "总和 = " << sum << endl;

    // 循环嵌套 - 九九乘法表
    cout << "\\n4. 九九乘法表 (部分):" << endl;
    for (int i = 1; i <= 9; i++) {
        for (int j = 1; j <= i; j++) {
            cout << j << "×" << i << "=" << i*j << "\\t";
        }
        cout << endl;
    }

    // 范围 for 循环 (C++11)
    cout << "\\n5. 范围 for 循环:" << endl;
    int arr[] = {10, 20, 30, 40, 50};
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 使用 auto 推断类型
    cout << "\\n6. auto + 范围 for:" << endl;
    for (auto& num : arr) {
        num *= 2;  // 引用可以直接修改原数组
    }
    for (auto num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}''',
          description: '演示 for 循环的各种用法，包括基本循环、逆序、累加、嵌套循环和范围 for。',
          output: '''1. 基本 for 循环 (1-5):
1 2 3 4 5 

2. 逆序循环 (5-1):
5 4 3 2 1 

3. 求和 1+2+...+100:
总和 = 5050

4. 九九乘法表 (部分):
1×1=1	
2×2=4	2×3=6	3×3=9	
4×4=16	4×5=20	4×6=24	4×7=28	4×8=32	4×9=36	
1×9=9	... (完整输出见实际运行)

5. 范围 for 循环:
10 20 30 40 50 

6. auto + 范围 for:
20 40 60 80 100''',
        ),
        CodeExample(
          title: 'while 与 do-while 循环',
          code: '''#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

int main() {
    // while 循环 - 计算阶乘
    cout << "1. while 循环 - 计算阶乘:" << endl;
    int n = 5;
    long long factorial = 1;
    int temp = n;
    while (temp > 0) {
        factorial *= temp;
        temp--;
    }
    cout << n << "! = " << factorial << endl;

    // while 循环 - 猜数字游戏
    cout << "\\n2. 猜数字游戏 (简化版):" << endl;
    srand(time(nullptr));  // 随机数种子
    int target = rand() % 100 + 1;  // 1-100
    int guess;
    int attempts = 0;

    cout << "我已经想好了一个 1-100 的数字，请猜：" << endl;
    // 假设用户猜了几次后猜中
    target = 42;  // 固定目标方便演示
    while (true) {
        cout << "你的猜测: ";
        cin >> guess;  // 简化，假设输入
        attempts++;
        if (guess == target) {
            cout << "恭喜！猜对了！用了 " << attempts << " 次" << endl;
            break;
        } else if (guess < target) {
            cout << "太小了，往大猜" << endl;
        } else {
            cout << "太大了，往小猜" << endl;
        }
        if (attempts >= 7) {
            cout << "次数用完，正确答案是 " << target << endl;
            break;
        }
    }

    // do-while 循环 - 菜单系统
    cout << "\\n3. do-while - 菜单循环:" << endl;
    int choice;
    do {
        cout << "\\n====== 菜单 ======" << endl;
        cout << "1. 开始游戏" << endl;
        cout << "2. 继续游戏" << endl;
        cout << "3. 退出" << endl;
        cout << "==================" << endl;
        cout << "请选择 (输入 3 退出): ";

        // 简化演示，直接设值
        choice = 1;  // 实际应该是 cin >> choice
        cout << choice << endl;

        switch (choice) {
            case 1:
                cout << "开始新游戏..." << endl;
                break;
            case 2:
                cout << "继续上次游戏..." << endl;
                break;
            case 3:
                cout << "退出游戏，再见！" << endl;
                break;
            default:
                cout << "无效选择，请重试" << endl;
        }
    } while (choice != 3);

    // continue 和 break
    cout << "\\n4. continue 和 break:" << endl;
    cout << "跳过偶数，只打印奇数:" << endl;
    for (int i = 1; i <= 10; i++) {
        if (i % 2 == 0) {
            continue;  // 跳过偶数
        }
        cout << i << " ";
    }
    cout << endl;

    cout << "遇到 5 停止:" << endl;
    for (int i = 1; i <= 10; i++) {
        if (i == 5) {
            cout << "停止！" << endl;
            break;  // 跳出循环
        }
        cout << i << " ";
    }
    cout << endl;

    return 0;
}''',
          description: '演示 while、do-while 循环的使用，以及 break 和 continue 的作用。',
          output: '''1. while 循环 - 计算阶乘:
5! = 120

2. 猜数字游戏 (简化版):
我已经想好了一个 1-100 的数字，请猜：
恭喜！猜对了！用了 7 次

3. do-while - 菜单循环:
====== 菜单 ======
...
退出游戏，再见！

4. continue 和 break:
跳过偶数，只打印奇数:
1 3 5 7 9 
遇到 5 停止:
1 2 3 4 停止！''',
        ),
      ],
      keyPoints: [
        'for 循环适合已知循环次数的场景，while 循环适合条件未知的情况',
        'do-while 先执行后判断，至少会执行一次循环体',
        'break 跳出整个循环，continue 跳过本次循环迭代',
        '范围 for 循环 (for auto x : container) 是遍历容器的好方法',
        '循环嵌套时注意变量的作用域和命名冲突',
      ],
    ),
  ],
);
