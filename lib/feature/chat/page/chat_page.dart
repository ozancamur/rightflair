import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/base/page/base_scaffold.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/feature/chat/cubit/chat_cubit.dart';
import 'package:rightflair/feature/chat/model/new_message.dart';
import 'package:rightflair/feature/chat/repository/chat_repository_impl.dart';
import 'package:rightflair/feature/chat/widgets/chat_app_bar.dart';
import 'package:rightflair/feature/chat/widgets/chat_messages_list.dart';
import 'package:rightflair/feature/chat/widgets/chat_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/realtime.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String otherUserName;
  final String? otherUserPhoto;
  final String otherUserId;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    this.otherUserPhoto,
    required this.otherUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _supabase = Supabase.instance.client;
  final _realtime = RealtimeService();
  final _scroll = ScrollController();
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  String get _currentUserId => _supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _realtime.subscribeToConversation(widget.conversationId);
    _markMessagesAsRead();
  }

  Future<void> _markMessagesAsRead() async {
    await _supabase
        .from('conversation_participants')
        .update({'last_read_at': DateTime.now().toIso8601String()})
        .eq('conversation_id', widget.conversationId)
        .eq('user_id', _currentUserId);
  }

  void _setupRealtimeSubscription(BuildContext context) {
    // Önceki subscription varsa iptal et
    _messageSubscription?.cancel();

    _messageSubscription = _realtime.onNewMessage.listen((data) {
      if (data['sender_id'] != _currentUserId) {
        final NewMessageModel newMessage = NewMessageModel().fromJson(data);
        context.read<ChatCubit>().addNewMessage(newMessage: newMessage);
        _markMessagesAsRead();
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _realtime.unsubscribeFromConversation();
    _realtime.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(ChatRepositoryImpl())
        ..init(
          cId: widget.conversationId,
          ouid: widget.otherUserId,
          otherUsername: widget.otherUserName,
          otherPhotoUrl: widget.otherUserPhoto ?? '',
        ),
      child: Builder(
        builder: (context) {
          // BlocProvider context'i ile subscription'ı başlat
          if (_messageSubscription == null) {
            _setupRealtimeSubscription(context);
          }

          return BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              // İlk yükleme tamamlandığında scroll'u en aşağı çek
              if (!state.isLoading) {
                _scrollToBottom();
              }

              return BaseScaffold(
                appBar: ChatAppBarWidget(
                  userName: widget.otherUserName,
                  userPhoto: widget.otherUserPhoto,
                  userId: widget.otherUserId,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: state.isLoading
                          ? const LoadingComponent()
                          : ChatMessagesListWidget(
                              messages: state.messages,
                              scrollController: _scroll,
                            ),
                    ),
                    ChatInputWidget(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
