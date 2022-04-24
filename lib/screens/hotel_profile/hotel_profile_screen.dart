import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/chat/chat_room.dart';
import 'package:roomy/screens/property_details/widgets/details_reviews.dart';
import 'package:roomy/widgets/cached_image.dart';
import 'package:roomy/widgets/property/properties.dart';

class HotelProfileScreen extends StatefulWidget {
  static const routeName = '/hotel-profile';

  @override
  _HotelProfileScreenState createState() => _HotelProfileScreenState();
}

class _HotelProfileScreenState extends State<HotelProfileScreen> {
  int selectedIndex = 0;

  List options = [
    'Services',
    'Reviews',
    'Offers',
  ];

  @override
  Widget build(BuildContext context) {
    final ownerId = ModalRoute.of(context).settings.arguments as String;
    final hotelData = Provider.of<PropertyProvider>(context);

    List pages = [
      HotelProperties(
        id: ownerId,
      ),
      ListView(
        children: hotelData.hotelReviews
            .map((e) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ReviewTile(
                    review: e,
                  ),
                ))
            .toList(),
      ),
      Container()
    ];
    return Scaffold(
      body: Column(
        children: [
          HotelProfileTop(hotelData.hotel),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  options.length,
                  (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: option(options[index], index == selectedIndex))),
            ),
          ),
          Expanded(
            child: pages[selectedIndex],
          )
        ],
      ),
    );
  }

  Widget option(
    String title,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(width: 1, color: kPrimary) : null,
        color: isSelected ? kPrimary : Colors.transparent,
      ),
      child: Text(
        title,
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.w400 : FontWeight.bold),
      ),
    );
  }
}

class HotelProfileTop extends StatelessWidget {
  final UserModel owner;
  HotelProfileTop(this.owner);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Stack(clipBehavior: Clip.none, children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            height: size.height * 0.23,
            child: cachedImage(
              'https://ssl.tzoo-img.com/images/tzoo.97179.8458.679815.AtixHotel.jpg?width=412&spr=3',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Container(
            width: size.width,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400].withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    child: Icon(Icons.arrow_back, color: Colors.white),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      owner.fullName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 30,
                              color: Colors.black,
                              offset: Offset(5, 5),
                            ),
                          ]),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.comment,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final users =
                          Provider.of<ChatProvider>(context, listen: false)
                              .contactedUsers;
                      List<String> room = users.map((e) {
                        return e.chatRoomId.contains(
                                FirebaseAuth.instance.currentUser.uid +
                                    '_' +
                                    owner.userId)
                            ? FirebaseAuth.instance.currentUser.uid +
                                '_' +
                                owner.userId
                            : owner.userId +
                                '_' +
                                FirebaseAuth.instance.currentUser.uid;
                      }).toList();

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(owner.userId)
                          .get()
                          .then((value) {
                        Navigator.of(context)
                            .pushNamed(ChatRoom.routeName, arguments: {
                          'user': UserModel(
                            userId: value['userId'],
                            fullName: value['fullName'],
                            imageUrl: value['profilePic'],
                            isAdmin: value['isAdmin'],
                            lastSeen: value['lastSeen'],
                            isOnline: value['isOnline'],
                          ),
                          'chatRoomId': room.first,
                        });
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          child: Container(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kPrimary,
                      width: 2.5,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedImage(
                        owner.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
