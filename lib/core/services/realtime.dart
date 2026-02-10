// lib/services/chat_realtime_service.dart

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _conversationsChannel;

  // Stream controllers
  final _newMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _conversationUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get onNewMessage => _newMessageController.stream;
  Stream<Map<String, dynamic>> get onConversationUpdate =>
      _conversationUpdateController.stream;

  /// Belirli bir conversation için mesajları dinle
  void subscribeToConversation(String conversationId) {
    // Önceki subscription varsa kapat
    _messagesChannel?.unsubscribe();

    _messagesChannel = _supabase
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            _newMessageController.add(payload.newRecord);
          },
        )
        .subscribe();

  }

  /// Kullanıcının tüm conversation'larını dinle (son mesaj güncellemeleri için)
  void subscribeToUserConversations(String userId) {
    _conversationsChannel?.unsubscribe();

    _conversationsChannel = _supabase
        .channel('conversations:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'conversations',
          callback: (payload) {
            _conversationUpdateController.add(payload.newRecord);
          },
        )
        .subscribe();

  }

  /// Subscription'ları temizle
  void unsubscribeFromConversation() {
    _messagesChannel?.unsubscribe();
    _messagesChannel = null;
  }

  void unsubscribeFromUserConversations() {
    _conversationsChannel?.unsubscribe();
    _conversationsChannel = null;
  }

  /// Tüm kaynakları temizle
  void dispose() {
    _messagesChannel?.unsubscribe();
    _conversationsChannel?.unsubscribe();
    _newMessageController.close();
    _conversationUpdateController.close();
  }
}
