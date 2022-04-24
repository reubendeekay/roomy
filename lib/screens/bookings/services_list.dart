import 'package:flutter/material.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/booking/widgets/service_tile.dart';

class ServicesList extends StatelessWidget {
  final PropertyModel property;
  ServicesList(this.property);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      shrinkWrap: true,
      children: List.generate(property.services.length,
          (index) => ServiceTile(property.services[index])),
    ));
  }
}
