import 'package:flutter/material.dart';

class SecondaryTitle extends StatelessWidget {
  final String title;
  SecondaryTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[400]),
      ),
    );
  }
}
