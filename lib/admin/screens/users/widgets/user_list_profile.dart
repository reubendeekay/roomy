import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/providers/admin_user_provider.dart';
import 'package:roomy/admin/screens/users/widgets/admin_update_profile.dart';
import 'package:roomy/constants.dart';

import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/screens/chat/chat_room.dart';
import 'package:roomy/widgets/done_icon.dart';

class UserListProfile extends StatefulWidget {
  final UserModel user;
  UserListProfile(this.user);

  @override
  State<UserListProfile> createState() => _UserListProfileState();
}

class _UserListProfileState extends State<UserListProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            topProfile(widget.user),
            const SizedBox(height: 10),
            actionButton(
                title: 'Update Profile',
                onTap: () {
                  Get.to(() => AdminUpdateProfile(user: widget.user));
                }),
            actionButton(
              title: 'Reset Password',
            ),
            actionButton(
                title: widget.user.isAdmin ? 'Revoke Admin' : 'Make Admin',
                onTap: () async {
                  await Provider.of<AdminUserProvider>(context, listen: false)
                      .makeAdmin(widget.user.userId, widget.user.isAdmin);

                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            content: DoneIcon(),
                          ));
                  Future.delayed(Duration(milliseconds: 2300), () {
                    Navigator.of(context).pop();
                  });
                  setState(() {
                    widget.user.isAdmin = !widget.user.isAdmin;
                  });
                }),
            actionButton(
                title: 'Contact User',
                onTap: () {
                  final users =
                      Provider.of<ChatProvider>(context, listen: false)
                          .contactedUsers;
                  List<String> room = users.map((e) {
                    return e.chatRoomId.contains(
                            FirebaseAuth.instance.currentUser.uid +
                                '_' +
                                widget.user.userId)
                        ? FirebaseAuth.instance.currentUser.uid +
                            '_' +
                            widget.user.userId
                        : widget.user.userId +
                            '_' +
                            FirebaseAuth.instance.currentUser.uid;
                  }).toList();

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.userId)
                      .get()
                      .then((value) {
                    Navigator.of(context)
                        .pushNamed(ChatRoom.routeName, arguments: {
                      'user': UserModel(
                        userId: value['userId'],
                        fullName: value['fullName'],
                        imageUrl: value['profilePic'],
                        isAdmin: value['isAdmin'],
                        isOnline: value['isOnline'],
                        lastSeen: value['lastSeen'],
                      ),
                      'chatRoomId': room.first,
                    });
                  });
                }),
            actionButton(
              title: 'Delete Account',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget actionButton({String title, Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(width: 1, color: Colors.blueGrey)),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          )),
    );
  }

  Widget topProfile(UserModel user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: CachedNetworkImageProvider(user.imageUrl),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                if (user.isAdmin)
                  Icon(
                    Icons.verified,
                    color: kPrimary,
                    size: 14,
                  )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.blueGrey[300]),
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Phone: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.blueGrey[300]),
                ),
                Text(
                  user.phoneNumber,
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
