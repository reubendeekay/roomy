import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: kPrimary,
        ),
        onPressed: press as void Function(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18 / 375.0 * size.width,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
