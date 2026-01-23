import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/utils/router.dart';
import 'package:rightflair/feature/authentication/bloc/authentication_bloc.dart';
import 'package:rightflair/feature/authentication/repository/authentication_repository_impl.dart';
import 'package:rightflair/feature/choose_username/cubit/choose_username_cubit.dart';
import 'package:rightflair/feature/choose_username/repository/choose_username_repository_impl.dart';
import 'package:rightflair/feature/create_post/repository/create_post_repository.dart';
import 'package:rightflair/feature/navigation/page/inbox/cubit/inbox_cubit.dart';
import 'package:rightflair/feature/location/cubit/location_cubit.dart';
import 'package:rightflair/feature/navigation/page/feed/bloc/feed_bloc.dart';
import 'package:rightflair/feature/navigation/page/profile/cubit/profile_cubit.dart';
import 'package:rightflair/feature/navigation/page/profile/repository/profile_repository_impl.dart';
import 'package:rightflair/feature/post_detail/cubit/post_detail_cubit.dart';
import 'package:rightflair/feature/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:rightflair/feature/profile_edit/repository/profile_edit_repository_impl.dart';
import 'package:rightflair/feature/settings/cubit/settings_cubit.dart';
import 'package:rightflair/feature/user/cubit/user_cubit.dart';
import 'package:rightflair/feature/user/repository/user_repository_impl.dart';

import 'core/config/theme_notifier.dart';
import 'core/constants/theme.dart';
import 'feature/create_post/cubit/create_post_cubit.dart';
import 'feature/navigation/page/inbox/repository/inbox_repository_impl.dart';
import 'feature/location/repository/location_repository_impl.dart';
import 'feature/navigation/cubit/navigation_cubit.dart';
import 'feature/navigation/page/analytics/cubit/analytics_cubit.dart';
import 'feature/navigation/page/analytics/repository/analytics_repository.dart';
import 'feature/settings/repository/settings_repository_impl.dart';

class RightFlair extends StatelessWidget {
  const RightFlair({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiBlocProvider(
      providers: [
        // AUTHENTICATION
        BlocProvider(create: (_) => AuthenticationBloc(AuthenticationRepositoryImpl())),
        BlocProvider(create: (_) => ChooseUsernameCubit(ChooseUsernameRepositoryImpl())),

        // NAVIGATION
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => FeedBloc()),
        BlocProvider(create: (_) => AnalyticsCubit(AnalyticsRepository())),
        BlocProvider(create: (_) => InboxCubit(InboxRepositoryImpl())),
        BlocProvider(create: (_) => ProfileCubit(ProfileRepositoryImpl())),

        
        BlocProvider(create: (_) => ProfileEditCubit(ProfileEditRepositoryImpl())),
        
        BlocProvider(create: (_) => UserCubit(UserRepositoryImpl())),
        BlocProvider(create: (_) => PostDetailCubit()),
        BlocProvider(create: (_) => SettingsCubit(SettingsRepositoryImpl())),

        
        BlocProvider(create: (_) => CreatePostCubit(CreatePostRepositoryImpl())),
        BlocProvider(create: (_) => LocationCubit(LocationRepositoryImpl())),
      ],
      child: MaterialApp.router(
        title: 'RightFlair',
        debugShowCheckedModeBanner: false,
        themeMode: themeNotifier.themeMode,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: context.locale,
        routerConfig: router,
      ),
    );
  }
}
