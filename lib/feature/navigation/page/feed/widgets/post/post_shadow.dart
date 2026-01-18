import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';

import '../../../../../../core/extensions/context.dart';

class PostShadowWidget extends StatelessWidget {
  const PostShadowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .4,
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.width * 0.06),
        gradient: LinearGradient(
          colors: AppColors.SHADOWS,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}
