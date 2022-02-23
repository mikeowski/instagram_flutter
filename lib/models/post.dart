import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {required this.username,
      required this.uid,
      required this.description,
      required this.postId,
      required this.postUrl,
      required this.datePublished,
      required this.profImage,
      required this.likes});

  static Post fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postId: snapshot["postId"],
      postUrl: snapshot["postUrl"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
      };
}
