import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/loading_screen.dart';
import 'package:roomy/my_loader.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/welcome_page/widgets/login/common_widgets.dart';
import 'package:roomy/welcome_page/widgets/register_page/widgets/inverted_top_border_clipper.dart';
import 'package:roomy/welcome_page/widgets/register_page/widgets/text_input_find_out.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isRegisterTapped = false;
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
                        const Center(child: _DragDownIndication()),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: ClipPath(
                            clipper: InvertedTopBorderClipper(
                              circularRadius: 40,
                            ),
                            child: Container(
                              height: 490,
                              width: double.infinity,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: 60),
                                  TextInputFindOut(
                                    label: 'Full name',
                                    variable: nameController,
                                    iconData: FontAwesomeIcons.user,
                                    textInputType: TextInputType.text,
                                  ),
                                  const SizedBox(height: 20),
                                  TextInputFindOut(
                                    label: 'Email address',
                                    variable: emailController,
                                    iconData: Icons.email_outlined,
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  TextInputFindOut(
                                    label: 'Phone number',
                                    variable: phoneController,
                                    iconData: Icons.phone,
                                    textInputType: TextInputType.text,
                                  ),
                                  const SizedBox(height: 20),
                                  TextInputFindOut(
                                    label: 'Password',
                                    variable: passwordController,
                                    iconData: Icons.lock_outline,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 5),
                                  const _AcceptTerms(),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: size.width * .65,
                                    height: 45,
                                    child: TextButton(
                                      onPressed: () async {
                                        if (emailController.text.isNotEmpty &&
                                            phoneController.text.isNotEmpty &&
                                            nameController.text.isNotEmpty &&
                                            passwordController
                                                .text.isNotEmpty) {
                                          setState(() {
                                            isRegisterTapped = true;
                                          });
                                          try {
                                            await Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false)
                                                .signUp(
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim(),
                                              fullName: nameController.text,
                                              phoneNumber:
                                                  phoneController.text.trim(),
                                            );
                                            resizeNotifier.value = false;

                                            Get.off(
                                                () => InitialLoadingScreen());
                                          } catch (e) {
                                            setState(() {
                                              isRegisterTapped = false;
                                            });
                                            FancySnackbar.showSnackbar(
                                              context,
                                              snackBarType:
                                                  FancySnackBarType.error,
                                              title: "Oh Snap!",
                                              message: e.message,
                                              duration: 2.5,
                                              onCloseEvent: () {},
                                            );
                                            print(e);
                                          }
                                        } else {
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
                                      child: isRegisterTapped
                                          ? MyLoader()
                                          : const Text(
                                              "Register",
                                              style: TextStyle(
                                                fontSize: 16,
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
          'Register',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'We are happy you are joining us',
          style: TextStyle(
            height: 2,
            fontSize: 12,
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

class _AcceptTerms extends StatelessWidget {
  const _AcceptTerms({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueNotifier = ValueNotifier(false);
    return InkWell(
      onTap: () => valueNotifier.value = !valueNotifier.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (context, dynamic value, child) {
              return Checkbox(
                side: BorderSide(color: Theme.of(context).iconTheme.color),
                value: value,
                onChanged: (val) {
                  valueNotifier.value = !valueNotifier.value;
                },
                checkColor: Colors.white,
                activeColor: kPrimary,
              );
            },
          ),
          Text(
            "Accept",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const Text(
            " terms and conditions",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
