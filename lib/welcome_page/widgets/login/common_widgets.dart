import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:roomy/constants.dart';

class FindOutLogo extends StatelessWidget {
  const FindOutLogo({
    Key key,
    this.fontSize = 60.0,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fontSize * 4.4,
      child: Hero(
        tag: 'logo',
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cardinal',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                heightFactor: .3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Re',
                      style: GoogleFonts.poppins(
                        height: .4,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.search,
                      size: fontSize * .7,
                      color: kPrimary,
                    ),
                    Text(
                      'lty',
                      style: GoogleFonts.poppins(
                        height: .4,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindOutHorizontalLogo extends StatelessWidget {
  const FindOutHorizontalLogo({
    Key key,
    this.fontSize = 28.0,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.poppins(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      shadows: const [
        Shadow(
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
    );
    return Hero(
      tag: 'horizontal_logo',
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Text('travely', style: style),
            Icon(
              FontAwesomeIcons.search,
              size: fontSize * .8,
              color: kPrimary,
            ),
            Text(
              'pp',
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
