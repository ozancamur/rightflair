import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/appbar.dart';
import '../../../../core/components/button/back_button.dart';
import '../../../../core/components/text/appbar_title.dart';
import '../../../../core/helpers/text_parser.dart';
import '../../create_post/model/post.dart';
import '../cubit/post_update_cubit.dart';
import '../repository/post_update_repository_impl.dart';
import '../../../../core/components/button/gradient_button.dart';
import '../../../../core/constants/icons.dart';
import '../widgets/post_update_bottom_buttons.dart';
import '../widgets/post_update_description.dart';
import '../widgets/post_update_image.dart';
import '../widgets/post_update_music.dart';
import '../widgets/post_update_options.dart';

class PostUpdatePage extends StatefulWidget {
  final PostModel post;
  final bool isDraft;
  const PostUpdatePage({super.key, required this.post, required this.isDraft});

  @override
  State<PostUpdatePage> createState() => _PostUpdatePageState();
}

class _PostUpdatePageState extends State<PostUpdatePage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill description from existing post
    if (widget.post.description != null &&
        widget.post.description!.isNotEmpty) {
      _descriptionController.text = widget.post.description!;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostUpdateCubit(PostUpdateRepositoryImpl())
            ..init(post: widget.post, isDraft: widget.isDraft),
      child: BlocBuilder<PostUpdateCubit, PostUpdateState>(
        builder: (context, state) {
          return BaseScaffold(
            appBar: _appbar(context),
            body: _body(context, state),
          );
        },
      ),
    );
  }

  AppBarComponent _appbar(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(onBack: () => context.pop()),
      title: AppbarTitleComponent(title: AppStrings.UPDATE_POST_APPBAR),
    );
  }

  Widget _body(BuildContext context, PostUpdateState state) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image picker only for drafts (published posts can't change image)
              if (state.isDraft) ...[
                PostUpdateImageWidget(),
                SizedBox(height: context.height * 0.03),
              ],

              TextComponent(
                text: AppStrings.CREATE_POST_ABOUT_OUTFIT,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
              SizedBox(height: context.height * 0.015),
              PostUpdateDescription(controller: _descriptionController),
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
                  runSpacing: 8,
                  children: state.tags.map((tag) {
                    return Chip(
                      label: Text('#$tag'),
                      backgroundColor: context.colors.primaryFixedDim,
                      labelStyle: TextStyle(color: context.colors.primary),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      onDeleted: () {
                        context.read<PostUpdateCubit>().removeTag(tag);
                        final currentText = _descriptionController.text;
                        final updatedText = currentText
                            .replaceAll('#$tag', '')
                            .replaceAll(RegExp(r'\s+'), ' ')
                            .trim();
                        _descriptionController.text = updatedText;
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: context.height * 0.02),
              ],

              // Music section
              PostUpdateMusicWidget(),
              SizedBox(height: context.height * 0.02),

              // Options
              PostUpdateOptionsWidget(
                isAnonymous: state.isAnonymous,
                allowComments: state.allowComments,
                selectedLocation: state.selectedLocation,
              ),
              SizedBox(height: context.height * 0.02),

              // Buttons
              if (state.isDraft)
                PostUpdateBottomButtons(
                  onDraft: () {
                    final rawDescription = _descriptionController.text;
                    final tags = TextParser.parseTags(rawDescription);
                    final cleanDescription = TextParser.cleanText(
                      rawDescription,
                    );
                    context.read<PostUpdateCubit>().updateDraft(
                      context,
                      description: cleanDescription,
                      styleTags: tags,
                      mentionedUserIds: state.mentionedUserIds,
                    );
                  },
                  onPost: () {
                    final rawDescription = _descriptionController.text;
                    final tags = TextParser.parseTags(rawDescription);
                    final cleanDescription = TextParser.cleanText(
                      rawDescription,
                    );
                    context.read<PostUpdateCubit>().updateAndPublish(
                      context,
                      description: cleanDescription,
                      styleTags: tags,
                      mentionedUserIds: state.mentionedUserIds,
                    );
                  },
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.02,
                  ),
                  child: GradientButtonComponent(
                    height: context.height * 0.065,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            final rawDescription = _descriptionController.text;
                            final tags = TextParser.parseTags(rawDescription);
                            final cleanDescription = TextParser.cleanText(
                              rawDescription,
                            );
                            context.read<PostUpdateCubit>().updateDraft(
                              context,
                              description: cleanDescription,
                              styleTags: tags,
                              mentionedUserIds: state.mentionedUserIds,
                            );
                          },
                    radius: 100,
                    child: state.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: context.colors.primary,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: context.width * .02,
                            children: [
                              SvgPicture.asset(
                                AppIcons.CHECK,
                                colorFilter: ColorFilter.mode(
                                  context.colors.primary,
                                  BlendMode.srcIn,
                                ),
                                width: context.width * .05,
                              ),
                              TextComponent(
                                text: AppStrings.UPDATE_POST_UPDATE,
                                size: FontSizeConstants.LARGE,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                  ),
                ),
              SizedBox(height: context.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
