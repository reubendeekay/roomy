import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/custom_surfix_icon.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/components/default_button.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/admin_pin_setup.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/screens/profile/user_profile.dart';

class BecomeHostScreen extends StatefulWidget {
  final bool isDrawer;
  BecomeHostScreen({this.isDrawer = false});
  static String routeName = "/complete_profile";

  @override
  State<BecomeHostScreen> createState() => _BecomeHostScreenState();
}

class _BecomeHostScreenState extends State<BecomeHostScreen> {
  final _formKey = GlobalKey<FormState>();

  String pin;

  String description;

  String phoneNumber;

  String address;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Host'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text("Application Form",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      )),
                  Text(
                    "Complete your details to apply to become a host\nHosts must have a profile picture",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.04),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        UserPicture(),
                        SizedBox(height: 10),

                        if (user.imageUrl ==
                            'https://www.theupcoming.co.uk/wp-content/themes/topnews/images/tucuser-avatar-new.png')
                          Text(
                            'Please upload a profile picture',
                            style: TextStyle(color: Colors.red),
                          ),

                        // buildFirstNameFormField(),
                        SizedBox(height: 10),
                        buildLastNameFormField(),
                        SizedBox(height: 15),
                        buildPhoneNumberFormField(),
                        SizedBox(height: 15),
                        buildPinField(),
                        SizedBox(height: 15),
                        buildAddressFormField(),
                        SizedBox(height: 32),
                        DefaultButton(
                          text: "Continue",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              Get.to(() => AdminPinSetup(
                                    description: description,
                                    phoneNumber: phoneNumber,
                                    address: address,
                                    pin: pin,
                                    isDrawer: widget.isDrawer,
                                    isRegister: true,
                                  ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        setState(() {
          address = value;
        });
        if (value.isNotEmpty) {}
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Enter your operational address";
        }
        if (value.split(',').length < 3) {
          return "Use Format: Area,Town,Country eg. CBD,Nairobi,Kenya";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address (Separate with commas)",
        hintText: "Area,Town,Country eg. CBD,Nairobi,Kenya",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: '254',
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
        if (value.isNotEmpty) {}
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Enter your phone number";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mpesa Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => description = newValue,
      onChanged: (val) {
        setState(() {
          description = val;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Enter your description";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        hintText: "Short description of you as a host",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPinField() {
    return TextFormField(
      onSaved: (newValue) => pin = newValue,
      onChanged: (value) {
        setState(() {
          pin = value;
        });
        if (value.isNotEmpty) {}
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Enter a 4 digit pin";
        }
        if (value.length != 4) {
          return "Pin must be 4 digits";
        }
        return null;
      },
      maxLength: 4,
      decoration: InputDecoration(
        labelText: "Unlock Pin",
        hintText: "Enter your 4 digit unlock pin",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
