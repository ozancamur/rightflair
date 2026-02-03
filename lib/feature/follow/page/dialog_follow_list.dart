import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/follow_list_cubit.dart';
import '../cubit/follow_list_state.dart';
import '../../user/repository/user_repository_impl.dart';
import 'follow_list_dialog_page.dart';

void dialogFollowList(
  BuildContext context, {
  required FollowListType listType,
  String? userId,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (context) => BlocProvider(
      create: (context) =>
          FollowListCubit(UserRepositoryImpl())
            ..init(listType: listType, userId: userId),
      child: FollowListDialogPage(listType: listType),
    ),
  );
}
