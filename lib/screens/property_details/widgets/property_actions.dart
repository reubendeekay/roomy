import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/screens/bookings/manage_bookings_screen.dart';
import 'package:roomy/admin/screens/manage_property/delete_property_screen.dart';
import 'package:roomy/admin/screens/manage_property/edit_property_screen.dart';

import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/widgets/cached_image.dart';

class PropertyActions extends StatelessWidget {
  final PropertyModel property;
  PropertyActions(this.property);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (ctx, controller) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey[100]),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: cachedImage(
                      property.coverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actionButton(
                      title: 'View Travely',
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            PropertyDetailsScreen.routeName,
                            arguments: property);
                      }),
                  actionButton(
                    title: 'Edit Travely',
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          EditPropertyScreen.routeName,
                          arguments: property);
                    },
                  ),
                  actionButton(
                      title: 'View Bookings',
                      onTap: () {
                        Get.to(() => ManageBookingsScreen(
                              property: property,
                            ));
                      }),
                  actionButton(
                    title: 'Travely Analytics',
                  ),
                  actionButton(
                    title: 'Promote Travely',
                  ),
                  actionButton(
                      title: 'Delete Travely',
                      onTap: () {
                        Get.to(() => DeletePropertyScreen(property));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton({String title, Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(width: 1, color: Colors.blueGrey)),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          )),
    );
  }
}
