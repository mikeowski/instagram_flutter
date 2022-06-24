import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/userList_card.dart';

class UserListScreen extends StatefulWidget {
  final String type;
  final userList;
  const UserListScreen({Key? key, required this.type, required this.userList})
      : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.type),
          centerTitle: true,
          backgroundColor: mobileBackgroundColor,
        ),
        body: ListView.builder(
          itemCount: widget.userList.length,
          itemBuilder: (context, index) =>
              UserListCard(uid: widget.userList[index]),
        ));
  }
}
