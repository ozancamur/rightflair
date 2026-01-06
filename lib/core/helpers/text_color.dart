import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';

List<InlineSpan> helperTextStyle(BuildContext context, String text) {
  final spans = <InlineSpan>[];
  final regex = RegExp(r'\*(.*?)\*');
  int start = 0;

  for (final match in regex.allMatches(text)) {
    if (match.start > start) {
      spans.add(
        TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    spans.add(
      TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontSize: 32,
          color: AppDarkColors.YELLOW,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    start = match.end;
  }

  if (start < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(start),
        style: TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  return spans;
}
