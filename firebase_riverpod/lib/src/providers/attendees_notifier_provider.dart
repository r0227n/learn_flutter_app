import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [attendees]コレクションの[attending]フィールドを通知する
final attendeesNotifierProvider = StreamProvider<QuerySnapshot>((ref) =>
    FirebaseFirestore.instance
        .collection("attendees")
        .where("attending", isEqualTo: true)
        .snapshots()
);