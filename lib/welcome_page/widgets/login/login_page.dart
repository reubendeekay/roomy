import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/loading_screen.dart';
import 'package:roomy/my_loader.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/screens/profile/reset_password_screen.dart';
import 'package:roomy/welcome_page/widgets/login/common_widgets.dart';
import 'package:roomy/welcome_page/widgets/register_page/widgets/inverted_top_border_clipper.dart';
import 'package:roomy/welcome_page/widgets/register_page/widgets/text_input_find_out.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _openHomePage(BuildContext context) {
    final newRoute = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: InitialLoadingScreen(),
        );
      },
    );
    Navigator.pushAndRemoveUntil(context, newRoute, ModalRoute.withName(''));
  }

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool isLoginTapped = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resizeNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!resizeNotifier.value) resizeNotifier.value = true;
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta > 3) {
            resizeNotifier.value = false;
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: resizeNotifier,
              builder: (context, dynamic value, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  bottom: value ? 0 : -size.height * .5,
                  left: 0,
                  right: 0,
                  child: child,
                );
              },
              child: SizedBox(
                height: size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * .1),
                    Center(
                      child: FindOutLogo(
                        fontSize: size.height * .065,
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        const Align(
                          alignment: Alignment.topCenter,
                          child: _DragDownIndication(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: ClipPath(
                            clipper: InvertedTopBorderClipper(
                              circularRadius: 40,
                            ),
                            child: Container(
                              height: 330,
                              width: double.infinity,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: 60),
                                  TextInputFindOut(
                                    label: 'Email address',
                                    variable: emailController,
                                    iconData: Icons.mail_outline,
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  TextInputFindOut(
                                    label: 'Password',
                                    variable: passwordController,
                                    iconData: Icons.lock_outline,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ResetPasswordScreen());
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: size.width * .65,
                                    height: 45,
                                    child: TextButton(
                                      onPressed: () async {
                                        if (emailController.text.isEmpty ||
                                            passwordController.text.isEmpty) {
                                          FancySnackbar.showSnackbar(
                                            context,
                                            snackBarType:
                                                FancySnackBarType.error,
                                            title: "Oh Snap!",
                                            message:
                                                "Please fill in all the fields with accurate information",
                                            duration: 2.5,
                                            onCloseEvent: () {},
                                          );
                                          return;
                                        }
                                        setState(() {
                                          isLoginTapped = true;
                                        });
                                        try {
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .login(
                                                  email: emailController.text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim());
                                          resizeNotifier.value = false;

                                          _openHomePage(context);
                                          print(emailController.text);
                                        } catch (e) {
                                          setState(() {
                                            isLoginTapped = false;
                                          });
                                          print(e);
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: kPrimary,
                                      ),
                                      child: isLoginTapped
                                          ? MyLoader()
                                          : const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragDownIndication extends StatelessWidget {
  const _DragDownIndication({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Good to see you back!',
          style: TextStyle(
            height: 2,
            fontSize: 14,
            color: Colors.white.withOpacity(.9),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white.withOpacity(.8),
          size: 35,
        ),
      ],
    );
  }
}
