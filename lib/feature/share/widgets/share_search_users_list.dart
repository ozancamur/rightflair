import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import 'share_user.dart';

class ShareSearchUsersListWidget extends StatelessWidget {
  const ShareSearchUsersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.03),
            child: SizedBox(
              width: context.width * 0.05,
              height: context.width * 0.05,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            ),
          );
        }

        if (state.searchResults.isEmpty) {
          return SizedBox(
            height: context.height * 0.2,
            width: context.width,
            child: Center(
              child: Text(
                AppStrings.SHARE_DIALOG_NO_USER.tr(),
                style: TextStyle(
                  color: context.colors.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: context.height * 0.5),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: context.height * 0.01),
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final user = state.searchResults[index];
              return ShareUserWidget(user: user);
            },
          ),
        );
      },
    );
  }
}
