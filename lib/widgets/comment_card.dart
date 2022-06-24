import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/userList_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final postId;
  const CommentCard({Key? key, required this.snap, required this.postId})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          //Profile image
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  uid: widget.snap['uid'],
                ),
              ),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.snap['profilePic'],
              ),
              radius: 18,
            ),
          ),
          //user name - comment
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.snap['uid'],
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                              text: ' ' + widget.snap['text'],
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(
                              DateTime.parse(
                                widget.snap['datePublished']
                                    .toDate()
                                    .toString(),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: secondaryColor,
                            ),
                          ),
                          widget.snap['likes'].length != 0
                              ? InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserListScreen(
                                        type: 'likes',
                                        userList: widget.snap['likes'],
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '   ' +
                                        widget.snap['likes'].length.toString() +
                                        ' likes',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryColor,
                                    ),
                                  ),
                                )
                              : const Text(""),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: LikeAnimation(
              isAnimating: widget.snap['likes']
                  .contains(FirebaseAuth.instance.currentUser!.uid),
              smallLike: true,
              duration: const Duration(milliseconds: 400),
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().likeComments(
                    widget.postId,
                    widget.snap['commentId'],
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.snap['likes'],
                  );
                },
                icon: widget.snap['likes']
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
