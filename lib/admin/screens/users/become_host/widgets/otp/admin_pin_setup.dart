import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/providers/admin_user_provider.dart';
import 'package:roomy/admin/screens/admin_home.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/host_re_success.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/providers/auth_provider.dart';

class AdminPinSetup extends StatefulWidget {
  AdminPinSetup(
      {Key key,
      this.description,
      this.phoneNumber,
      this.address,
      this.isDrawer = false,
      this.pin,
      this.isRegister = false})
      : super(key: key);
  final String description;
  final bool isRegister;
  final bool isDrawer;

  final String phoneNumber;

  final String address;
  final String pin;
  static String routeName = "/otp";

  @override
  State<AdminPinSetup> createState() => _AdminPinSetupState();
}

class _AdminPinSetupState extends State<AdminPinSetup> {
  final TextEditingController _pinPutController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: kPrimary),
        borderRadius: BorderRadius.circular(50.0),
        color: kPrimary.withOpacity(0.03));
  }

  @override
  void initState() {
    super.initState();
    print(widget.pin);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final host = !widget.isRegister
        ? Provider.of<AuthProvider>(context, listen: false).host
        : null;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * .05),

                Text(
                  "Unlock Pin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 10),

                Text("Enter your your unlock pin"),
                // OtpForm(),
                SizedBox(height: 30),

                Container(
                  child: PinPut(
                    fieldsCount: 4,
                    onSubmit: (String pin) async {
                      if (pin == (widget.isRegister ? widget.pin : host.pin)) {
                        FancySnackbar.showSnackbar(
                          context,
                          snackBarType: FancySnackBarType.success,
                          title: "Verification Success!",
                          message: "Enjoy your Travely Host experience",
                          duration: 2.5,
                          onCloseEvent: () {},
                        );
                        if (widget.isRegister) {
                          await Provider.of<AdminUserProvider>(context,
                                  listen: false)
                              .becomeAHost(
                                  address: widget.address,
                                  pin: widget.pin,
                                  description: widget.description,
                                  phone: widget.phoneNumber);
                          Get.off(
                              () => HostRegSuccess(isDrawer: widget.isDrawer));
                        } else {
                          Future.delayed(Duration(seconds: 2), () {
                            Get.off(() => AdminHomepage(
                                  isDrawer: widget.isDrawer,
                                ));
                          });
                        }
                      } else {
                        FancySnackbar.showSnackbar(
                          context,
                          snackBarType: FancySnackBarType.error,
                          title: "Oh Snap!",
                          message: "Wrong Verification Code. Please Try again",
                          duration: 2.5,
                          onCloseEvent: () {},
                        );
                      }
                    },
                    onChanged: (val) async {
                      if (val.length == 4) {
                        if (val ==
                            (widget.isRegister ? widget.pin : host.pin)) {
                          FancySnackbar.showSnackbar(
                            context,
                            snackBarType: FancySnackBarType.success,
                            title: "Verification Success!",
                            message: "Enjoy your Travely Host experience",
                            duration: 2.5,
                            onCloseEvent: () {},
                          );
                          if (widget.isRegister) {
                            await Provider.of<AdminUserProvider>(context,
                                    listen: false)
                                .becomeAHost(
                                    address: widget.address,
                                    pin: widget.pin,
                                    description: widget.description,
                                    phone: widget.phoneNumber);
                            Get.off(() => HostRegSuccess());
                          } else {
                            Future.delayed(Duration(seconds: 2), () {
                              Get.off(() => AdminHomepage(
                                    isDrawer: widget.isDrawer,
                                  ));
                            });
                          }
                        } else {
                          FancySnackbar.showSnackbar(
                            context,
                            snackBarType: FancySnackBarType.error,
                            title: "Oh Snap!",
                            message:
                                "Wrong Verification Code. Please Try again",
                            duration: 2.5,
                            onCloseEvent: () {},
                          );
                        }
                      }
                    },
                    eachFieldWidth: 70.0,
                    eachFieldHeight: 70.0,
                    eachFieldConstraints:
                        BoxConstraints(maxHeight: 100, maxWidth: 100),
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    useNativeKeyboard: false,
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: kPrimary.withOpacity(.5),
                      ),
                    ),
                    slideTransitionBeginOffset: Offset(0, 10),
                    pinAnimationType: PinAnimationType.slide,
                  ),
                ),
                SizedBox(height: 15),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.all(30),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
                      return RoundedButton(
                        title: '$e',
                        onTap: () {
                          if (_pinPutController.text.length >= 5) return;

                          _pinPutController.text =
                              '${_pinPutController.text}$e';
                        },
                      );
                    }),
                    RoundedButton(
                      title: '⌫',
                      onTap: () {
                        if (_pinPutController.text.isNotEmpty) {
                          _pinPutController.text = _pinPutController.text
                              .substring(0, _pinPutController.text.length - 1);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimary,
        ),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
