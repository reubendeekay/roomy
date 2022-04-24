import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/home/view_all_screen.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';
import 'package:roomy/widgets/cached_image.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageList = [
      {
        'destination': 'Mombasa',
        'services': '112 travelies',
        'image':
            'https://www.vacay.co.ke/wp-content/uploads/2014/04/mombasa-holiday.jpg',
        'isImage': true
      },
      {
        'category': 'Activities',
        'term': 'Activity',
        'services': '186 travelies',
        'color': Color(0xff246EE9),
        'isImage': false,
        'imageUrl': 'https://images3.alphacoders.com/172/172745.jpg',
      },
      {
        'destination': 'Zanzibar',
        'services': '186 travelies',
        'image':
            'https://www.royalzanzibar.com/resourcefiles/home-banner/home-masthead-1.jpg',
        'isImage': true
      },
      {
        'destination': 'Nairobi',
        'services': '94 travelies',
        'image':
            'https://images.skyscrapercenter.com/uploads/Nairobi_2021_(PublicDOmain)amani-nation-unsplash210126-050128.jpg',
        'isImage': true
      },
      {
        'destination': 'Dar es Salaam',
        'services': '126 travelies',
        'image':
            'https://www.thecitizen.co.tz/resource/blob/3303212/6475d2871c59f959b153e048cc28d53f/ilala-pic-data.jpg',
        'isImage': true
      },
      {
        'category': 'Hotels',
        'term': 'Hotel',
        'services': '232 travelies',
        'color': Color(0xffFF2400),
        'isImage': false,
        'imageUrl':
            'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
      },
      {
        'destination': 'Diani',
        'services': '216 travelies',
        'image':
            'https://cf.bstatic.com/xdata/images/hotel/max1024x768/219657764.jpg?k=60cd7712f21bc1431220ecfded8bad99102b3daf3276ee346fb2cbd70ab4e141&o=&hp=1',
        'isImage': true
      },
      {
        'category': 'Apartments',
        'term': 'Apartment',
        'services': '56 travelies',
        'color': Colors.teal,
        'isImage': false,
        'imageUrl':
            'https://primeliving.co.ke/wp-content/uploads/2020/07/1.jpg',
      },
      {
        'destination': 'Malindi',
        'services': '186 travelies',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPpG3YpUFfFMRJHGTYNaSQyMgfD7mDHoolPQ&usqp=CAU',
        'isImage': true
      },
      {
        'category': 'Restaurants',
        'term': 'Restaurant',
        'services': '341 travelies',
        'color': Colors.brown,
        'isImage': false,
        'imageUrl':
            'https://www.thebalancesmb.com/thmb/zGPC6q9e57Qo0_-Nf0yZ3UyrBDY=/3865x2576/filters:fill(auto,1)/overhead-view-of-smiling-female-friends-sharing-lunch-in-restaurant-928010348-5b4abe8f46e0fb003712c478.jpg',
      },
      {
        'destination': 'Watamu',
        'services': '177 travelies',
        'image':
            'https://www.hemingways-collection.com/wp-content/uploads/2017/12/watamu-the-area-500x500.jpg',
        'isImage': true
      },
      {
        'destination': 'Masai Mara',
        'services': '256 travelies',
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Masai_Mara_at_Sunset.jpg/284px-Masai_Mara_at_Sunset.jpg',
        'isImage': true
      },
      {
        'destination': 'Naivasha',
        'services': '86 travelies',
        'image':
            'https://www.abercrombiekent.co.uk/-/media/abercrombieandkent/images/page-header-images/africa/kenya/lake-naivasha/lake-naivasha_0010_shutterstock_344974034.jpg?la=en&hash=3317288C2D504F8126ED7ACCF6978C4FC30B1270',
        'isImage': true
      },
      {
        'destination': 'Serengeti',
        'services': '286 travelies',
        'image':
            'http://www.safariafrika.com/wp-content/uploads/2021/07/Elephant_in_Serengeti_Nationalpark_in_Tansania.jpg',
        'isImage': true
      },
      {
        'destination': 'Arusha',
        'services': '36 travelies',
        'image':
            'https://assets.evcdn.net/pim-assets-images/72872/5e9f0dd603fd9.jpeg',
        'isImage': true
      },
      {
        'category': 'Flight Services',
        'term': 'Flight',
        'services': '26 travelies',
        'color': Colors.pink,
        'isImage': false,
        'imageUrl':
            'https://bsmedia.business-standard.com/media-handler.php?mediaPath=https://bsmedia.business-standard.com/_media/bs/img/article/2020-12/19/full/1608318032-013.jpg&width=1200',
      },
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.binoculars),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Discover',
                        style: GoogleFonts.openSans(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      Provider.of<SearchProvider>(context, listen: false)
                          .clearSearch();
                      Navigator.of(context).pushNamed(
                        SearchResultScreen.routeName,
                        arguments: FilterModel(name: val),
                      );
                    }
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: -5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    hintText: 'Search for a destination',
                    hintStyle: GoogleFonts.openSans(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Destinations',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(ViewAllScreen.routeName),
                    child: Text(
                      'View all',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return imageList[index]['isImage']
                          ? GestureDetector(
                              onTap: () {
                                Provider.of<SearchProvider>(context,
                                        listen: false)
                                    .clearSearch();
                                Navigator.of(context).pushNamed(
                                  SearchResultScreen.routeName,
                                  arguments: FilterModel(
                                      location: imageList[index]
                                          ['destination']),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            imageList[index]['image']),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        imageList[index]['destination'],
                                        style: GoogleFonts.openSans(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: Offset(1, 1),
                                              )
                                            ],
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        imageList[index]['services'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: Offset(1, 1),
                                            )
                                          ],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Provider.of<SearchProvider>(context,
                                        listen: false)
                                    .clearSearch();
                                Navigator.of(context).pushNamed(
                                    SearchResultScreen.routeName,
                                    arguments: FilterModel(
                                      category: imageList[index]['term'],
                                      searchTerm: imageList[index]['category'],
                                    ));
                              },
                              child: Container(
                                  child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      child: cachedImage(
                                          imageList[index]['imageUrl'],
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: imageList[index]['color']
                                              .withOpacity(0.65),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          imageList[index]['category'],
                                          style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                    blurRadius: 3,
                                                    color: Colors.grey[900])
                                              ],
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          imageList[index]['services'],
                                          style: TextStyle(shadows: [
                                            Shadow(
                                                blurRadius: 1,
                                                color: Colors.black)
                                          ], color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            );
                    },
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(
                          1, index.isOdd ? 0.7 : 1.2 ?? 1);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
