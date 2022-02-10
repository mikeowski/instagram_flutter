class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final List fallowers;
  final List fallowing;
  final String photoUrl;

  const User({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.fallowers,
    required this.fallowing,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bio": bio,
        "uid": uid,
        "fallowers": fallowers,
        "fallowing": fallowing,
        "photoUrl": photoUrl
      };
}
