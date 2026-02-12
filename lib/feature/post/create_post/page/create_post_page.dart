import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/appbar.dart';
import '../../../../core/components/button/back_button.dart';
import '../../../../core/components/text/appbar_title.dart';
import '../cubit/create_post_cubit.dart';
import '../../../../core/helpers/text_parser.dart';
import '../widgets/create_post_options.dart';
import '../widgets/create_post_bottom_buttons.dart';
import '../widgets/create_post_description.dart';
import '../widgets/create_post_image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
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
      leading: BackButtonComponent(onBack: () => context.go(RouteConstants.NAVIGATION),),
      title: AppbarTitleComponent(title: AppStrings.CREATE_POST_APPBAR),
    );
  }

  SafeArea _body(BuildContext context, CreatePostState state) {
    return SafeArea(
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
                text: 'Tags',
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
                    deleteIcon: Icon(Icons.close, size: 16, color: context.colors.primary),
                    onDeleted: () {
                      // Remove from cubit
                      context.read<CreatePostCubit>().removeTag(tag);
                      // Remove from description text
                      final currentText = _descriptionController.text;
                      final updatedText = currentText.replaceAll('#$tag', '').replaceAll(RegExp(r'\s+'), ' ').trim();
                      _descriptionController.text = updatedText;
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
                final rawDescription = _descriptionController.text;
                final tags = TextParser.parseTags(rawDescription);
                final cleanDescription = TextParser.cleanText(rawDescription);
                context.read<CreatePostCubit>().createDraft(
                  description: cleanDescription,
                  styleTags: tags,
                  mentionedUserIds: state.mentionedUserIds,
                );
              },
              onPost: () {
                final rawDescription = _descriptionController.text;
                final tags = TextParser.parseTags(rawDescription);
                final cleanDescription = TextParser.cleanText(rawDescription);
                context.read<CreatePostCubit>().createPost(
                  description: cleanDescription,
                  styleTags: tags,
                  mentionedUserIds: state.mentionedUserIds,
                );
              },
            ),
            SizedBox(height: context.height * 0.02),
          ],
        ),
      ),
    );
  }
}
