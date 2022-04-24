import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/host_model.dart';

class AdminUserProvider with ChangeNotifier {
  HostModel _host;
  HostModel get host => _host;
  Future<void> makeAdmin(String userId, bool isAdmin) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isAdmin': !isAdmin,
    });

    notifyListeners();
  }

  Future<void> becomeAHost(
      {String description, String phone, String address, String pin}) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    List<String> addressDetails = address.trim().split(',');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('hosting')
        .doc('account')
        .set({
      'description': description,
      'pin': pin,
      'mpesaNumber': phone,
      'city': addressDetails[1],
      'area': addressDetails[0],
      'country': addressDetails[2],
      'balance': 0,
      'totalEarnings': 0,
      'totalBookings': 0,
      'totalReviews': 0,
      'totalViews': 0,
      'totalLikes': 0,
      'bankAccountName': null,
      'bankAccountNumber': null,
    });
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isHost': true,
    });
    await getHostDetails(uid);
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
