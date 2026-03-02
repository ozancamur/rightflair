import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/components/style_tag_picker_bottom_sheet.dart';
import '../../create_post/model/mention_user.dart';
import '../../create_post/widgets/create_post_describe_buttons.dart';
import '../cubit/post_update_cubit.dart';

class PostUpdateDescription extends StatefulWidget {
  final TextEditingController controller;
  const PostUpdateDescription({super.key, required this.controller});

  @override
  State<PostUpdateDescription> createState() => _PostUpdateDescriptionState();
}

class _PostUpdateDescriptionState extends State<PostUpdateDescription> {
  String _lastText = '';
  bool _isProcessing = false;
  final Set<String> _mentions = {};
  final Set<String> _tags = {};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_isProcessing) return;
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;

    if (text.length < _lastText.length) {
      _checkAndRemoveBrokenMentionsAndTags(text);
    }

    if (cursorPosition > 0 && cursorPosition <= text.length) {
      if (text.length > _lastText.length &&
          cursorPosition > 0 &&
          text[cursorPosition - 1] == '@') {
        _showMentionDialog();
      }
    }
    _lastText = text;
  }

  void _checkAndRemoveBrokenMentionsAndTags(String currentText) {
    _isProcessing = true;
    String modifiedText = currentText;
    bool textChanged = false;

    final mentionsToRemove = <String>[];
    for (var username in _mentions) {
      final mention = '@$username';
      if (!modifiedText.contains(mention)) {
        if (username.isNotEmpty) {
          final partialPattern = RegExp(
            '@${RegExp.escape(username.substring(0, 1))}[a-zA-Z0-9_]*',
          );
          modifiedText = modifiedText.replaceAll(partialPattern, '');
          textChanged = true;
        }
        mentionsToRemove.add(username);
      }
    }
    for (var username in mentionsToRemove) {
      _mentions.remove(username);
    }

    final tagsToRemove = <String>[];
    for (var tag in _tags) {
      final tagWithHash = '#$tag';
      if (!modifiedText.contains(tagWithHash)) {
        if (tag.isNotEmpty) {
          final partialPattern = RegExp(
            '#${RegExp.escape(tag.substring(0, 1))}[a-zA-Z0-9_]*',
          );
          modifiedText = modifiedText.replaceAll(partialPattern, '');
          textChanged = true;
        }
        tagsToRemove.add(tag);
        context.read<PostUpdateCubit>().removeTag(tag);
      }
    }
    for (var tag in tagsToRemove) {
      _tags.remove(tag);
    }

    if (textChanged) {
      final cursorPos = widget.controller.selection.baseOffset;
      widget.controller.text = modifiedText;
      _lastText = modifiedText;
      final newCursorPos = cursorPos.clamp(0, modifiedText.length);
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPos),
      );
    }
    _isProcessing = false;
  }

  Future<void> _showStyleTagPicker() async {
    final cubit = context.read<PostUpdateCubit>();
    final result = await StyleTagPickerBottomSheet.show(
      context,
      selectedTags: List<String>.from(cubit.state.tags),
    );
    if (result != null && mounted) {
      final currentTags = List<String>.from(cubit.state.tags);
      for (final tag in currentTags) {
        if (!result.contains(tag)) {
          cubit.removeTag(tag);
        }
      }
      for (final tag in result) {
        if (!currentTags.contains(tag)) {
          cubit.addTag(tag);
        }
      }
    }
  }

  void _insertHashTag() {
    _showStyleTagPicker();
  }

  Future<void> _showMentionDialog() async {
    _isProcessing = true;
    final result = await showDialog<MentionUserModel>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PostUpdateCubit>(),
        child: const _PostUpdateMentionDialog(),
      ),
    );

    if (result != null && mounted) {
      if (result.id != null) {
        context.read<PostUpdateCubit>().addMention(result.id!);
      }
      final currentText = widget.controller.text;
      var cursorPosition = widget.controller.selection.baseOffset;
      if (cursorPosition < 0 || cursorPosition > currentText.length) {
        cursorPosition = currentText.length;
      }
      final username = result.username ?? '';
      final mention = '@$username';
      final hasAtSign =
          cursorPosition > 0 &&
          currentText.length > cursorPosition - 1 &&
          currentText[cursorPosition - 1] == '@';

      final String newText;
      final int newCursorPosition;

      if (hasAtSign) {
        newText =
            '${currentText.substring(0, cursorPosition)}$username ${currentText.substring(cursorPosition)}';
        newCursorPosition = cursorPosition + username.length + 1;
      } else {
        newText =
            '${currentText.substring(0, cursorPosition)}$mention ${currentText.substring(cursorPosition)}';
        newCursorPosition = cursorPosition + mention.length + 1;
      }
      _mentions.add(username);
      widget.controller.text = newText;
      _lastText = newText;
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPosition),
      );
    }
    _isProcessing = false;
  }

  void _insertMention() {
    final currentText = widget.controller.text;
    var cursorPosition = widget.controller.selection.baseOffset;
    if (cursorPosition < 0 || cursorPosition > currentText.length) {
      cursorPosition = currentText.length;
    }
    _isProcessing = true;
    final newText =
        '${currentText.substring(0, cursorPosition)}@${currentText.substring(cursorPosition)}';
    widget.controller.text = newText;
    _lastText = newText;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + 1),
    );
    _isProcessing = false;
    Future.microtask(() => _showMentionDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.2,
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.shadow,
        borderRadius: BorderRadius.circular(context.width * 0.04),
        border: Border.all(color: context.colors.primaryFixedDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field(context),
          CreatePostDescribeButtonsWidget(
            onHashtagTap: _insertHashTag,
            onMentionTap: _insertMention,
          ),
        ],
      ),
    );
  }

  Expanded _field(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        maxLines: null,
        expands: true,
        style: TextStyle(color: context.colors.primary),
        decoration: InputDecoration(
          hintText: AppStrings.CREATE_POST_DESCRIPTION_PLACEHOLDER.tr(),
          hintStyle: TextStyle(color: context.colors.onPrimary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// Mention dialog that uses PostUpdateCubit instead of CreatePostCubit
class _PostUpdateMentionDialog extends StatefulWidget {
  const _PostUpdateMentionDialog();

  @override
  State<_PostUpdateMentionDialog> createState() =>
      _PostUpdateMentionDialogState();
}

class _PostUpdateMentionDialogState extends State<_PostUpdateMentionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<MentionUserModel> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final results = await context.read<PostUpdateCubit>().searchUsers(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mention User'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _search(value);
                  }
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final user = _results[index];
                        return ListTile(
                          title: Text(user.username ?? ''),
                          onTap: () => Navigator.pop(context, user),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
