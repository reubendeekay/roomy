import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/screens/profile/reset_password_success.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.west)),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Back'),
                    const Spacer(),
                    const Icon(Icons.help_outline)
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset Password',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Enter the email associated with your account and we\'ll send an email with instructions to reset your password',
                      style: TextStyle(color: Colors.blueGrey[500]),
                    )
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: const Text(
                    'Email address',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  )),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: TextFormField(
                  style: const TextStyle(fontSize: 14),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                height: 45,
                width: double.infinity,
                child: RaisedButton(
                  color: kPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    'Send Instructions',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      Get.off(() => ResetPasswordSuccess());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
