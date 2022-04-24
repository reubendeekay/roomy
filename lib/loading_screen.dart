import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:roomy/main_drawer.dart';
import 'package:roomy/providers/auth_provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: Lottie.asset('assets/loading.json', fit: BoxFit.fitHeight),
        ),
      ),
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUser(FirebaseAuth.instance.currentUser.uid)
        .then((value) =>
            Navigator.of(context).pushReplacementNamed(MainDrawer.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 100,
              width: 100,
              child: Lottie.asset('assets/loading.json', fit: BoxFit.fitHeight),
            ),
          ),
        ],
      ),
    );
  }
}
