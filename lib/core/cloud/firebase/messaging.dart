import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Background message handler - Top-level function required
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message alındı: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
}

class FirebaseMessagingManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Token değişikliği için stream controller
  final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();
  Stream<String> get tokenStream => _tokenStreamController.stream;

  // Message stream controller
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  // Singleton pattern
  static final FirebaseMessagingManager _instance =
      FirebaseMessagingManager._internal();
  factory FirebaseMessagingManager() => _instance;
  FirebaseMessagingManager._internal();

  /// Firebase Messaging'i başlat
  Future<void> initialize() async {
    try {
      // İzin iste
      await requestPermission();

      // Background handler'ı kaydet
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Token dinle
      _setupTokenListener();

      // Message listener'ları kur
      _setupMessageListeners();

      // İlk token'ı al
      await getToken();

      debugPrint('Firebase Messaging başarıyla başlatıldı');
    } catch (e) {
      debugPrint('Firebase Messaging başlatma hatası: $e');
      rethrow;
    }
  }

  /// Notification izni iste
  Future<NotificationSettings> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('İzin durumu: ${settings.authorizationStatus}');
      return settings;
    } catch (e) {
      throw Exception('İzin isteği sırasında hata: $e');
    }
  }

  /// FCM token al
  Future<String?> getToken() async {
    try {
      // iOS için APNS token'ını bekle
      if (Platform.isIOS) {
        await _waitForAPNsToken();
      }

      final token = await _messaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        _tokenStreamController.add(token);
      }
      return token;
    } catch (e) {
      throw Exception('Token alınırken hata: $e');
    }
  }

  /// iOS için APNS token'ını bekle
  Future<void> _waitForAPNsToken() async {
    if (!Platform.isIOS) return;

    try {
      // APNS token'ı mevcut mu kontrol et
      String? apnsToken = await _messaging.getAPNSToken();

      // Token yoksa, maksimum 10 saniye bekle
      if (apnsToken == null) {
        debugPrint('APNS token bekleniyor...');
        int attempts = 0;
        const maxAttempts = 20; // 20 * 500ms = 10 saniye

        while (apnsToken == null && attempts < maxAttempts) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await _messaging.getAPNSToken();
          attempts++;
        }

        if (apnsToken != null) {
          debugPrint('APNS token alındı: $apnsToken');
        } else {
          debugPrint('APNS token alınamadı, FCM token alınmaya devam edilecek');
        }
      }
    } catch (e) {
      debugPrint('APNS token beklenirken hata: $e');
      // Hata olsa bile devam et
    }
  }


  /// Token'ı sil
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      debugPrint('FCM Token silindi');
    } catch (e) {
      throw Exception('Token silinirken hata: $e');
    }
  }

  /// Topic'e abone ol
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Topic\'e abone olundu: $topic');
    } catch (e) {
      throw Exception('Topic aboneliği sırasında hata: $e');
    }
  }

  /// Topic aboneliğinden çık
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Topic aboneliğinden çıkıldı: $topic');
    } catch (e) {
      throw Exception('Topic aboneliği iptal edilirken hata: $e');
    }
  }

  /// Otomatik başlatmayı ayarla (Android)
  Future<void> setAutoInitEnabled(bool enabled) async {
    try {
      await _messaging.setAutoInitEnabled(enabled);
      debugPrint('Auto init enabled: $enabled');
    } catch (e) {
      throw Exception('Auto init ayarlanırken hata: $e');
    }
  }

  /// Foreground notification ayarları (Android)
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: alert,
        badge: badge,
        sound: sound,
      );
      debugPrint('Foreground notification ayarlandı');
    } catch (e) {
      throw Exception('Foreground notification ayarlanırken hata: $e');
    }
  }

  /// Token değişikliklerini dinle
  void _setupTokenListener() {
    _messaging.onTokenRefresh.listen(
      (token) {
        debugPrint('Token yenilendi: $token');
        _tokenStreamController.add(token);
      },
      onError: (error) {
        debugPrint('Token refresh hatası: $error');
      },
    );
  }

  /// Message listener'ları kur
  void _setupMessageListeners() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app açık ama background'da)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Terminated state'den açılan message
    _handleInitialMessage();
  }

  /// Foreground message handler
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message alındı: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    _messageStreamController.add(message);
  }

  /// App background'dayken notification'a tıklanınca
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Background notification\'a tıklandı: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    _messageStreamController.add(message);
  }

  /// App kapalıyken notification'a tıklanınca
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        'Terminated notification\'a tıklandı: ${initialMessage.messageId}',
      );
      debugPrint('Title: ${initialMessage.notification?.title}');
      debugPrint('Body: ${initialMessage.notification?.body}');
      debugPrint('Data: ${initialMessage.data}');

      _messageStreamController.add(initialMessage);
    }
  }

  /// Custom message handler ekle
  void onMessage(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  /// Background'dan açılan message handler'ı ekle
  void onMessageOpenedApp(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }

  /// Notification ayarlarını kontrol et
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      return await _messaging.getNotificationSettings();
    } catch (e) {
      throw Exception('Notification ayarları alınırken hata: $e');
    }
  }

  /// Notification izninin durumunu kontrol et
  Future<bool> isPermissionGranted() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      throw Exception('İzin durumu kontrol edilirken hata: $e');
    }
  }

  /// Temizlik
  void dispose() {
    _tokenStreamController.close();
    _messageStreamController.close();
  }
}
