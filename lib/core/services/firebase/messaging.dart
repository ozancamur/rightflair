import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/constants/image.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/core/services/cache.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Background message handler - Top-level function required
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    final timestamp = DateTime.now().toIso8601String();
    final notification = message.notification;
    final buffer = StringBuffer()
      ..writeln('┌──────────────────────────────────────────')
      ..writeln('│ 🔔 FCM Notification [BACKGROUND]')
      ..writeln('│ ⏰ $timestamp')
      ..writeln('│ 📌 Message ID : ${message.messageId ?? 'N/A'}')
      ..writeln('│ 📝 Title      : ${notification?.title ?? 'N/A'}')
      ..writeln('│ 💬 Body       : ${notification?.body ?? 'N/A'}')
      ..writeln('│ 📤 Sent Time  : ${message.sentTime ?? 'N/A'}');
    if (message.data.isNotEmpty) {
      buffer.writeln('│ 📦 Data       :');
      message.data.forEach((key, value) {
        buffer.writeln('│    $key: $value');
      });
    } else {
      buffer.writeln('│ 📦 Data       : (empty)');
    }
    buffer.writeln('└──────────────────────────────────────────');
    debugPrint(buffer.toString());
  }
}

class FirebaseMessagingManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient client = Supabase.instance.client;

  /// Global key for showing snackbars from anywhere
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

      // Foreground notification ayarları (iOS'ta bildirimlerin foreground'da gösterilmesi için)
      await setForegroundNotificationPresentationOptions();

      // Message listener'ları kur
      setupMessageListeners();

      // İlk token'ı al
      await getToken();
      subscribeToTopic(AppConstants.APP_NAME);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FirebaseMessagingService ERROR initialize $e');
      }
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

      if (kDebugMode) {
        debugPrint('İzin durumu: ${settings.authorizationStatus}');
      }
      return settings;
    } catch (e) {
      throw Exception(
        AppStrings.MESSAGING_PERMISSION_ERROR.tr(args: [e.toString()]),
      );
    }
  }

  Future<String?> getToken() async {
    const String key = "user-fcm-token";
    try {
      String? token;

      if (Platform.isIOS) {
        token = await _messaging.getAPNSToken();
      } else {
        token = await _messaging.getToken();
      }

      if (kDebugMode) {
        debugPrint("USER FCM TOKEN :> $token");
      }

      if (token == null) return null;

      // Cache'deki token ile karşılaştır
      final String? cachedToken = await CacheService().get(key);

      // Kullanıcı giriş yapmış ve token farklı veya cache boş ise güncelle
      if (client.auth.currentUser != null &&
          (cachedToken == null || cachedToken != token)) {
        await ApiService().post(
          Endpoint.UPDATE_FCM_TOKEN,
          data: {'fcm_token': token},
        );
        await CacheService().set(key, token);
      }

      return token;
    } catch (e) {
      throw Exception(
        AppStrings.MESSAGING_TOKEN_ERROR.tr(args: [e.toString()]),
      );
    }
  }

  Future<void> subscribeToTopic(String topic) async =>
      await _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) async =>
      await _messaging.unsubscribeFromTopic(topic);

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
      if (kDebugMode) {
        debugPrint('Foreground notification ayarlandı');
      }
    } catch (e) {
      throw Exception(
        AppStrings.MESSAGING_FOREGROUND_ERROR.tr(args: [e.toString()]),
      );
    }
  }

  /// Message listener'ları kur
  void setupMessageListeners() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app açık ama background'da)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Terminated state'den açılan message
    _handleInitialMessage();
  }

  /// Gelen bildirimi detaylı logla
  void _logMessage(RemoteMessage message, String source) {
    if (!kDebugMode) return;
    final timestamp = DateTime.now().toIso8601String();
    final notification = message.notification;
    final buffer = StringBuffer()
      ..writeln('┌──────────────────────────────────────────')
      ..writeln('│ 🔔 FCM Notification [$source]')
      ..writeln('│ ⏰ $timestamp')
      ..writeln('│ 📌 Message ID : ${message.messageId ?? 'N/A'}')
      ..writeln('│ 📝 Title      : ${notification?.title ?? 'N/A'}')
      ..writeln('│ 💬 Body       : ${notification?.body ?? 'N/A'}')
      ..writeln('│ 🏷️ Category   : ${message.category ?? 'N/A'}')
      ..writeln('│ 📤 Sent Time  : ${message.sentTime ?? 'N/A'}')
      ..writeln('│ 🔢 TTL        : ${message.ttl ?? 'N/A'}')
      ..writeln('│ 📱 From       : ${message.from ?? 'N/A'}');
    if (notification?.android != null) {
      buffer
        ..writeln(
          '│ 🤖 Android Ch : ${notification!.android!.channelId ?? 'N/A'}',
        )
        ..writeln(
          '│ 🤖 Android Img: ${notification.android!.imageUrl ?? 'N/A'}',
        );
    }
    if (notification?.apple != null) {
      buffer.writeln(
        '│ 🍎 Apple Badge: ${notification!.apple!.badge ?? 'N/A'}',
      );
    }
    if (message.data.isNotEmpty) {
      buffer.writeln('│ 📦 Data       :');
      message.data.forEach((key, value) {
        buffer.writeln('│    $key: $value');
      });
    } else {
      buffer.writeln('│ 📦 Data       : (empty)');
    }
    buffer.writeln('└──────────────────────────────────────────');
    debugPrint(buffer.toString());
  }

  /// Foreground message handler
  void _handleForegroundMessage(RemoteMessage message) {
    _logMessage(message, 'FOREGROUND');
    _showNotificationSnackBar(message);
    _messageStreamController.add(message);
  }

  /// App background'dayken notification'a tıklanınca
  void _handleMessageOpenedApp(RemoteMessage message) {
    _logMessage(message, 'OPENED_APP');
    _messageStreamController.add(message);
  }

  /// App kapalıyken notification'a tıklanınca
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _logMessage(initialMessage, 'TERMINATED');
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
      throw Exception(
        AppStrings.MESSAGING_NOTIFICATION_SETTINGS_ERROR.tr(
          args: [e.toString()],
        ),
      );
    }
  }

  /// Notification izninin durumunu kontrol et
  Future<bool> isPermissionGranted() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      throw Exception(
        AppStrings.MESSAGING_PERMISSION_CHECK_ERROR.tr(args: [e.toString()]),
      );
    }
  }

  /// Foreground'da gelen bildirimi snackbar ile göster
  void _showNotificationSnackBar(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [AppColors.YELLOW, AppColors.ORANGE],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Image.asset(AppImages.LOGOW, width: 50, height: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notification.title != null)
                      Text(
                        notification.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    if (notification.body != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification.body!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    _messageStreamController.close();
  }
}
