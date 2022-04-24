import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/ad_model.dart';

class AdsProvider with ChangeNotifier {
  Future<void> publishAd(AdModel ad) async {
    final path = FirebaseFirestore.instance.collection('adverts').doc();
    final uid = FirebaseAuth.instance.currentUser.uid;

    final upload = await FirebaseStorage.instance
        .ref('advert/${path.id}')
        .putFile(ad.imageFile);

    final url = await upload.ref.getDownloadURL();
    await path.set({
      'adType': ad.adType,
      'conversion': ad.conversion,
      'description': ad.description,
      'clickUrl': ad.clickUrl,
      'imageUrl': url,
      'ownerId': uid,
      'country': ad.country,
      'searchTerm': ad.searchTerm,
      'category': ad.category,
    });

    notifyListeners();
  }
}
