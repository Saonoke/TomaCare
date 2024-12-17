import 'package:tomacare/domain/entities/task.dart';

class Plant {
  final String title;
  final String condition;
  final bool? done;
  final String image_path;
  final List<Task>? tasks;
  final int? id;
  final String? date;

  const Plant(
      {required this.title,
      required this.condition,
      required this.image_path,
      this.done,
      this.id,
      this.tasks,
      this.date});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        title: json['title'],
        done: json['done'],
        condition: json['condition'],
        tasks: json['tasks'],
        id: json['id'],
        image_path: json['image']['image_path'],
        date: json['created_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'condition': condition,
      'image_path': image_path,
      'created_at': date
    };
  }
}
