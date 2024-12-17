class Task {
  bool done;
  final int id;
  final String title;
  final String tanggal;

  Task(
      {required this.done,
      required this.id,
      required this.title,
      required this.tanggal});

  factory Task.fromJson(Map<String, dynamic> json) {
    print(json);
    return Task(
        done: json['done'],
        id: json['id'],
        title: json['title'],
        tanggal: json['tanggal']);
  }

  Map<String, dynamic> toJson() {
    return {'done': done, 'id': id, 'title': title, 'tanggal': tanggal};
  }
}
