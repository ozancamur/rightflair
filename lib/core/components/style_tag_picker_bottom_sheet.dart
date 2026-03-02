import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/string.dart';
import '../extensions/context.dart';

class StyleTagPickerBottomSheet extends StatefulWidget {
  final List<String> selectedTags;
  static const int maxTags = 5;

  const StyleTagPickerBottomSheet({super.key, required this.selectedTags});

  /// Shows the bottom sheet and returns the updated list of selected tags.
  static Future<List<String>?> show(
    BuildContext context, {
    required List<String> selectedTags,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.secondary,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StyleTagPickerBottomSheet(selectedTags: selectedTags),
    );
  }

  @override
  State<StyleTagPickerBottomSheet> createState() =>
      _StyleTagPickerBottomSheetState();
}

class _StyleTagPickerBottomSheetState extends State<StyleTagPickerBottomSheet> {
  late List<String> _selected;
  bool _showMaxWarning = false;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.selectedTags);
  }

  List<String> get _filteredTags {
    return AppStrings.PREDEFINED_STYLE_TAGS;
  }

  void _toggle(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
        _showMaxWarning = false;
      } else {
        if (_selected.length >= StyleTagPickerBottomSheet.maxTags) {
          _showMaxWarning = true;
          return;
        }
        _selected.add(tag);
        _showMaxWarning = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: context.height * 0.65,
        child: Column(
          children: [
            _buildHandle(context),
            _buildHeader(context),
            if (_showMaxWarning) _buildWarning(context),
            Expanded(child: _buildTagGrid(context)),
            _buildDoneButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.height * 0.012),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.onSecondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.STYLE_TAG_PICKER_TITLE.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
          if (_selected.isNotEmpty)
            Text(
              AppStrings.STYLE_TAG_PICKER_SELECTED.tr(
                args: ['${_selected.length}'],
              ),
              style: TextStyle(
                fontSize: 14,
                color: context.colors.primary.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWarning(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          AppStrings.STYLE_TAG_PICKER_MAX_WARNING.tr(),
          style: TextStyle(
            fontSize: 13,
            color: context.colors.onErrorContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTagGrid(BuildContext context) {
    final tags = _filteredTags;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.015,
      ),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = _selected.contains(tag);
            final isDisabled =
                !isSelected &&
                _selected.length >= StyleTagPickerBottomSheet.maxTags;
            return GestureDetector(
              onTap: () => _toggle(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary
                      : isDisabled
                      ? context.colors.onSecondary.withValues(alpha: 0.1)
                      : context.colors.onSecondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.onSecondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: isSelected
                        ? context.colors.secondary
                        : isDisabled
                        ? context.colors.primaryContainer.withValues(alpha: 0.3)
                        : context.colors.primaryContainer,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.015,
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.scrim, context.colors.surface],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                AppStrings.STYLE_TAG_PICKER_DONE.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
