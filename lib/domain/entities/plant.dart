import 'package:tomacare/domain/entities/task.dart';

class Plant {
  final String title;
  final String condition;
  final String image_path;
  final List<Task>? tasks;
  final int? id;

  const Plant(
      {required this.title,
      required this.condition,
      required this.image_path,
      this.id,
      this.tasks});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        title: json['title'],
        condition: json['condition'],
        tasks: json['tasks'],
        id: json['id'],
        image_path: json['image']['image_path']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'condition': condition, 'image_path': image_path};
  }
}
