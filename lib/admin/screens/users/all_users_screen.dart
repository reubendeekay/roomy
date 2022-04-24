import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/screens/users/widgets/user_list_tile.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/user_model.dart';

class AllUsersScreen extends StatelessWidget {
  static const routeName = '/all-users-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('All Users', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Search',
                  style: TextStyle(color: Colors.blueGrey[300]),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('fullName')
                .limit(50)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    return UserListTile(UserModel(
                      imageUrl: docs[i]['profilePic'],
                      fullName: docs[i]['fullName'],
                      isAdmin: docs[i]['isAdmin'],
                      email: docs[i]['email'],
                      phoneNumber: docs[i]['phoneNumber'],
                      userId: docs[i].id,
                    ));
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
