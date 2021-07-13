import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    debugPrint('Firebase store $path');
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (value) => builder(value.data(), value.id),
        )
        .toList());
  }
}
