import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [guesbook]コレクションの[timestamp]フィールドを通知する
final timestampNotifierProvider = StreamProvider((ref) =>
    FirebaseFirestore.instance
      .collection("guesbook")
      .orderBy("timestamp", descending: true)
      .snapshots()
);