import '../model/chat_messages.dart';
import '../model/chat_request.dart';
import '../model/send_message_request.dart';
import '../model/send_message_response.dart';

abstract class ChatRepository {
  Future<ChatMessagesModel?> fetchMessages({required ChatRequestModel request});
  Future<SendMessageResponseModel?> sendMessage({
    required SendMessageRequestModel request,
  });
}
