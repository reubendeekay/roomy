import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/screens/users/widgets/user_list_profile.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/user_model.dart';

class UserListTile extends StatelessWidget {
  UserListTile(this.user);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context, builder: (ctx) => UserListProfile(user));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider((user.imageUrl)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
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
                        height: 5,
                      ),
                      Text(user.email,
                          style: TextStyle(
                              fontSize: 13, color: Colors.blueGrey[400]))
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
        ]),
      ),
    );
  }
}
