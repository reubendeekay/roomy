import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';

class PrivacyPolicy extends StatelessWidget {
  static const routeName = '/privacy-policy';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
              kPrivacyTerms,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
