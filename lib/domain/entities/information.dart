class Information {
  final String title;
  final String content;
  final String medicine;

  const Information(
      {required this.title, required this.content, required this.medicine});

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
        title: json['title'],
        content: json['content'],
        medicine: json['medicine']);
  }
}
