import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/property_details/360_view.dart';

class Experimental360Alert extends StatelessWidget {
  final PropertyModel property;
  Experimental360Alert(this.property);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Experimental Feature',
              style: TextStyle(color: kPrimary, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Get 360 degree view of any travely.Be immersed on an intriguing level of experience. This feature is still in development. Please rate this feature to determine its availability in the future.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Continue', style: TextStyle(color: Colors.white)),
              color: kPrimary,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(View360.routeName, arguments: property);
              },
            ),
          ],
        ),
      ),
    );
  }
}
