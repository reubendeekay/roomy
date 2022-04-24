import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';

class RecentSearches extends StatelessWidget {
  final String searchTerm;
  RecentSearches(this.searchTerm);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Your recent searches',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (searchTerm.isEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc('recentSearch')
                    .collection(FirebaseAuth.instance.currentUser.uid)
                    .orderBy('createdAt')
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> docs = snapshot.data.docs;
                    return ListView(
                      shrinkWrap: true,
                      children:
                          docs.map((e) => search(e['term'], context)).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          if (searchTerm.isNotEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc('recentSearch')
                    .collection(FirebaseAuth.instance.currentUser.uid)
                    .where('term',
                        isLessThanOrEqualTo: searchTerm.toLowerCase())
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> docs = snapshot.data.docs;
                    return ListView(
                      shrinkWrap: true,
                      children:
                          docs.map((e) => search(e['term'], context)).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
        ],
      ),
    );
  }

  Widget search(String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SearchProvider>(context, listen: false).clearSearch();
        Navigator.of(context).pushNamed(
          SearchResultScreen.routeName,
          arguments: FilterModel(name: title),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.history),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            Spacer(),
            Icon(
              Icons.north_west,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
