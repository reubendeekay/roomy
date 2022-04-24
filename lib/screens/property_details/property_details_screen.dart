import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/booking/booking_screen.dart';
import 'package:roomy/screens/bookings/services_list.dart';
import 'package:roomy/screens/chat/chat_room.dart';
import 'package:roomy/screens/hotel_profile/hotel_profile_screen.dart';
import 'package:roomy/screens/property_details/widgets/360_dialog.dart';
import 'package:roomy/screens/property_details/widgets/details_description.dart';
import 'package:roomy/screens/property_details/widgets/details_reviews.dart';
import 'package:roomy/screens/property_details/widgets/top_images.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomy/widgets/rating_bar.dart';

class PropertyDetailsScreen extends StatefulWidget {
  static const routeName = '/property-details';

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final property = ModalRoute.of(context).settings.arguments as PropertyModel;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    isLiked = user.wishlist.contains(property.id);

    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(clipBehavior: Clip.none, children: [
          SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: size.height * 0.4,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text('',
                        style: TextStyle(fontSize: 15.0, shadows: [
                          Shadow(
                              color: Theme.of(context).primaryColor,
                              blurRadius: 5)
                        ])),
                    background: Stack(
                      children: [
                        Hero(
                            tag: property.id,
                            transitionOnUserGestures: true,
                            child: TopImages(
                                [property.coverImage, ...property.images])),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: Text(
                              'KES ${property.price}/${property.rates.toLowerCase().replaceAll('per ', '')}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, i) => DetailsBody(property),
                        childCount: 1))
              ],
            ),
          ),
          if (property.propertyCategory.toLowerCase() != 'shopping')
            Positioned(
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                width: size.width,
                color: Theme.of(context).primaryColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            print(property.price);

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 200),
                                child: BookingScreen(
                                  property: property,
                                ),
                              ),
                            );
                            Provider.of<BookingProvider>(context, listen: false)
                                .intialize(double.parse(property.price));
                          },
                          color: kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Transform.scale(
                                    scale: 1.8,
                                    child: Lottie.asset('assets/book.json')),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Book now',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final users =
                              Provider.of<ChatProvider>(context, listen: false)
                                  .contactedUsers;
                          List<String> room = users.map((e) {
                            return e.chatRoomId.contains(
                                    FirebaseAuth.instance.currentUser.uid +
                                        '_' +
                                        user.userId)
                                ? FirebaseAuth.instance.currentUser.uid +
                                    '_' +
                                    user.userId
                                : user.userId +
                                    '_' +
                                    FirebaseAuth.instance.currentUser.uid;
                          }).toList();

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(property.ownerId)
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
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: kPrimary, width: 2),
                                shape: BoxShape.circle),
                            child: FaIcon(FontAwesomeIcons.comments,
                                color: kPrimary, size: 20)),
                      ),
                    ]),
              ),
            ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: kPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      Provider.of<AuthProvider>(context, listen: false)
                          .addToWishList(property.id, isLiked);
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class DetailsBody extends StatefulWidget {
  final PropertyModel property;
  DetailsBody(this.property);
  @override
  _DetailsBodyState createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    List screens = [
      DetailsDescription(widget.property),
      PropertyReviews(
        property: widget.property,
      ),
      ServicesList(widget.property),
    ];
    final size = MediaQuery.of(context).size;
    return Container(
        // height: size.height * 0.55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30),
          ),
        ),
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.property.name}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Ratings(rating: widget.property.rating),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${widget.property.reviews != null ? widget.property.reviews.length : 0} reviews',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<PropertyProvider>(context, listen: false)
                          .getHotelOwner(widget.property.ownerId);
                      Provider.of<PropertyProvider>(context, listen: false)
                          .getUserReviews(widget.property.ownerId);
                      Navigator.of(context).pushNamed(
                          HotelProfileScreen.routeName,
                          arguments: widget.property.ownerId);
                    },
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.property.ownerId)
                              .get(),
                          builder: (ctx, data) => data.connectionState ==
                                  ConnectionState.waiting
                              ? CircleAvatar(
                                  radius: 19,
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                )
                              : CircleAvatar(
                                  radius: 19,
                                  backgroundImage: CachedNetworkImageProvider(
                                      data.data['profilePic']),
                                ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'View profile',
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: kPrimary,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.property.location.town}, ${widget.property.location.country}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 1,
              height: 2,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 30,
                          color:
                              selectedOption == 0 ? kPrimary : Colors.grey[300],
                        ),
                        Text(
                          'Information',
                          style: TextStyle(
                              color: selectedOption == 0
                                  ? kPrimary
                                  : Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 2;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.buffer,
                          size: 25,
                          color:
                              selectedOption == 2 ? kPrimary : Colors.grey[300],
                        ),
                        Text(
                          'Services',
                          style: TextStyle(
                              color: selectedOption == 2
                                  ? kPrimary
                                  : Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 30,
                          color:
                              selectedOption == 1 ? kPrimary : Colors.grey[300],
                        ),
                        Text(
                          'Reviews',
                          style: TextStyle(
                              color: selectedOption == 1
                                  ? kPrimary
                                  : Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  children: [
                                    Experimental360Alert(widget.property)
                                  ]));
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.sync,
                          size: 30,
                          color: Colors.grey[300],
                        ),
                        Text(
                          '360 View',
                          style: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: screens[selectedOption],
            ),
            SizedBox(
              height: 40,
            )
          ]),
        ));
  }
}
