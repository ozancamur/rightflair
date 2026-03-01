import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/appbar.dart';
import '../../../../core/components/button/back_button.dart';
import '../../../../core/components/text/appbar_title.dart';
import '../cubit/create_post_cubit.dart';
import '../widgets/create_post_options.dart';
import '../widgets/create_post_bottom_buttons.dart';
import '../widgets/create_post_description.dart';
import '../widgets/create_post_image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with WidgetsBindingObserver {
  final TextEditingController _descriptionController = TextEditingController();
  late final CreatePostCubit _createPostCubit;
  bool _isAppInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _createPostCubit = context.read<CreatePostCubit>();
    debugPrint(
      '[ContinueEditing] CreatePostPage.initState: imagePath=${_createPostCubit.state.imagePath}',
    );
    _restoreDescriptionIfNeeded();
    _initializeAndSaveCache();
  }

  /// Restore from cache if needed, then save current state to cache
  Future<void> _initializeAndSaveCache() async {
    await _restoreFromCacheIfNeeded();
    if (mounted && _createPostCubit.state.imagePath != null) {
      debugPrint(
        '[ContinueEditing] CreatePostPage: saving to cache on page open',
      );
      _createPostCubit.savePendingPost(
        description: _descriptionController.text,
      );
    }
  }

  /// Restore description text from pending post state if available
  void _restoreDescriptionIfNeeded() {
    final pendingDesc = _createPostCubit.state.pendingDescription;
    if (pendingDesc != null && pendingDesc.isNotEmpty) {
      _descriptionController.text = pendingDesc;
    }
  }

  /// Fallback: if cubit has no imagePath, check cache and restore
  Future<void> _restoreFromCacheIfNeeded() async {
    if (_createPostCubit.state.imagePath != null) {
      debugPrint(
        '[ContinueEditing] CreatePostPage: imagePath already set, no need to restore',
      );
      return;
    }
    debugPrint(
      '[ContinueEditing] CreatePostPage: imagePath is null, checking cache...',
    );
    final pendingData = await _createPostCubit.getPendingPostData();
    if (pendingData != null && mounted) {
      debugPrint(
        '[ContinueEditing] CreatePostPage: found pending data in cache, restoring...',
      );
      await _createPostCubit.restorePendingPost();
      debugPrint(
        '[ContinueEditing] CreatePostPage: restored, imagePath=${_createPostCubit.state.imagePath}',
      );
      // Also restore description
      final pendingDesc = _createPostCubit.state.pendingDescription;
      if (pendingDesc != null && pendingDesc.isNotEmpty) {
        _descriptionController.text = pendingDesc;
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('[ContinueEditing] CreatePostPage lifecycle: $state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _isAppInBackground = true;
      debugPrint(
        '[ContinueEditing] CreatePostPage: app going background, saving...',
      );
      _createPostCubit.savePendingPost(
        description: _descriptionController.text,
      );
    } else if (state == AppLifecycleState.resumed) {
      _isAppInBackground = false;
      debugPrint('[ContinueEditing] CreatePostPage: app resumed');
    }
  }

  @override
  void dispose() {
    debugPrint(
      '[ContinueEditing] CreatePostPage.dispose() called, isAppInBackground=$_isAppInBackground',
    );
    WidgetsBinding.instance.removeObserver(this);
    if (_isAppInBackground) {
      debugPrint(
        '[ContinueEditing] CreatePostPage.dispose(): saving pending post (background kill)',
      );
      _createPostCubit.savePendingPost(
        description: _descriptionController.text,
      );
    }
    _descriptionController.dispose();
    _createPostCubit.stopMusic();
    _createPostCubit.setSelectedMusic(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return BaseScaffold(appBar: _appbar(), body: _body(context, state));
      },
    );
  }

  AppBarComponent _appbar() {
    return AppBarComponent(
      leading: BackButtonComponent(
        onBack: () {
          _createPostCubit.clearPendingPost();
          context.pop();
        },
      ),
      title: AppbarTitleComponent(title: AppStrings.CREATE_POST_APPBAR),
    );
  }

  Widget _body(BuildContext context, CreatePostState state) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreatePostImageWidget(),
              SizedBox(height: context.height * 0.03),

              TextComponent(
                text: AppStrings.CREATE_POST_ABOUT_OUTFIT,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
              SizedBox(height: context.height * 0.015),
              CreatePostDescription(controller: _descriptionController),
              SizedBox(height: context.height * 0.02),

              // Display selected tags
              if (state.tags.isNotEmpty) ...[
                TextComponent(
                  text: AppStrings.CREATE_POST_TAGS,
                  size: FontSizeConstants.NORMAL,
                  weight: FontWeight.w500,
                ),
                SizedBox(height: context.height * 0.01),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: state.tags.map((tag) {
                    return Chip(
                      label: Text('#$tag'),
                      backgroundColor: context.colors.primaryFixedDim,
                      labelStyle: TextStyle(color: context.colors.primary),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      onDeleted: () {
                        // Remove from cubit
                        context.read<CreatePostCubit>().removeTag(tag);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: context.height * 0.02),
              ],

              // Options
              CreatePostOptionsWidget(
                isAnonymous: state.isAnonymous,
                allowComments: state.allowComments,
                selectedLocation: state.selectedLocation,
              ),
              SizedBox(height: context.height * 0.02),

              // Buttons
              CreatePostBottomButtons(
                onDraft: () {
                  final description = _descriptionController.text.trim();
                  context.read<CreatePostCubit>().createDraft(
                    context,
                    description: description,
                    styleTags: state.tags,
                    mentionedUserIds: state.mentionedUserIds,
                  );
                },
                onPost: () {
                  final description = _descriptionController.text.trim();
                  context.read<CreatePostCubit>().createPost(
                    context,
                    description: description,
                    styleTags: state.tags,
                    mentionedUserIds: state.mentionedUserIds,
                  );
                },
              ),
              SizedBox(height: context.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
