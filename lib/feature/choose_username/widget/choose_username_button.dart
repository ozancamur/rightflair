import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../core/components/button/elevated_button.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/choose_username_cubit.dart';

class ChooseUsernameButtonWidget extends StatelessWidget {
  final bool isUnique;
  final bool isLoading;
  final bool canPop;
  const ChooseUsernameButtonWidget({
    super.key,
    required this.isLoading,
    required this.isUnique,
    required this.canPop,
  });

  @override
  Widget build(BuildContext context) {
    final ChooseUsernameCubit cubit = context.read<ChooseUsernameCubit>();
    return ElevatedButtonComponent(
      radius: 100,
      color: context.colors.outline.withOpacity(0.5),
      onPressed: () => isLoading
          ? null
          : isUnique
          ? cubit.onSave(context, canPop)
          : cubit.onCheck(context),
      child: isLoading
          ? LoadingComponent()
          : TextComponent(
              color: context.colors.primaryContainer,
              text: isUnique ? AppStrings.CONTINUE : AppStrings.CHECK,
              size: FontSizeConstants.LARGE,
              weight: FontWeight.w600,
            ),
    );
  }
}
