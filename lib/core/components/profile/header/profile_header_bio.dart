import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileHeaderBioWidget extends StatefulWidget {
  final String text;
  const ProfileHeaderBioWidget({super.key, required this.text});

  @override
  State<ProfileHeaderBioWidget> createState() => _ProfileHeaderBioWidgetState();
}

class _ProfileHeaderBioWidgetState extends State<ProfileHeaderBioWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.0075,
        children: [
          TextComponent(
            text: "Bio",
            color: context.colors.primary,
            weight: FontWeight.w600,
            size: FontSizeConstants.NORMAL,
          ),
          widget.text == ""
              ? TextComponent(
                  text: "Tell us about yourself...",
                  color: context.colors.tertiary,
                  weight: FontWeight.w400,
                  size: FontSizeConstants.X_SMALL,
                )
              : AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  child: _buildContent(context),
                ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textStyle = TextStyle(
      color: context.colors.primaryContainer,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );
    final actionStyle = TextStyle(
      color: context.colors.primary,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );

    if (isExpanded) {
      return RichText(
        text: TextSpan(
          style: textStyle,
          children: [
            TextSpan(text: widget.text),
            TextSpan(
              text: AppStrings.PROFILE_HIDE.tr(),
              style: actionStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = false;
                  });
                },
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: textStyle);

        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: Directionality.of(context),
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return TextComponent(
            text: widget.text,
            tr: false,
            color: context.colors.primary,
          );
        }

        final linkSpan = TextSpan(
          text: AppStrings.PROFILE_READ_MORE.tr(),
          style: actionStyle,
        );

        final linkTp = TextPainter(
          text: linkSpan,
          textDirection: Directionality.of(context),
        );
        linkTp.layout();
        final linkWidth = linkTp.width;

        final pos = tp.getPositionForOffset(
          Offset(constraints.maxWidth - linkWidth, tp.height),
        );
        int offset = pos.offset;

        if (offset > widget.text.length) offset = widget.text.length;

        final truncatedText = widget.text.substring(0, offset - 10);

        return RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: textStyle,
            children: [
              TextSpan(text: truncatedText),
              TextSpan(text: "...      "),
              TextSpan(
                text: AppStrings.PROFILE_READ_MORE.tr(),
                style: actionStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => isExpanded = true),
              ),
            ],
          ),
        );
      },
    );
  }
}
