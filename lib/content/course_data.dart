// CodeMotion 课程数据结构
// Course data structures for CodeMotion

/// 难度等级枚举
enum DifficultyLevel {
  beginner,   // 初级
  intermediate, // 中级
  advanced,   // 高级
}

/// 代码示例
class CodeExample {
  final String title;       // 示例标题
  final String code;         // 代码内容
  final String description;  // 示例说明
  final String? output;      // 预期输出

  const CodeExample({
    required this.title,
    required this.code,
    required this.description,
    this.output,
  });
}

/// 课程课时
class CourseLesson {
  final String id;
  final String title;
  final String content;           // Markdown 格式的理论内容
  final List<CodeExample> codeExamples;  // 代码示例
  final List<String> keyPoints;   // 关键知识点

  const CourseLesson({
    required this.id,
    required this.title,
    required this.content,
    required this.codeExamples,
    required this.keyPoints,
  });
}

/// 课程章节分类
enum CourseCategory {
  basics('基础语法'),
  oop('面向对象'),
  stl('STL 容器与算法'),
  algorithms('算法进阶');

  const CourseCategory(this.label);
  final String label;
}

/// 课程章节
class CourseChapter {
  final String id;
  final String title;
  final String description;
  final DifficultyLevel difficulty;
  final CourseCategory category;
  final List<CourseLesson> lessons;

  const CourseChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.lessons,
  });
}
