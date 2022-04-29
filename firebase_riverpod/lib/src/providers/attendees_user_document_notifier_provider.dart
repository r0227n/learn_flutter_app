import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attendees_user_document_provider.dart';

/// [attendees]コレクションの指定したユーザーidの[attending]フィールドを通知する
final attendeesUserDocumentNotifierProvider = StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, key) {
  final value = ref.watch(attendeesUserDocumentProvider(key));
  return value.snapshots();
});