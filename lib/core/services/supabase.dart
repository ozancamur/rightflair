import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  bool get isAuthenticated => user != null;

  User? get user => client.auth.currentUser;

  bool? get emailVerified => user?.emailConfirmedAt != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
