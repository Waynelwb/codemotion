// 课程内容统一导出 - Course Content Unified Export
import 'course_data.dart';

// 基础课程
import 'basics/variables.dart';
import 'basics/operators.dart';
import 'basics/control_flow.dart';
import 'basics/functions.dart';
import 'basics/pointers.dart';
import 'basics/references.dart';

// 面向对象课程
import 'oop/classes.dart';
import 'oop/inheritance.dart';
import 'oop/polymorphism.dart';
import 'oop/encapsulation.dart';

// STL 课程
import 'stl/vectors.dart';
import 'stl/maps.dart';
import 'stl/sets.dart';
import 'stl/algorithms.dart';

// 算法可视化课程
import 'algorithms/sorting.dart';
import 'algorithms/searching.dart';
import 'algorithms/advanced_sorting.dart';
import 'algorithms/algorithm_ideas.dart';

// 数据结构课程
import 'data_structures/graphs.dart';
import 'data_structures/stack.dart';
import 'data_structures/queue.dart';
import 'data_structures/linked_list.dart';
import 'data_structures/binary_tree.dart';

// 高级算法课程
import 'advanced_algorithms/heap_sort.dart';
import 'advanced_algorithms/dynamic_programming.dart';
import 'advanced_algorithms/greedy_algorithm.dart';

// Re-export all content
export 'course_data.dart';
export 'basics/variables.dart';
export 'basics/operators.dart';
export 'basics/control_flow.dart';
export 'basics/functions.dart';
export 'basics/pointers.dart';
export 'basics/references.dart';
export 'oop/classes.dart';
export 'oop/inheritance.dart';
export 'oop/polymorphism.dart';
export 'oop/encapsulation.dart';
export 'stl/vectors.dart';
export 'stl/maps.dart';
export 'stl/sets.dart';
export 'stl/algorithms.dart';
export 'algorithms/sorting.dart';
export 'algorithms/searching.dart';
export 'algorithms/advanced_sorting.dart';
export 'algorithms/algorithm_ideas.dart';
export 'data_structures/graphs.dart';
export 'data_structures/stack.dart';
export 'data_structures/queue.dart';
export 'data_structures/linked_list.dart';
export 'data_structures/binary_tree.dart';
export 'advanced_algorithms/heap_sort.dart';
export 'advanced_algorithms/dynamic_programming.dart';
export 'advanced_algorithms/greedy_algorithm.dart';

/// 所有课程章节列表
final List<CourseChapter> allChapters = [
  // 基础课程
  chapterVariables,
  chapterOperators,
  chapterControlFlow,
  chapterFunctions,
  chapterPointers,
  chapterReferences,

  // 面向对象课程
  chapterClasses,
  chapterInheritance,
  chapterPolymorphism,
  chapterEncapsulation,

  // STL 课程
  chapterVectors,
  chapterMaps,
  chapterSets,
  chapterStlAlgorithms,

  // 算法可视化课程
  chapterSortAlgorithms,
  chapterSearchingAlgorithms,

  // 高级排序与算法思想
  chapterAdvancedSorting,
  chapterAlgorithmStrategies,

  // 数据结构课程
  chapterGraphDataStructure,
  chapterStack,
  chapterQueue,
  chapterLinkedList,
  chapterBinaryTree,

  // 高级算法课程
  chapterHeapSort,
  chapterDynamicProgramming,
  chapterGreedyAlgorithm,
];

/// 按难度分组的课程章节
Map<DifficultyLevel, List<CourseChapter>> getChaptersByDifficulty() {
  final Map<DifficultyLevel, List<CourseChapter>> result = {
    DifficultyLevel.beginner: [],
    DifficultyLevel.intermediate: [],
    DifficultyLevel.advanced: [],
  };

  for (final chapter in allChapters) {
    result[chapter.difficulty]!.add(chapter);
  }

  return result;
}

/// 按类别分组的课程章节
Map<String, List<CourseChapter>> getChaptersByCategory() {
  final Map<String, List<CourseChapter>> result = {};

  for (final chapter in allChapters) {
    final category = chapter.id.split('_').first;
    if (!result.containsKey(category)) {
      result[category] = [];
    }
    result[category]!.add(chapter);
  }

  return result;
}

/// 获取课程章节总数
int getTotalChapters() => allChapters.length;

/// 获取课程总课时数
int getTotalLessons() {
  int total = 0;
  for (final chapter in allChapters) {
    total += chapter.lessons.length;
  }
  return total;
}

/// 查找特定章节
CourseChapter? findChapterById(String id) {
  for (final chapter in allChapters) {
    if (chapter.id == id) {
      return chapter;
    }
  }
  return null;
}

/// 查找特定课程
CourseLesson? findLessonById(String chapterId, String lessonId) {
  final chapter = findChapterById(chapterId);
  if (chapter == null) return null;

  for (final lesson in chapter.lessons) {
    if (lesson.id == lessonId) {
      return lesson;
    }
  }
  return null;
}
