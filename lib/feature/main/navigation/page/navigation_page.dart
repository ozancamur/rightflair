import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/post/create_post/cubit/create_post_cubit.dart';
import 'package:rightflair/feature/post/create_post/widgets/continue_editing_snackbar.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/navigation_bottom_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool _hasCheckedPendingPost = false;

  @override
  void initState() {
    super.initState();
    context.read<NavigationCubit>().reset();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint(
      '[ContinueEditing] NavigationPage.didChangeDependencies called, hasChecked=$_hasCheckedPendingPost',
    );
    if (!_hasCheckedPendingPost) {
      _hasCheckedPendingPost = true;
      _checkPendingPost();
    }
  }

  Future<void> _checkPendingPost() async {
    try {
      debugPrint('[ContinueEditing] NavigationPage._checkPendingPost: START');
      final cubit = context.read<CreatePostCubit>();
      debugPrint(
        '[ContinueEditing] NavigationPage._checkPendingPost: cubit state imagePath=${cubit.state.imagePath}',
      );
      final pendingData = await cubit.getPendingPostData();
      debugPrint(
        '[ContinueEditing] NavigationPage._checkPendingPost: pendingData=${pendingData != null ? 'EXISTS (keys: ${pendingData.keys.toList()})' : 'NULL'}',
      );
      if (pendingData != null && mounted) {
        debugPrint(
          '[ContinueEditing] NavigationPage._checkPendingPost: waiting 500ms...',
        );
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint(
          '[ContinueEditing] NavigationPage._checkPendingPost: mounted=$mounted',
        );
        if (mounted) {
          debugPrint(
            '[ContinueEditing] NavigationPage._checkPendingPost: restoring to cubit & clearing cache...',
          );
          final cubit = context.read<CreatePostCubit>();
          await cubit.restorePendingPost();
          debugPrint(
            '[ContinueEditing] NavigationPage._checkPendingPost: restored, imagePath=${cubit.state.imagePath}',
          );
          if (mounted) {
            // Use the resolved imagePath from cubit state (not raw cache data)
            final resolvedData = Map<String, dynamic>.from(pendingData);
            resolvedData['imagePath'] = cubit.state.imagePath;
            resolvedData['originalImagePath'] = cubit.state.originalImagePath;
            ContinueEditingSnackbar.show(
              context,
              pendingPostData: resolvedData,
            );
            debugPrint(
              '[ContinueEditing] NavigationPage._checkPendingPost: snackbar.show() called with resolved imagePath=${cubit.state.imagePath}',
            );
          }
        }
      } else {
        debugPrint(
          '[ContinueEditing] NavigationPage._checkPendingPost: no pending post or not mounted (mounted=$mounted)',
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '[ContinueEditing] NavigationPage._checkPendingPost: ERROR $e',
      );
      debugPrint('[ContinueEditing] StackTrace: $stackTrace');
    }
  }

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
