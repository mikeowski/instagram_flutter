import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class PostScreen extends StatefulWidget {
  final snap;
  const PostScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.snap['username'],
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: PostCard(
          snap: widget.snap,
        ),
      ),
    );
  }
}
