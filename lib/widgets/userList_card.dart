import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';

class UserListCard extends StatefulWidget {
  final String uid;
  const UserListCard({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserListCard> createState() => _UserListCardState();
}

class _UserListCardState extends State<UserListCard> {
  var userData = {};
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userData = userSnap.data()!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: widget.uid,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      userData['photoUrl'],
                    ),
                    radius: 30,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      userData['username'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  )),
                ],
              ),
            ),
          );
  }
}
