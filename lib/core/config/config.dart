import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../base/model/supabase.dart';
import '../services/api.dart';
import '../services/firebase/messaging.dart';

class Config {
  static const String COLLECTION = "ENVIRONMENT";
  static const String SUPABASE = "SUPABASE";

  Future<void> init() async {
    await Firebase.initializeApp();
    final SupabaseModel? client = await _fetchSupabaseEnv();
    if (client != null &&
        client.URL != null &&
        client.ANON_KEY != null &&
        client.BASE_URL != null) {
      await Supabase.initialize(
        url: client.URL!,
        anonKey: client.ANON_KEY!,
      ).then((_) => ApiService().init(BASE_URL: client.BASE_URL!));
    }
    await FirebaseMessagingManager().initialize();
  }

  Future<SupabaseModel?> _fetchSupabaseEnv() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final response = await _firestore
        .collection(COLLECTION)
        .doc(SUPABASE)
        .get();
    if (response.exists == false) return null;
    return SupabaseModel().fromJson(response.data() as Map<String, dynamic>);
  }
}
