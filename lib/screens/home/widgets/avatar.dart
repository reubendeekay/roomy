import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthProvider>(context).user;
    return Container(
      child: GestureDetector(
        onTap: () {
          ZoomDrawer.of(context).open();
        },
        child: Row(children: [
          CircleAvatar(
            backgroundImage: user.imageUrl != null
                ? CachedNetworkImageProvider(user.imageUrl)
                : AssetImage('assets/images/avatar.png'),
            radius: 19,
          ),
          SizedBox(
            width: 10,
          ),
          user != null
              ? Text(
                  'Hey, ${(user.fullName.split(' '))[0]}',
                  style:
                      kText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                )
              : Text(
                  'Hey, there',
                  style:
                      kText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                )
        ]),
      ),
    );
  }
}
