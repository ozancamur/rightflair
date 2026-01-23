import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/feature/settings/widgets/settings_appbar.dart';
import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/loading.dart';
import '../../../core/components/text.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/sections/settings_about.dart';
import '../widgets/sections/settings_account.dart';
import '../widgets/sections/settings_app.dart';
import '../widgets/sections/settings_notifications.dart';
import '../widgets/sections/settings_support.dart';
import '../widgets/settings_buttons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: const SettingsAppbarWidget(),
          body: (state.isLoading)
              ? const LoadingComponent()
              : _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, SettingsState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.015,
        children: [
          SettingsAccountWidget(
            username: state.username,
            email: state.email,
            emailVerified: state.emailVerified,
          ),
          SettingsNotificationsWidget(notifications: state.notifications),
          SettingsAppWidget(darkmode: state.isDarkMode),
          const SettingsSupportWidget(),
          const SettingsAboutWidget(),
          const SettingsButtonsWidget(),
          _buildVersion(context),
          SizedBox(height: context.height * 0.025),
        ],
      ),
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Center(
      child: TextComponent(
        text: AppStrings.SETTINGS_VERSION.tr(args: [AppConstants.VERSION]),
        size: FontSizeConstants.XX_SMALL,
        color: context.colors.primaryContainer,
        weight: FontWeight.w500,
        tr: false,
      ),
    );
  }
}
