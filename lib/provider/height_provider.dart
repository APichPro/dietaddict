import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_junkie/object/height.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HeightProvider {
  static final heightStream = StreamProvider.autoDispose<List<Height>>((ref) {
    final stream = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('height')
        .orderBy("timestamp")
        .snapshots();
    return stream.map((snapshot) => snapshot.docs
        .map((doc) => Height.fromJsonFireBase(doc.data(), doc))
        .toList());
  });

  static final addHeight =
      FutureProvider.family.autoDispose<void, Height>((ref, height) {
    return FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('height')
        .add(height.toJsonFireBase());
  });
}
