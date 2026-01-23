import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/navigation/widgets/navigation_bottom_bar.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/utils/dialog.dart';
import '../../authentication/model/user.dart';
import '../cubit/profile_edit_cubit.dart';
import '../widgets/profile_edit_done_button.dart';
import '../widgets/profile_edit_image_widget.dart';
import '../widgets/profile_edit_text_field_widget.dart';
import '../widgets/profile_edit_styles_widget.dart';

class ProfileEditPage extends StatefulWidget {
  final UserModel user;
  final List<String> tags;
  const ProfileEditPage({super.key, required this.user, required this.tags});

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
    final ProfileEditCubit cubit = context.read<ProfileEditCubit>();
    final ProfileEditState state = cubit.state;

    final initialName = state.name ?? widget.user.fullName ?? '';
    final initialUsername = state.username ?? widget.user.username ?? '';
    final initialBio = state.bio ?? widget.user.bio ?? '';

    _nameController = TextEditingController(text: initialName);
    _usernameController = TextEditingController(text: initialUsername);
    _bioController = TextEditingController(text: initialBio);

    if (state.name == null && initialName.isNotEmpty) {
      cubit.updateName(initialName);
    }
    if (state.username == null && initialUsername.isNotEmpty) {
      cubit.updateUsername(initialUsername);
    }
    if (state.bio == null && initialBio.isNotEmpty) {
      cubit.updateBio(initialBio);
    }

    if (state.selectedStyles == null) {
      cubit.initStyles(widget.tags);
    }

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
          appBar: _appBar(context, state.hasUpdated),
          body: _body(context, state),
          navigation: const NavigationBottomBar(currentIndex: 3),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, bool updated) {
    return AppBarComponent(
      leading: BackButtonComponent(onBack: () => context.pop()),
      actions: [
        ProfileEditDoneButtonWidget(user: widget.user),
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
    final String? displayImageUrl =
        state.profileImage ?? widget.user.profilePhotoUrl;

    return ProfileEditImageWidget(
      imageUrl: displayImageUrl,
      isUploading: state.isUploading,
      onTap: () => context.read<ProfileEditCubit>().changePhotoDialog(
        context,
        userId: widget.user.id ?? '',
      ),
    );
  }

  Widget _nameField() {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_NAME,
      hintText: widget.user.fullName ?? "Rightflair User",
      controller: _nameController,
    );
  }

  Widget _usernameField() {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_USERNAME,
      hintText: widget.user.username ?? "rightflair_user",
      controller: _usernameController,
      prefixText: '@',
    );
  }

  Widget _bioField(ProfileEditState state) {
    return ProfileEditTextFieldWidget(
      label: AppStrings.PROFILE_EDIT_BIO,
      hintText: widget.user.bio ?? 'Tell us about yourself...',
      controller: _bioController,
      maxLength: 100,
      maxLines: 4,
    );
  }

  Widget _styles(ProfileEditState state) {
    return ProfileEditStylesWidget(
      currentTags: state.selectedStyles ?? widget.tags,
      onRemoveStyle: (style) =>
          context.read<ProfileEditCubit>().removeStyle(style),
      onAddNew: () => DialogUtils.showSelectMyStyles(context),
      canAddMore: context.read<ProfileEditCubit>().canAddMoreStyles,
    );
  }
}
