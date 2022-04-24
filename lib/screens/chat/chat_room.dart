import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/get_helpers.dart';
import 'package:roomy/models/message_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/screens/chat/add_message.dart';
import 'package:roomy/screens/chat/widgets/chat_bubble.dart';

class ChatRoom extends StatelessWidget {
  static const routeName = '/chat-room';
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    final size = MediaQuery.of(context).size;
    final chatRoomData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final UserModel user = chatRoomData['user'];
    final chatRoomId = chatRoomData['chatRoomId'];

    build(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 25,
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: CachedNetworkImageProvider(user.imageUrl),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (user.isAdmin)
                          Icon(
                            Icons.verified,
                            color: kPrimary,
                            size: 16,
                          )
                      ],
                    ),
                    Text(
                      user.isOnline
                          ? 'online'
                          : 'last seen ' +
                              getCreatedAt(Timestamp.fromMicrosecondsSinceEpoch(
                                  user.lastSeen)),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: user.isOnline ? Colors.green : Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            constraints: BoxConstraints(maxHeight: 10, minHeight: 10),
            icon: Icon(
              Icons.call,
              size: 20,
            ),
            onPressed: () {},
          ),
          moreVert()
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isDark
                ? AssetImage('assets/images/chatb.jpg')
                : AssetImage('assets/images/chatw.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatRoomId)
                    .collection('messages')
                    .orderBy('sentAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(child: Container());
                  }

                  return Expanded(
                    child: ListView.builder(
                      // reverse: true,
                      controller: _scrollController,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data.docs[index];

                        build(context);
                        return ChatBubble(MessageModel(
                          message: message['message'],
                          isRead: message['isRead'],
                          sentAt: message['sentAt'],
                          senderId: message['sender'],
                          mediaType: message['mediaType'],
                          mediaUrl: message['media'],
                        ));
                      },
                    ),
                  );
                }),
            AddMessage(
              userId: user.userId,
            ),
            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget moreVert() {
    return PopupMenuButton(
        elevation: 1,
        itemBuilder: (xtx) => options
            .map((e) => PopupMenuItem(
                    child: Text(
                  e,
                  style: TextStyle(fontSize: 15),
                )))
            .toList(),
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey,
        ));
  }

  List options = [
    'Search',
    'Mute notifications',
    'Clear chat',
    'Report',
    'Block'
  ];
}
