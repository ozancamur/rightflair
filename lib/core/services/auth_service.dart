import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının oturum açma durumunu kontrol eden servis
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // SharedPreferences key'leri
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';

  /// Kullanıcı daha önce giriş yapmış mı?
  /// Firebase Auth ve local storage'ı kontrol eder
  Future<bool> isUserLoggedIn() async {
    try {
      // Firebase'den mevcut kullanıcıyı kontrol et
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Firebase'de kullanıcı var, local storage'ı güncelle
        await _saveLoginStatus(true, currentUser.uid);
        return true;
      }

      // Firebase'de kullanıcı yoksa, local storage'ı kontrol et
      final prefs = await SharedPreferences.getInstance();
      final bool? isLoggedIn = prefs.getBool(_keyIsLoggedIn);

      return isLoggedIn ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Giriş durumunu local storage'a kaydet
  Future<void> _saveLoginStatus(bool isLoggedIn, String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    if (userId != null) {
      await prefs.setString(_keyUserId, userId);
    }
  }

  /// Çıkış yap - Firebase ve local storage'ı temizle
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
  }

  /// Giriş yap - Başarılı girişten sonra bu metodu çağırın
  Future<void> markAsLoggedIn(String userId) async {
    await _saveLoginStatus(true, userId);
  }

  /// Mevcut kullanıcının ID'sini al
  Future<String?> getCurrentUserId() async {
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }
}
