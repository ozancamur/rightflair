part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final int currentIndex;
  final List<Widget> pages;
  final bool isHomeRefreshing;
  const NavigationState(
    this.currentIndex,
    this.pages, {
    this.isHomeRefreshing = false,
  });

  const NavigationState.initial()
    : currentIndex = 0,
      isHomeRefreshing = false,
      pages = const [FeedPage(), AnalyticsPage(), InboxPage(), ProfilePage()];

  NavigationState copyWith({int? currentIndex, bool? isHomeRefreshing}) {
    return NavigationState(
      currentIndex ?? this.currentIndex,
      pages,
      isHomeRefreshing: isHomeRefreshing ?? this.isHomeRefreshing,
    );
  }

  @override
  List<Object> get props => [currentIndex, isHomeRefreshing];
}
