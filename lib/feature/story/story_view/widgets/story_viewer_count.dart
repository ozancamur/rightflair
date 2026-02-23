import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

class StoryViewerCount extends StatelessWidget {
  final int viewCount;
  final VoidCallback onTap;

  const StoryViewerCount({
    super.key,
    required this.viewCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * .05,
        width: context.width,
        child: Padding(
          padding: EdgeInsets.only(left: context.width * .04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_outlined,
                color: Colors.white,
                size: context.height * .025,
              ),
              SizedBox(width: context.width * .015),
              TextComponent(
                text: '$viewCount',
                color: Colors.white,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w600,
                tr: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
