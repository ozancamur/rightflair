import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class CommentTranslateDialog {
  CommentTranslateDialog._();

  static Future<void> show(
    BuildContext context, {
    required String originalText,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TranslatePopup(originalText: originalText),
    );
  }
}

class _TranslatePopup extends StatefulWidget {
  final String originalText;
  const _TranslatePopup({required this.originalText});

  @override
  State<_TranslatePopup> createState() => _TranslatePopupState();
}

class _TranslatePopupState extends State<_TranslatePopup> {
  bool _isLoading = true;
  String? _translatedText;
  String? _error;

  @override
  void initState() {
    super.initState();
    _translate();
  }

  Future<void> _translate() async {
    try {
      final translator = GoogleTranslator();
      final result = await translator.translate(widget.originalText, to: 'en');

      if (mounted) {
        setState(() {
          _translatedText = result.text;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate,
                  color: context.colors.primary,
                  size: context.width * 0.06,
                ),
                SizedBox(width: context.width * 0.02),
                TextComponent(
                  text: AppStrings.COMMENTS_TRANSLATE,
                  size: FontSizeConstants.LARGE,
                  weight: FontWeight.w600,
                  color: context.colors.primary,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: context.colors.primary.withValues(alpha: 0.5),
                    size: context.width * 0.05,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.height * 0.02),
            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.03,
                  ),
                  child: SizedBox(
                    width: context.width * 0.06,
                    height: context.width * 0.06,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colors.scrim,
                    ),
                  ),
                ),
              )
            else if (_error != null)
              TextComponent(
                text: _error!,
                tr: false,
                size: FontSizeConstants.SMALL,
                color: context.colors.error,
              )
            else
              TextComponent(
                text: _translatedText ?? '',
                tr: false,
                size: FontSizeConstants.NORMAL,
                color: context.colors.primary,
                height: 1.5,
              ),
          ],
        ),
      ),
    );
  }
}
