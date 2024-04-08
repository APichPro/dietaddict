import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_junkie/object/consumed_aliment.dart';
import 'package:diet_junkie/object/macro.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConsumedAlimentProvider {
  static final selectedDayProvider =
      StateProvider<DateTime>((ref) => DateTime.now());

  static final consumedAlimentStream =
      StreamProvider.autoDispose<List<ConsumedAliment>>((ref) {
    DateTime date = DateTime.now();
    DateTime zero = DateTime(date.year, date.month, date.day);
    DateTime minuit =
        DateTime(date.year, date.month, date.day).add(const Duration(days: 1));
    final stream = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('aliments_user')
        .where("timestamp", isGreaterThan: zero)
        .orderBy("timestamp")
        .snapshots();
    return stream.map((snapshot) => snapshot.docs
        .map((doc) => ConsumedAliment.fromJsonFireBase(doc.data(), doc))
        .toList());
  });

  static final calorieByDay =
      FutureProvider.family.autoDispose<double, DateTime>((ref, date) {
    DateTime zero = DateTime(date.year, date.month, date.day);
    DateTime minuit =
        DateTime(date.year, date.month, date.day).add(const Duration(days: 1));
    final calorie = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('aliments_user')
        .where("timestamp", isGreaterThan: zero)
        .where("timestamp", isLessThan: minuit)
        .get()
        .then((value) => value.docs.fold<double>(
            0, (previousValue, element) => previousValue + element["calorie"]));
    return calorie;
  });

  static final dataByDay = FutureProvider.autoDispose<Macros>((ref) {
    DateTime date = ref.watch(selectedDayProvider);
    DateTime zero = DateTime(date.year, date.month, date.day);
    DateTime minuit =
        DateTime(date.year, date.month, date.day).add(const Duration(days: 1));
    final data = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('aliments_user')
        .where("timestamp", isGreaterThan: zero)
        .where("timestamp", isLessThan: minuit)
        .orderBy("timestamp")
        .get()
        .then((value) => Macros(
            value.docs.fold<double>(0,
                (previousValue, element) => previousValue + element["calorie"]),
            value.docs.fold<double>(0,
                (previousValue, element) => previousValue + element["protide"]),
            value.docs.fold<double>(0,
                (previousValue, element) => previousValue + element["lipide"]),
            value.docs.fold<double>(
                0,
                (previousValue, element) =>
                    previousValue + element["glucide"])));
    return data;
  });

  static final dataByWeek = FutureProvider.autoDispose<Macros>((ref) {
    DateTime date = ref.watch(selectedDayProvider);
    DateTime lundi = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
    DateTime dimanche = DateTime(lundi.year, lundi.month, lundi.day)
        .add(const Duration(days: 7));
    final data = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('aliments_user')
        .where("timestamp", isGreaterThan: lundi)
        .where("timestamp", isLessThan: dimanche)
        .orderBy("timestamp")
        .get()
        .then((value) => Macros(
            value.docs.fold<double>(
                0,
                (previousValue, element) =>
                    previousValue + element["calorie"] * 1 / 7),
            value.docs.fold<double>(
                0,
                (previousValue, element) =>
                    previousValue + element["protide"] * 1 / 7),
            value.docs.fold<double>(
                0,
                (previousValue, element) =>
                    previousValue + element["lipide"] * 1 / 7),
            value.docs.fold<double>(
                0,
                (previousValue, element) =>
                    previousValue + element["glucide"] * 1 / 7)));
    return data;
  });

  static final deleteAlimentFromFirebase =
      FutureProvider.family.autoDispose<void, String>((ref, id) {
    return FirebaseFirestore.instance
        .collection('utilisateur')
        .doc('aristide.pichereau@gmail.com')
        .collection('aliments_user')
        .doc(id)
        .delete();
  });
}
