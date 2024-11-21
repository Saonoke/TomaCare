class User {
  final int id;
  final String fullName;
  final String profileImg;

  User({
    required this.id,
    required this.fullName,
    required this.profileImg,
  });

  // Factory method to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      profileImg: json['profile_img'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profileImg': profileImg,
    };
  }
}