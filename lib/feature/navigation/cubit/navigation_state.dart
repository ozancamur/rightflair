part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final int currentIndex;
  final List<Widget> pages;
  const NavigationState(this.currentIndex, this.pages);

  NavigationState.initial()
    : currentIndex = 0,
      pages = const [FeedPage(), AnalyticsPage(), InboxPage(), ProfilePage()];

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex ?? this.currentIndex, pages);
  }

  @override
  List<Object> get props => [currentIndex];
}
