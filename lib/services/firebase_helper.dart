import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_hack/utils/singleton.dart';

class FirebaseHelper {
  static Future<DocumentReference<Map<String, dynamic>>> sharePuzzle() async {
    return await FirebaseFirestore.instance
        .collection("puzzles")
        .add({"init": Singleton().initShuffle, "log": Singleton().log.v});
  }
}
