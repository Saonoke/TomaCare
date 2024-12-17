class Information {
  final String title;
  final String content;
  final String medicine;
  final String type;

  const Information(
      {required this.title,
      required this.content,
      required this.medicine,
      required this.type});

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
        title: json['title'],
        content: json['content'],
        type: json['type'],
        medicine: json['medicine']);
  }
}
