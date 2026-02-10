import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/extensions/context.dart';

class PostDislikeButton extends StatelessWidget {
  final VoidCallback onTap;
  const PostDislikeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.height * .06,
        width: context.height * .06,
        padding: EdgeInsets.all(context.width * .0275),
        decoration: BoxDecoration(
          color: context.colors.onErrorContainer,
          border: Border.all(
            width: 1,
            color: context.colors.primary.withOpacity(.16),
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppIcons.DISLIKE,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
