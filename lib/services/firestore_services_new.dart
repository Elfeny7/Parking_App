import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  List<String> resultList;
  Result({required this.resultList});

  Map<String, dynamic> toJson() => {
        'plate': FieldValue.arrayUnion(resultList),
      };
  static Result fromJson(Map<String, dynamic> json) {
    List<dynamic> dynamicList = json['plate'];
    List<String> stringList = List<String>.from(dynamicList);

    return Result(resultList: stringList);
  }
}

class History {
  List<String> historyList;
  History({required this.historyList});

  Map<String, dynamic> toJson() => {
        'plate_history': FieldValue.arrayUnion(historyList),
      };
  static History fromJson(Map<String, dynamic> json) {
    List<dynamic> dynamicList = json['plate_history'];
    List<String> stringList = List<String>.from(dynamicList);

    return History(historyList: stringList);
  }
}

Future<void> createResult(
    {required String uid, required String textResult}) async {
  List<String> resultList = [];
  resultList.add(textResult);

  final docResult = FirebaseFirestore.instance.collection('results').doc(uid);
  final result = Result(resultList: resultList);
  final json = result.toJson();
  await docResult.set(json, SetOptions(merge: true));
}

Future<Result?> readResult({required String uid}) async {
  try {
    final docResult = FirebaseFirestore.instance.collection('results').doc(uid);
    final snapshot = await docResult.get();
    if (snapshot.exists) {
      return Result.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> deleteResult(
    {required String uid, required String textResult}) async {
  try {
    final docResult = FirebaseFirestore.instance.collection('results').doc(uid);
    await docResult.update(
      {
        'plate': FieldValue.arrayRemove([textResult])
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> createHistory(
    {required String uid, required String textResult}) async {
  List<String> historyList = [];
  historyList.add(textResult);

  final docHistory = FirebaseFirestore.instance.collection('history').doc(uid);
  final history = History(historyList: historyList);
  final json = history.toJson();
  await docHistory.set(json, SetOptions(merge: true));
}

Future<bool> resultChecker(
    {required String uid, required String result}) async {
  try {
    final docResult =
        await FirebaseFirestore.instance.collection('results').doc(uid).get();

    if (docResult.exists) {
      final resultObject =
          Result.fromJson(docResult.data() as Map<String, dynamic>);
      final plateList = resultObject.resultList;

      if (plateList.contains(result)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<History?> readHistory({required String uid}) async {
  try {
    final docHistory =
        FirebaseFirestore.instance.collection('history').doc(uid);
    final snapshot = await docHistory.get();
    if (snapshot.exists) {
      return History.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> clearHistory({required String uid}) async {
  final docHistory = FirebaseFirestore.instance.collection('history').doc(uid);
  final history = History(historyList: []);
  await docHistory.set(history.toJson(), SetOptions(merge: false));
}
