import 'package:flutter/material.dart';
import 'package:roomy/screens/chat/chat_screen.dart';

class AdminChat extends StatelessWidget {
  static const routeName = '/admin-chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            'Customer Support',
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: ChatScreen()),
          ],
        ));
  }
}
