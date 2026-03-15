import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class CommentOptionsPopup extends StatelessWidget {
  final VoidCallback onReport;

  const CommentOptionsPopup({super.key, required this.onReport});

  static void show(BuildContext context, {required VoidCallback onReport}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => CommentOptionsPopup(onReport: onReport),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.width * 0.05),
          topRight: Radius.circular(context.width * 0.05),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragHandle(context),
          _optionTile(
            context,
            icon: AppIcons.REPORT,
            label: AppStrings.COMMENTS_REPORT,
            color: context.colors.error,
            onTap: () {
              Navigator.pop(context);
              onReport();
            },
          ),

          SizedBox(height: context.height * 0.04),
        ],
      ),
    );
  }

  Widget _dragHandle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: context.height * 0.01,
        bottom: context.height * 0.005,
      ),
      width: context.width * 0.1,
      height: context.height * 0.005,
      decoration: BoxDecoration(
        color: context.colors.onPrimaryFixed,
        borderRadius: BorderRadius.circular(context.width * 0.005),
      ),
    );
  }

  Widget _optionTile(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.03),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.height * 0.015,
          horizontal: context.width * 0.05,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: context.width * 0.06,
              height: context.width * 0.06,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: TextComponent(
                text: label,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
