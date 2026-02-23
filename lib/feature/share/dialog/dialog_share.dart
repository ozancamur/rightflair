import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/share/cubit/share_cubit.dart';
import 'package:rightflair/feature/share/repository/share_repository_impl.dart';

import '../page/share_page.dart';

void dialogShare(
  BuildContext context, {
  String? postId,
  required String userId,
  bool showReport = true,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (context) => BlocProvider(
      create: (_) => ShareCubit(ShareRepositoryImpl()),
      child: SharePage(postId: postId, userId: userId, showReport: showReport),
    ),
  );
}
