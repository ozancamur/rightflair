import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/color/color.dart';
import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';

class PostLikeButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const PostLikeButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.height * .06,
        width: context.height * .06,
        padding: EdgeInsets.all(context.width * .0275),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.YELLOW, AppColors.ORANGE],
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomCenter,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(AppIcons.FIRE, color: Colors.white),
      ),
    );
  }
}
