import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createResult(
    {required String uid, required String textResult}) async {
  List<String> resultList = [];
  resultList.add(textResult);

  final docResult = FirebaseFirestore.instance.collection('results').doc(uid);
  final result = Result(resultList: resultList);
  final json = result.toJson();
  await docResult.set(json, SetOptions(merge: true));
}

// Future<void> createOrUpdateResult(
//     {required String uid, required String textResult}) async {
//   try {
//     DocumentSnapshot documentSnapshot =
//         await FirebaseFirestore.instance.collection('results').doc(uid).get();
//     if (documentSnapshot.exists) {
//       Map<String, dynamic> data =
//           documentSnapshot.data() as Map<String, dynamic>;
//       List<dynamic> resultList = data['result'];
//       resultList.add(textResult);
//       final docResult =
//           FirebaseFirestore.instance.collection('results').doc(uid);
//       final json = {
//         'plates': FieldValue.arrayUnion(resultList),
//       };
//       await docResult.set(json, SetOptions(merge: true));
//     } else {
//       List<String> resultList = [];
//       resultList.add(textResult);
//       final docResult =
//           FirebaseFirestore.instance.collection('results').doc(uid);
//       final json = {
//         'result': FieldValue.arrayUnion(resultList),
//       };
//       await docResult.set(json, SetOptions(merge: true));
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// Future<DocumentSnapshot> readResult({required String uid}) async {
//   await FirebaseFirestore.instance.collection('results').doc(uid).get();

// }

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

Stream<List<Result>> readResults() => FirebaseFirestore.instance
    .collection('results')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Result.fromJson(doc.data())).toList());

Future<Result?> readResult({required String uid}) async {
  final docResult = FirebaseFirestore.instance.collection('results').doc(uid);
  final snapshot = await docResult.get();
  if (snapshot.exists) {
    return Result.fromJson(snapshot.data()!);
  } else {
    return null;
  }
}
