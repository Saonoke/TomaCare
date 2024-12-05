class User {
//   final int id;
//   final String fullName;
//   final String profileImg;

//   User({
//     required this.id,
//     required this.fullName,
//     required this.profileImg,
//   });

//   // Factory method to create an instance from JSON
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] as int,
//       fullName: json['full_name'] as String,
//       profileImg: json['profile_img'] as String,
//     );
//   }

//   // Method to convert an instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'profileImg': profileImg,
//     };
//   }
// }
  late final String fullName;
  late final String username;
  late final String email;
  late String profileImg;

  User(
      {required this.fullName,
      required this.username,
      required this.email,
      required this.profileImg});

  // Membuat model dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['full_name'],
      username: json['username'],
      email: json['email'] ?? '',
      profileImg: json['profile_img'],
    );
  }

  // Mengubah model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'email': email,
      'profile_img': profileImg.toString(),
    };
  }
}
