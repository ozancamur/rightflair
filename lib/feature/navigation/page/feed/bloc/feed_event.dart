part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostInitializeEvent extends FeedEvent {
  final int currentTabIndex;
  const LoadPostInitializeEvent({this.currentTabIndex = 0});
  @override
  List<Object?> get props => [currentTabIndex];
}

class LoadPostCommentsEvent extends FeedEvent {
  final String postId;
  const LoadPostCommentsEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class LoadMorePostsEvent extends FeedEvent {
  final int tabIndex;
  const LoadMorePostsEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class ChangeTabEvent extends FeedEvent {
  final int tabIndex;

  const ChangeTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class SwipeRightEvent extends FeedEvent {
  final String postId;

  const SwipeRightEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class SwipeLeftEvent extends FeedEvent {
  final String postId;

  const SwipeLeftEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class SendCommentToPostEvent extends FeedEvent {
  final String postId;
  final String content;
  final String? parentId;

  const SendCommentToPostEvent({
    required this.postId,
    required this.content,
    this.parentId,
  });

  @override
  List<Object?> get props => [postId, content, parentId];
}

class SavePostEvent extends FeedEvent {
  final String? postId;

  const SavePostEvent({this.postId});

  @override
  List<Object?> get props => [postId];
}
