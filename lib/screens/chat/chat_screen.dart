import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/screens/chat/widgets/chat_tile.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context).getChats();

    final contacts = Provider.of<ChatProvider>(context).contactedUsers;

    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        ...List.generate(
            contacts.length,
            (index) => ChatTile(
                  roomId: contacts[index].chatRoomId,
                  chatModel: contacts[index],
                )),
        if (contacts.length == 0)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have no unread messages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'When you contact a travely user or customer care, you will be able to see their messages here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
      ],
    );
  }
}
