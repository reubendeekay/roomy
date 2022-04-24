import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/screens/profile/reset_password_screen.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/widgets/done_icon.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/change-password';
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _password;
  String initialPassword;
  String confirmPassword;
  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<AuthProvider>(context).user;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.arrow_back_ios))),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.openSans(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 0.3,
                  height: 2,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).shadowColor),
                  child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your current password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Current Password',
                          helperStyle: TextStyle(color: kPrimary),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: kPrimary, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              initialPassword = text;
                            })
                          }),
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).shadowColor),
                  child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'New Password',
                          helperStyle: TextStyle(color: kPrimary),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: kPrimary, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              _password = text;
                            })
                          }),
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).shadowColor),
                  child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Confirm New Password',
                          helperStyle: TextStyle(color: kPrimary),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: kPrimary, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              confirmPassword = text;
                            })
                          }),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.to(() => ResetPasswordScreen());
                        },
                        child: Text('Forgot Password?')),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  height: 45,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kPrimary,
                    onPressed: () async {
                      if (user.password == initialPassword) {
                        await FirebaseAuth.instance.currentUser
                            .updatePassword(_password);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.userId)
                            .update({'password': _password}).then((_) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              content: DoneIcon(),
                            ),
                          );
                          Future.delayed(Duration(milliseconds: 2000))
                              .then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        });
                      } else if (confirmPassword != _password) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Confirmed password does not match with new password'),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Please enter the correct current password'),
                        ));
                      }
                    },
                    child: Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
