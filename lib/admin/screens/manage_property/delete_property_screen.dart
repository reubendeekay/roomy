import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/providers/admin_property_provider.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';

class DeletePropertyScreen extends StatefulWidget {
  final PropertyModel property;
  DeletePropertyScreen(this.property);
  @override
  State<DeletePropertyScreen> createState() => _DeletePropertyScreenState();
}

class _DeletePropertyScreenState extends State<DeletePropertyScreen> {
  String password;
  String superPassword = "inckwanza@2120";

  final _formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<AuthProvider>(context).user;
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
                    Text(
                      'Delete ${widget.property.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      userId == widget.property.ownerId
                          ? 'Enter the password associated with your account. Deleting a property will delete all the data associated with it. This action cannot be reversed.'
                          : 'Enter the super admin password.Deleting a property will delete all the data associated with it. This action cannot be reversed. With great power comes great responsibility',
                      style: TextStyle(color: Colors.blueGrey[500]),
                    )
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Text(
                    userId == widget.property.ownerId
                        ? 'Password'
                        : 'Super Password',
                    style: const TextStyle(
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
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    if (val != user.password || val != superPassword) {
                      return 'Enter a valid password';
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
                    'Remove Travely',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await Provider.of<AdminPropertyProvider>(context)
                          .deleteTravely(widget.property.id);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
