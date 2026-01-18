import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/feature/settings/widgets/settings_appbar.dart';
import '../../../core/base/base_scaffold.dart';
import '../../../core/components/loading.dart';
import '../../../core/components/text.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import 'package:rightflair/main.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/sections/settings_about.dart';
import '../widgets/sections/settings_account.dart';
import '../widgets/sections/settings_app.dart';
import '../widgets/sections/settings_notifications.dart';
import '../widgets/sections/settings_support.dart';
import '../widgets/settings_buttons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final isDarkMode =
            context.read<ThemeNotifier>().themeMode == ThemeMode.dark;
        return SettingsCubit()..loadSettings(isDarkMode: isDarkMode);
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return BaseScaffold(
            appBar: SettingsAppbarWidget(),
            body: (state is SettingsLoading)
                ? const LoadingComponent()
                : (state is SettingsLoaded)
                ? _body(context, state)
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.015,
        children: [
          SettingsAccountWidget(
            username: state.settings.username,
            email: state.settings.email,
          ),
          const SettingsSupportWidget(),
          SettingsNotificationsWidget(
            likes: state.settings.likesEnabled,
            saves: state.settings.savesEnabled,
            milestones: state.settings.milestonesEnabled,
            trending: state.settings.trendingEnabled,
            follow: state.settings.followEnabled,
          ),
          SettingsAppWidget(
            darkmode: state.settings.darkModeEnabled,
            language: state.settings.language,
          ),
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
