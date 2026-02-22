import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/enums/follow_list_type.dart';
import '../cubit/follow_cubit.dart';
import '../repository/follow_repository_impl.dart';
import 'follow_page.dart';

void dialogFollow(
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
          FollowCubit(FollowRepositoryImpl())
            ..init(listType: listType, userId: userId),
      child: FollowPage(listType: listType),
    ),
  );
}
