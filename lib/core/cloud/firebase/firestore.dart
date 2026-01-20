import 'package:cloud_firestore/cloud_firestore.dart';


abstract class FirestoreManager {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

 
  Future<Map<String, dynamic>?> read() async {
    try {
      final doc = await firestore.collection("ENVIRONMENT").doc("SUPABASE").get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Döküman okunurken hata: $e');
    }
  }
}
