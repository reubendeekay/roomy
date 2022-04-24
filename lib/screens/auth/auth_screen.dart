import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/loading_screen.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/screens/profile/reset_password_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _email;
  String _password;
  String fullName;
  String phoneNumber;
  bool isPasswordObscure = true;
  double _height = -100;

  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;
  double opacity = 0.0;

  void startAnimations() {
    setState(() {
      _height = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      startAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: size.height - MediaQuery.of(context).padding.top,
              width: size.width,
              child: Stack(
                children: [
                  ///////////////LOTTIE ANIMATION///////////////////////////
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    bottom: _height,
                    left: 0,
                    right: 0,
                    curve: Curves.easeInOut,
                    child: Container(
                        // height: size.height * 0.15,
                        width: size.width,
                        child: Image.asset(
                          'assets/images/city.png',
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                  Positioned(
                      top: 0,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                          child: Container(
                              height: size.height * 0.3,
                              width: size.width,
                              child: Lottie.asset('assets/bubbles.json',
                                  fit: BoxFit.cover)),
                        ),
                      )),

                  /////////////START OF AUTH FORM/////////////

                  AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(milliseconds: 1000),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: Transform.scale(
                                    scale: 3,
                                    child:
                                        Image.asset('assets/images/logo.png')),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                isLogin ? 'Login' : 'Sign up',
                                style: GoogleFonts.roboto(
                                    fontSize: 36, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),

                          /////////////////////LOGIN FIELDS///////////////////////////
                          if (!isLogin)
                            AnimatedOpacity(
                                curve: Curves.fastLinearToSlowEaseIn,
                                opacity: isLogin ? 0 : 1,
                                duration: Duration(milliseconds: 1000),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).shadowColor),
                                  child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Please enter your full name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText: 'Full name',
                                          helperStyle:
                                              TextStyle(color: kPrimary),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: kPrimary, width: 1)),
                                          border: InputBorder.none),
                                      onChanged: (text) => {
                                            setState(() {
                                              fullName = text;
                                            })
                                          }),
                                )),

                          Container(
                            height: 50,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).shadowColor),
                            child: TextFormField(
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!val.contains('@') ||
                                      !val.contains('.')) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    labelText: 'Email address',
                                    helperStyle: TextStyle(color: kPrimary),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: kPrimary, width: 1)),
                                    border: InputBorder.none),
                                onChanged: (text) => {
                                      setState(() {
                                        _email = text;
                                      })
                                    }),
                          ),

                          if (!isLogin)
                            AnimatedOpacity(
                                curve: Curves.fastLinearToSlowEaseIn,
                                opacity: isLogin ? 0 : 1,
                                duration: Duration(milliseconds: 1000),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).shadowColor),
                                  child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        if (val.length < 7) {
                                          return 'Enter a valid phone number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText: 'Phone number',
                                          helperStyle:
                                              TextStyle(color: kPrimary),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: kPrimary, width: 1)),
                                          border: InputBorder.none),
                                      onChanged: (text) => {
                                            setState(() {
                                              phoneNumber = text;
                                            })
                                          }),
                                )),
                          Container(
                            height: 50,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).shadowColor),
                            child: TextFormField(
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (val.length < 6) {
                                    return 'Password should have atleast 6 characters';
                                  }

                                  return null;
                                },
                                obscureText: isPasswordObscure,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    labelText: 'Password',
                                    helperStyle: TextStyle(color: kPrimary),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPasswordObscure =
                                              !isPasswordObscure;
                                        });
                                      },
                                      child: Icon(
                                        isPasswordObscure
                                            ? Icons.remove_red_eye
                                            : Icons.visibility_off_outlined,
                                        size: 20,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: kPrimary, width: 1)),
                                    border: InputBorder.none),
                                onChanged: (text) => {
                                      setState(() {
                                        _password = text;
                                      })
                                    }),
                          ),
                          //////////////////////////////////////////////////////////////////////////////////////////////////
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            height: 45,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: kPrimary,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await trySubmit();
                                isLoading = false;
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      isLogin ? 'Sign in' : 'Sign up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => ResetPasswordScreen());
                              },
                              child: Text('Forgot password?')),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isLogin
                                  ? 'Dont have an account?'
                                  : 'Already have an account?'),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(
                                  isLogin ? 'Register' : 'Sign in',
                                  style: TextStyle(
                                      color: kPrimary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> trySubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(email: _email.trim(), password: _password.trim())
            .then((data) async {
          Get.to(() => InitialLoadingScreen());
        });
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(
          email: _email.trim(),
          fullName: fullName,
          password: _password.trim(),
          phoneNumber: phoneNumber.trim(),
        )
            .then((_) async {
          Get.to(() => InitialLoadingScreen());
        });
      }
    }
  }

  // Widget inputCard({@required String title, String variable}) {
  //   return Container(
  //     height: 50,
  //     width: double.infinity,
  //     margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10), color: Theme.of(context).shadowColor),
  //     child: TextFormField(
  //         decoration: InputDecoration(
  //             contentPadding: EdgeInsets.symmetric(horizontal: 15),
  //             labelText: title,
  //             helperStyle: TextStyle(color: kPrimary),
  //             focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide(color: kPrimary, width: 1)),
  //             border: InputBorder.none),
  //         onChanged: (text) => {
  //               setState(() {
  //                 variable = text;
  //               })
  //             }),
  //   );
  // }
}
