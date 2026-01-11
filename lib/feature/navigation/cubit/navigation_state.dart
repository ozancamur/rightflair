part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final int currentIndex;
  final List<Widget> pages;
  const NavigationState(this.currentIndex, this.pages);

  NavigationState.initial()
    : currentIndex = 0,
      pages = [FeedPage(), AnalyticsPage(), SizedBox(), SizedBox()];

  NavigationState copyWith({int? currentIndex, List<Widget>? pages}) {
    return NavigationState(
      currentIndex ?? this.currentIndex,
      pages ?? this.pages,
    );
  }

  @override
  List<Object> get props => [currentIndex, pages];
}
