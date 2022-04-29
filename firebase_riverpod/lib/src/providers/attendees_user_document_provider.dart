import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [attendees]コレクションの指定したユーザーidの情報を保持
final attendeesUserDocumentProvider = StateProvider.family<DocumentReference<Map<String, dynamic>>, String>((ref, key) =>
    FirebaseFirestore.instance
        .collection('attendees')
        .doc(key)
);