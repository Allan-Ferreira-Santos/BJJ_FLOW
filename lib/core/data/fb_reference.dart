import 'package:cloud_firestore/cloud_firestore.dart';

class FbReference {
  final CollectionReference<Map<String, dynamic>> authUser;
  final CollectionReference<Map<String, dynamic>> markPresence;

  FbReference(FirebaseFirestore fs)
      : markPresence = fs.collection('markPresence'),
        authUser = fs.collection('users');
}
