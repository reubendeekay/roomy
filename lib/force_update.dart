import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/change_log_model.dart';
import 'package:roomy/widgets/cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdates extends StatelessWidget {
  final ChangeLogModel changeLog;
  ForceUpdates({@required this.changeLog});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    child: Transform.scale(
                      scale: 2,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Travely',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      String encodeQueryParameters(Map<String, String> params) {
                        return params.entries
                            .map((e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: changeLog.developerEmail,
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Hello, I have this issue:'
                        }),
                      );

                      launch(emailLaunchUri.toString());
                    },
                    child: Icon(
                      Icons.multitrack_audio_outlined,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Changelog v${changeLog.version}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 8),
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    // enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: changeLog.imageUrls
                      .map((e) => cachedImage(
                            e,
                            fit: BoxFit.cover,
                          ))
                      .toList()),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${changeLog.mainDescription}',
                style: TextStyle(),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.exchangeAlt,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Changes',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            ...List.generate(
              changeLog.changes.length,
              (index) => Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.multitrack_audio_outlined,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          changeLog.changes[index],
                          style: TextStyle(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: RaisedButton(
                    onPressed: () async {
                      await canLaunch(changeLog.downloadUrl['arm64'])
                          ? await launch(changeLog.downloadUrl['arm64'])
                          : throw 'Could not launch url';
                    },
                    color: kPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ))),
            SizedBox(
              height: size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
