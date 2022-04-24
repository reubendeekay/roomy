import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/my_slider.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/widgets/property/properties.dart';
import 'package:roomy/widgets/rating_bar.dart';

class PropertyReviews extends StatelessWidget {
  final PropertyModel property;
  PropertyReviews({@required this.property});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (property.reviews.isNotEmpty)
            Container(
              height: 42,
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: kPrimary),
                  borderRadius: BorderRadius.circular(2)),
              child: TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        children: [UserReview(property.id)])),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Give a Review',
                    style: const TextStyle(
                      color: kPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.comment,
                    color: kPrimary,
                    size: 16,
                  ),
                ]),
              ),
            ),
          Text(
            'Customer Reviews\t(${property.reviews != null ? property.reviews.length : 0})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (property.reviews != null)
            const SizedBox(
              height: 10,
            ),
          Reviews(
            property.id,
          ),
        ],
      ),
    );
  }
}

class UserReview extends StatefulWidget {
  final String propertyId;
  UserReview(this.propertyId);
  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  double _rating;
  final reviewController = TextEditingController();
  String feel = '0';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return Container(
      width: size.width,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Leave a Rating',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              SizedBox(
                height: 100,
                child: Transform.scale(
                  scale: 2,
                  child: FlareActor(
                    'assets/feelings.flr',
                    fit: BoxFit.contain,

                    //alignment: Alignment.Center,
                    animation: feel,
                  ),
                ),
              ),
              RatingBar(
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                    if (rating.floor() == 5)
                      feel = '100';
                    else if (rating.floor() == 4)
                      feel = '75';
                    else if (rating.floor() == 3)
                      feel = '50';
                    else if (rating.floor() == 2)
                      feel = '25';
                    else if (rating.floor() == 1)
                      feel = '10';
                    else
                      feel = '0';
                  });
                },
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: kPrimary,
                emptyColor: Colors.amber,
                halfFilledColor: kPrimary,
                size: 30,
              ), // MySlid(),

              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    maxLines: null,
                    controller: reviewController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      labelText: 'Write a review',
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          )),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  if (reviewController.text.isNotEmpty &&
                      _rating != null &&
                      _rating > 0.5) {
                    Provider.of<PropertyProvider>(context, listen: false)
                        .addReview(
                            ReviewModel(
                              rating: _rating,
                              dateReviewed: Timestamp.now(),
                              nameOfReviewer: user.fullName,
                              profilePic: user.imageUrl,
                              review: reviewController.text,
                            ),
                            widget.propertyId);
                  }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                  child: const Text(
                    'Submit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget buildReview() {
    return Container(
      child: RatingBar(
        onRatingChanged: (rating) => setState(() => _rating = rating),
        filledIcon: Icons.star,
        emptyIcon: Icons.star_border,
        halfFilledIcon: Icons.star_half,
        isHalfAllowed: true,
        filledColor: kPrimary,
        emptyColor: Colors.amber,
        halfFilledColor: kPrimary,
        size: 25,
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final String propertyName;
  ReviewTile({this.review, this.propertyName});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(review.profilePic)),
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
                      review.nameOfReviewer,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (propertyName != null)
                      const SizedBox(
                        width: 5,
                      ),
                    if (propertyName != null)
                      Icon(Icons.circle, size: 5, color: Colors.grey),
                    if (propertyName != null)
                      const SizedBox(
                        width: 5,
                      ),
                    if (propertyName != null)
                      Text(
                        propertyName,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Row(
                  children: [
                    Ratings(
                      rating: review.rating,
                    ),
                    Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        review.dateReviewed.toDate(),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Text(
                  review.review,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.grey[400]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
