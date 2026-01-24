part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoverFeedEvent extends FeedEvent {
}

class LoadFollowingFeedEvent extends FeedEvent {
}

class LoadFriendsFeedEvent extends FeedEvent {}

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
  final int tabIndex;
  final String postId;

  const SwipeRightEvent({required this.tabIndex, required this.postId});

  @override
  List<Object?> get props => [tabIndex, postId];
}

class SwipeLeftEvent extends FeedEvent {
  final int tabIndex;
  final String postId;

  const SwipeLeftEvent({required this.tabIndex, required this.postId});

  @override
  List<Object?> get props => [tabIndex, postId];
}
