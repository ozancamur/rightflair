import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/navigation_bottom_bar.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NavigationCubit>();
    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return BaseScaffold(
          body: _body(context, state, cubit.controller),
          navigation: NavigationBottomBar(currentIndex: state.currentIndex),
        );
      },
    );
  }

  SizedBox _body(
    BuildContext context,
    NavigationState state,
    PageController controller,
  ) {
    return SizedBox(
      height: context.height,
      width: context.width,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: state.pages,
      ),
    );
  }
}
