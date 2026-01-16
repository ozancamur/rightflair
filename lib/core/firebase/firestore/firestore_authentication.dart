import '../../constants/collection.dart';
import 'manager.dart';

class FirestoreAuthenticationManager extends FirestoreManager {
  // Kullanıcı var mı kontrolü
  Future<bool> userExists(String userId) async {
    try {
      final doc = await firestore
          .collection(CollectionEnum.USERS.path)
          .doc(userId)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Kullanıcı kontrol edilirken hata: $e');
    }
  }

  Future<bool> isUserExists(String uid) async {
    try {
      final doc = await firestore
          .collection(CollectionEnum.USERS.path)
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Kullanıcının username'i null mı kontrolü
  Future<bool> isUsernameNull(String userId) async {
    try {
      final doc = await firestore
          .collection(CollectionEnum.USERS.path)
          .doc(userId)
          .get();

      if (!doc.exists) return true;

      final data = doc.data();
      return data?['username'] == null;
    } catch (e) {
      return true;
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    try {
      final data = await firestore
          .collection(CollectionEnum.USERSNAMES.path)
          .doc(username)
          .get();
      return !data.exists;
    } catch (e) {
      return false;
    }
  }

  // Username'i kaydet (hem users hem usernames koleksiyonuna)
  Future<void> saveUsername({
    required String uid,
    required String username,
  }) async {
    try {
      // Users koleksiyonunda username'i güncelle
      await firestore.collection(CollectionEnum.USERS.path).doc(uid).update({
        'username': username,
      });

      // Usernames koleksiyonuna kaydet
      await firestore
          .collection(CollectionEnum.USERSNAMES.path)
          .doc(username)
          .set({'uid': uid});
    } catch (e) {
      throw Exception('Username kaydedilirken hata: $e');
    }
  }
}
