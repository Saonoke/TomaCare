class Plant {
  final String title;
  final String condition;

  const Plant({required this.title, required this.condition});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(title: json['title'], condition: json['condition']);
  }
}
