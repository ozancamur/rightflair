import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/share/cubit/share_cubit.dart';

import '../page/report_page.dart';

void showReportPostDialog(
  BuildContext context, {
  String? postId,
  required String userId,
}) {
  final cubit = context.read<ShareCubit>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: ReportPage(postId: postId, userId: userId),
    ),
  );
}
