import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:roomy/models/host_model.dart';
import 'package:roomy/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel _user;
  UserModel get user => _user;
  bool isOnline = false;
  HostModel _host;
  HostModel get host => _host;

  Future<void> login({String email, String password}) async {
    final UserCredential _currentUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await FirebaseMessaging.instance.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'pushToken': token});
    }).catchError((err) {
      print(err.message.toString());
    });

    getCurrentUser(_currentUser.user.uid);

    notifyListeners();
  }

  Future<void> signUp(
      {String email,
      String password,
      String fullName,
      String phoneNumber}) async {
    final UserCredential _currentUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.user.uid)
        .set({
      'userId': _currentUser.user.uid,
      'email': email,
      'wishlist': [],
      'password': password,
      'fullName': fullName,
      'isOnline': true,
      'lastSeen': Timestamp.now().millisecondsSinceEpoch,
      'isAdmin': false,
      'isHost': false,
      'phoneNumber': phoneNumber,
      'address': '',
      'profilePic':
          'https://www.theupcoming.co.uk/wp-content/themes/topnews/images/tucuser-avatar-new.png',
      'dateOfBirth': null,
      'nationalId': '',
    });
    await FirebaseMessaging.instance.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'pushToken': token});
    }).catchError((err) {
      print(err.message.toString());
    });
    getCurrentUser(_currentUser.user.uid);

    notifyListeners();
  }

  Future<void> getCurrentUser(String userId) async {
    final _currentUser =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    _user = UserModel(
        address: _currentUser['address'],
        dateOfBirth: _currentUser['dateOfBirth'],
        email: _currentUser['email'],
        fullName: _currentUser['fullName'],
        nationalId: _currentUser['nationalId'],
        phoneNumber: _currentUser['phoneNumber'],
        imageUrl: _currentUser['profilePic'],
        isAdmin: _currentUser['isAdmin'],
        wishlist: _currentUser['wishlist'],
        userId: _currentUser['userId'],
        isOnline: _currentUser['isOnline'],
        lastSeen: _currentUser['lastSeen'],
        isHost: _currentUser['isHost'],
        password: _currentUser['password']);

    if (_currentUser['isHost']) {
      await getHostDetails(userId);
    }

    notifyListeners();
  }

  Future<void> updateProfile(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'email': user.email,
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'address': user.address,
      'dateOfBirth': user.dateOfBirth == null
          ? null
          : DateFormat('dd/MM/yyyy').format(user.dateOfBirth),
      'nationalId': user.nationalId,
    });
    notifyListeners();
  }

  Future<void> addToWishList(String propertyId, bool isLike) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'wishlist': isLike
          ? FieldValue.arrayUnion([propertyId])
          : FieldValue.arrayRemove([propertyId]),
    });
  }

  Future<void> getOnlineStatus() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final databaseRef = FirebaseDatabase.instance.ref('users/$uid');
    if (!isOnline) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'isOnline': true,
        'lastSeen': DateTime.now().microsecondsSinceEpoch,
      });
      databaseRef.update({
        'isOnline': true,
        'lastSeen': DateTime.now().microsecondsSinceEpoch,
      });
      isOnline = true;
    }

    databaseRef.onDisconnect().update({
      'isOnline': false,
      'lastSeen': DateTime.now().microsecondsSinceEpoch,
    }).then((_) => {
          isOnline = false,
        });

    notifyListeners();
  }

  Future<void> getHostDetails(String userId) async {
    final results = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('hosting')
        .doc('account')
        .get();

    _host = HostModel(
      area: results['area'],
      balance: double.parse(results['balance'].toString()),
      city: results['city'],
      country: results['country'],
      likes: results['totalLikes'],
      mpesaNumber: results['mpesaNumber'],
      pin: results['pin'],
      userId: userId,
      views: results['totalViews'],
      totalBookings: results['totalBookings'],
      totalEarnings: double.parse(results['totalEarnings'].toString()),
    );
  }
}
