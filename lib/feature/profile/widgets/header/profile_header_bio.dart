import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';

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
    if (isExpanded) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(text: widget.text.tr()),
            TextSpan(
              text: " Hide",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
        final localizedText = widget.text.tr();
        final defaultTextStyle = const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        );

        final span = TextSpan(text: localizedText, style: defaultTextStyle);

        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: Directionality.of(context),
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return TextComponent(text: widget.text);
        }

        final linkText = '... Read more';
        final linkSpan = TextSpan(
          text: linkText,
          style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
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

        if (offset > localizedText.length) offset = localizedText.length;

        final truncatedText = localizedText.substring(0, offset);

        return RichText(
          text: TextSpan(
            style: defaultTextStyle,
            children: [
              TextSpan(text: truncatedText),
              TextSpan(text: "..."),
              TextSpan(
                text: " Read more",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
