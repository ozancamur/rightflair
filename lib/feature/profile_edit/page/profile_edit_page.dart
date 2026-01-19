import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/navigation/widgets/navigation_bottom_bar.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/utils/dialog.dart';
import '../cubit/profile_edit_cubit.dart';
import '../widgets/profile_edit_done_button.dart';
import '../widgets/profile_edit_image_widget.dart';
import '../widgets/profile_edit_text_field_widget.dart';
import '../widgets/profile_edit_styles_widget.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileEditCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _usernameController = TextEditingController(text: state.username);
    _bioController = TextEditingController(text: state.bio);

    _nameController.addListener(() {
      context.read<ProfileEditCubit>().updateName(_nameController.text);
    });
    _usernameController.addListener(() {
      context.read<ProfileEditCubit>().updateUsername(_usernameController.text);
    });
    _bioController.addListener(() {
      context.read<ProfileEditCubit>().updateBio(_bioController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileEditCubit, ProfileEditState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: _appBar(context),
          body: _body(context, state),
          navigation: const NavigationBottomBar(currentIndex: 3),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBarComponent(
      leading: const BackButtonComponent(),
      actions: [
        const ProfileEditDoneButtonWidget(),
        SizedBox(width: context.width * 0.04),
      ],
    );
  }

  Widget _body(BuildContext context, ProfileEditState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.05,
            vertical: context.height * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.height * 0.025,
            children: [
              _profileImage(state),
              _nameField(),
              _usernameField(),
              _bioField(state),
              _styles(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage(ProfileEditState state) {
    return Center(
      child: ProfileEditImageWidget(
        imageUrl: state.profileImage,
        onTap: () {
          // TODO: Implement image picker
        },
      ),
    );
  }

  Widget _nameField() {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_NAME,
      hintText: 'Lorem Ipsum',
      controller: _nameController,
    );
  }

  Widget _usernameField() {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_USERNAME,
      hintText: '@loremipsum',
      controller: _usernameController,
    );
  }

  Widget _bioField(ProfileEditState state) {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_BIO,
      hintText: 'Tell us about yourself...',
      controller: _bioController,
      maxLength: 100,
      maxLines: 4,
    );
  }

  Widget _styles(ProfileEditState state) {
    return ProfileEditStylesWidget(
      selectedStyles: state.selectedStyles,
      onRemoveStyle: (style) => context.read<ProfileEditCubit>().removeStyle(style),
      onAddNew: () => DialogUtils.showSelectMyStyles(context),
      canAddMore: context.read<ProfileEditCubit>().canAddMoreStyles,
    );
  }
}
