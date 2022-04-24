import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:roomy/welcome_page/widgets/animated_background.dart';
import 'package:roomy/welcome_page/widgets/login/common_widgets.dart';
import 'package:roomy/welcome_page/widgets/login/login_page.dart';
import 'package:roomy/welcome_page/widgets/register_page/register_page.dart';
import 'package:roomy/welcome_page/widgets/snake_button.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key key}) : super(key: key);
  final hideNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'Welcome,',
      'Bienvenido,',
      'Benarrivato,',
      'Bienvenue,',
    ];
    List<String> subtitles = [
      'To unforgettable experiences!',
      'A Experiencias inolvidables!',
      'Ad esperienze indimenticabili!',
      'Vers des expériences inoubliables!',
    ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const AnimatedBackground(),
          ValueListenableBuilder(
            valueListenable: hideNotifier,
            builder: (context, dynamic value, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: value ? -100 : 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  opacity: value ? 0.0 : 1.0,
                  child: child,
                ),
              );
            },
            child: Center(
              child: SizedBox(
                height: size.height * .75,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Spacer(),
                      Center(
                        child: FindOutLogo(
                          fontSize: size.height * .065,
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Spacer(flex: 5),
                      DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          fontSize: size.height * .040,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: List.generate(
                            titles.length,
                            (i) => TypewriterAnimatedText(
                              titles[i],
                              speed: Duration(milliseconds: 100),
                            ),
                          ),
                          onTap: () {
                            // print("Tap Event");
                          },
                        ),
                      ),
                      DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          fontSize: size.height * .024,
                          color: Colors.white,
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: List.generate(
                            subtitles.length,
                            (i) => TyperAnimatedText(
                              subtitles[i],
                              speed: Duration(milliseconds: 100),
                            ),
                          ),
                          onTap: () {
                            // print("Tap Event");
                          },
                        ),
                      ),
                      const Spacer(flex: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SnakeButton(
                              onPressed: () =>
                                  _openPage(context, const LoginPage()),
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: RectangularButton(
                              onPressed: () =>
                                  _openPage(context, const RegisterPage()),
                              label: 'Register',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openPage(BuildContext context, Widget page) async {
    hideNotifier.value = true;
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: page);
        },
      ),
    );
    hideNotifier.value = false;
  }
}

class RectangularButton extends StatelessWidget {
  const RectangularButton({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .056,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          primary: Colors.white,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
