import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_puzzle/utils/singleton.dart';

class FirebaseHelper {
  static Future<DocumentReference<Map<String, dynamic>>> sharePuzzle() async {
    return await FirebaseFirestore.instance
        .collection("puzzles")
        .add({"init": Singleton().initShuffle, "log": Singleton().log.v});
  }
}
