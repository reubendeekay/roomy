import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/models/property_model.dart';

class AdminPropertyReviews extends StatelessWidget {
  final PropertyModel property;
  AdminPropertyReviews({@required this.property});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {},
                  child: Row(children: [
                    const Text(
                      'Give a Review',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimary,
                          fontSize: 16),
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
            ],
          ),
          Text(
            'Customer Reviews\t(${property.reviews.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: Center(child: Text('Reviews will be here')),
          ),
        ],
      ),
    );
  }
}
