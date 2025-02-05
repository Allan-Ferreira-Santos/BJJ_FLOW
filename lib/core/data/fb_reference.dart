import 'package:cloud_firestore/cloud_firestore.dart';

class FbReference {
  final CollectionReference<Map<String, dynamic>> authUser;
  final CollectionReference<Map<String, dynamic>> markPresence;
  final CollectionReference<Map<String, dynamic>> registerUser;

  FbReference(FirebaseFirestore fs)
      : markPresence = fs.collection('markPresence'),
        authUser = fs.collection('users'),
        registerUser = fs.collection('registerUser');
}
