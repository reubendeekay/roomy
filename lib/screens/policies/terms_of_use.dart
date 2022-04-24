import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';

class TermsofUse extends StatelessWidget {
  static const routeName = '/terms-of-use';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Use',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).iconTheme.color),
        ),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Text(
              kTermsandConditions,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
