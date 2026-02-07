part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedInitializeEvent extends FeedEvent {
  final int currentTabIndex;
  const FeedInitializeEvent({this.currentTabIndex = 0});
  @override
  List<Object?> get props => [currentTabIndex];
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

  const SendCommentToPostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class SavePostEvent extends FeedEvent {
  final String? postId;

  const SavePostEvent({this.postId});

  @override
  List<Object?> get props => [postId];
}

class LoadMoreStoriesEvent extends FeedEvent {
  const LoadMoreStoriesEvent();
}
