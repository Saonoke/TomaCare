class Plant {
  final String title;
  final String condition;
  final String image_path;

  const Plant(
      {required this.title, required this.condition, required this.image_path});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        title: json['title'],
        condition: json['condition'],
        image_path: json['image']['image_path']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'condition': condition, 'image_path': image_path};
  }
}
