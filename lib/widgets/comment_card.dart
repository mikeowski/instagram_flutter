import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

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
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://kstu.edu.tr/kstu-file/uploads/default-user-image.png'),
            radius: 18,
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' This is a comment',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      '08/03/2022',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: secondaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.favorite_outline,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
