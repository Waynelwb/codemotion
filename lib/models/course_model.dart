// Course Model - Course/Chapter/Lesson Data Models
// Extracted common data structures from content files

import 'package:flutter/material.dart';
import '../design/design_system.dart';

/// Course category for grouping courses
enum CourseCategory {
  basics('基础语法', Icons.code, AppColors.primary),
  oop('面向对象', Icons.class_, AppColors.tertiary),
  stl('STL 容器与算法', Icons.science, AppColors.success),
  algorithms('算法进阶', Icons.psychology, AppColors.warning);

  const CourseCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Course difficulty level
enum CourseDifficulty {
  beginner('入门', AppColors.success),
  intermediate('进阶', AppColors.warning),
  advanced('高级', AppColors.error);

  const CourseDifficulty(this.label, this.color);
  final String label;
  final Color color;
}

/// Code example within a lesson
class CourseCodeExample {
  final String title;
  final String code;
  final String description;
  final String? output;

  const CourseCodeExample({
    required this.title,
    required this.code,
    required this.description,
    this.output,
  });
}

/// Individual lesson within a chapter
class CourseLessonModel {
  final String id;
  final String title;
  final String content;
  final List<CourseCodeExample> codeExamples;
  final List<String> keyPoints;

  const CourseLessonModel({
    required this.id,
    required this.title,
    required this.content,
    required this.codeExamples,
    required this.keyPoints,
  });
}

/// Course chapter containing multiple lessons
class CourseChapterModel {
  final String id;
  final String title;
  final String description;
  final CourseDifficulty difficulty;
  final CourseCategory category;
  final List<CourseLessonModel> lessons;

  const CourseChapterModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.lessons,
  });

  int get totalLessons => lessons.length;
}

/// Course overview card data
class CourseOverviewModel {
  final String id;
  final String title;
  final String description;
  final CourseDifficulty difficulty;
  final CourseCategory category;
  final IconData icon;
  final double? progress;
  final List<String> tags;
  final int lessonCount;

  const CourseOverviewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.icon,
    this.progress,
    this.tags = const [],
    this.lessonCount = 0,
  });
}

/// Learning path stage
class LearningPathStage {
  final int step;
  final String title;
  final String description;
  final CourseCategory category;
  final Color color;
  final List<CourseOverviewModel> courses;

  const LearningPathStage({
    required this.step,
    required this.title,
    required this.description,
    required this.category,
    required this.color,
    required this.courses,
  });
}
