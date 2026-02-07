import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/page/feed_page.dart';
import 'package:rightflair/feature/navigation/page/analytics/page/analytics_page.dart';

import '../page/inbox/page/inbox_page.dart';
import '../page/profile/page/profile_page.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final PageController controller = PageController();
  NavigationCubit() : super(NavigationState.initial());

  void route(int index) {
    if (state.currentIndex != index) {
      controller.jumpToPage(index);
      emit(state.copyWith(currentIndex: index));
    }
  }
}
