import 'package:equatable/equatable.dart';
import '../model/message.dart';
import '../model/notification_model.dart';

abstract class InboxState extends Equatable {
  const InboxState();

  @override
  List<Object> get props => [];
}

class InboxInitial extends InboxState {}

class InboxLoading extends InboxState {}

class InboxLoaded extends InboxState {
  final List<MessageModel> messages;
  final List<NotificationModel> notifications;

  const InboxLoaded(this.messages, this.notifications);

  @override
  List<Object> get props => [messages, notifications];
}

class InboxError extends InboxState {
  final String message;

  const InboxError(this.message);

  @override
  List<Object> get props => [message];
}
