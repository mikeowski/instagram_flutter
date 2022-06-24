import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/screens/post_screen.dart';
import 'package:instagram_flutter/screens/userList_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postLength = 0;
  var followers = 0;
  var following = 0;
  bool isFollowing = false;
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
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      setState(() {
        followers = userSnap.data()!["followers"].length;
        following = userSnap.data()!["following"].length;
        isFollowing = userSnap
            .data()!["followers"]
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    void logOut() async {
      String res = await AuthMethods().logOutUser();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      if (res != 'Success') {
        showSnackBar(res, context);
      }
      Navigator.of(context).pop();
    }

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userData["username"],
                style: const TextStyle(fontSize: 20),
              ),
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => logOut(),
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.format_align_justify_outlined,
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData["photoUrl"]),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                builStateColumn(postLength, "posts"),
                                InkWell(
                                    onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserListScreen(
                                              type: 'followers',
                                              userList: userData['followers'],
                                            ),
                                          ),
                                        ),
                                    child: builStateColumn(
                                        followers, "followers")),
                                InkWell(
                                    onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserListScreen(
                                              type: 'following',
                                              userList: userData['following'],
                                            ),
                                          ),
                                        ),
                                    child: builStateColumn(
                                        following, "following")),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowButton(
                                  text: "Sign out",
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  fallowFunction: logOut,
                                )
                              : isFollowing
                                  ? FollowButton(
                                      text: "UnFollow",
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      fallowFunction: () async {
                                        await FirestoreMethods().fallowUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      text: "Follow",
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      fallowFunction: () async {
                                        await FirestoreMethods().fallowUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData["bio"],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot postSnapShot =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostScreen(
                                    snap: postSnapShot,
                                  ),
                                ),
                              ),
                              child: Image(
                                image: NetworkImage(
                                  postSnapShot["postUrl"],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    })
              ],
            ));
  }

  Column builStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
