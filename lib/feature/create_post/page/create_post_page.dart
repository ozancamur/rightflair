import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/appbar.dart';
import '../../../core/components/button/back_button.dart';
import '../../../core/components/text/appbar_title.dart';
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
        return BaseScaffold(
          appBar: _appbar(),
          body: _body(context, state),
        );
      },
    );
  }

  AppBarComponent _appbar() {
    return AppBarComponent(
      leading: BackButtonComponent(),
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

            // About your outfit section
            TextComponent(
              text: AppStrings.CREATE_POST_ABOUT_OUTFIT,
              size: FontSizeConstants.LARGE,
              weight: FontWeight.w600,
            ),
            SizedBox(height: context.height * 0.015),
            CreatePostDescription(controller: _descriptionController),
            SizedBox(height: context.height * 0.03),

            // Options
            CreatePostOptionsWidget(
              isAnonymous: state.isAnonymous,
              allowComments: state.allowComments,
              selectedLocation: state.selectedLocation,
            ),
            SizedBox(height: context.height * 0.02),

            // Buttons
            CreatePostBottomButtons(
              onDraft: () {},
              onPost: () {
                context.read<CreatePostCubit>().createPost();
              },
            ),
            SizedBox(height: context.height * 0.02),
          ],
        ),
      ),
    );
  }
}
