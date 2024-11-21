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

class Post {
  final int? id;
  final String? title;
  final String? body;
  final int? userId;
  final int? imageId;
  final int countLike;
  final int countDislike;
  final bool liked;
  final bool disliked;
  final User user;
  final String image;

  Post({
    this.id,
    this.title,
    this.body,
    this.userId,
    this.imageId,
    this.countLike = 0,
    this.countDislike = 0,
    this.liked = false,
    this.disliked = false,
    required this.user,
    required this.image
  });

  // Factory method to create an instance from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      userId: json['user_id'] as int?,
      imageId: json['image_id'] as int?,
      image: json['image_url'] as String,
      countLike: json['countLike'] as int? ?? 0,
      countDislike: json['countDislike'] as int? ?? 0,
      liked: json['liked'] as bool? ?? false,
      disliked: json['disliked'] as bool? ?? false,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'imageId': imageId,
      'imageUrl': image,
      'countLike': countLike,
      'countDislike': countDislike,
      'liked': liked,
      'disliked': disliked,
      'user': user.toJson(),
    };
  }
}
