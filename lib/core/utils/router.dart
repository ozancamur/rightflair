import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/choose_username/page/choose_username_page.dart';
import 'package:rightflair/feature/authentication/pages/forgot_password_page.dart';
import 'package:rightflair/feature/authentication/pages/login_page.dart';
import 'package:rightflair/feature/authentication/pages/welcome_page.dart';
import 'package:rightflair/feature/create_post/page/create_post_page.dart';
import 'package:rightflair/feature/navigation/page/navigation_page.dart';
import 'package:rightflair/feature/profile_edit/repository/profile_edit_repository_impl.dart';
import 'package:rightflair/feature/search/page/search_page.dart';
import 'package:rightflair/feature/navigation/page/inbox/page/system_notifications_page.dart';
import 'package:rightflair/feature/navigation/page/inbox/page/new_followers_page.dart';
import 'package:rightflair/feature/settings/page/settings_page.dart';
import 'package:rightflair/feature/profile_edit/cubit/profile_edit_cubit.dart';

import '../../feature/authentication/model/user.dart';
import '../../feature/authentication/pages/register_page.dart';
import '../../feature/post_detail/page/post_detail_page.dart';
import '../../feature/profile_edit/page/profile_edit_page.dart';
import '../../feature/splash/page/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteConstants.SPLASH,
  debugLogDiagnostics: true,
  routes: [
    // WELCOME
    GoRoute(
      path: RouteConstants.SPLASH,
      name: RouteConstants.SPLASH,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteConstants.WELCOME,
      name: RouteConstants.WELCOME,
      builder: (context, state) => WelcomePage(),
    ),
    // AUTHENTICATION
    GoRoute(
      path: RouteConstants.REGISTER,
      name: RouteConstants.REGISTER,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: RouteConstants.CHOOSE_USERNAME,
      name: RouteConstants.CHOOSE_USERNAME,
      builder: (context, state) =>
          ChooseUsernamePage(user: state.extra as UserModel),
    ),
    GoRoute(
      path: RouteConstants.LOGIN,
      name: RouteConstants.LOGIN,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.FORGOT_PASSWORD,
      name: RouteConstants.FORGOT_PASSWORD,
      builder: (context, state) => ForgotPasswordPage(),
    ),
    // NAVIGATION
    GoRoute(
      path: RouteConstants.NAVIGATION,
      name: RouteConstants.NAVIGATION,
      builder: (context, state) => const NavigationPage(),
    ),
    // APPLICATION DETAIL
    GoRoute(
      path: RouteConstants.SEARCH,
      name: RouteConstants.SEARCH,
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouteConstants.CREATE_POST,
      name: RouteConstants.CREATE_POST,
      builder: (context, state) => const CreatePostPage(),
    ),
    GoRoute(
      path: RouteConstants.POST_DETAIL,
      name: RouteConstants.POST_DETAIL,
      builder: (context, state) => const PostDetailPage(),
    ),
    GoRoute(
      path: RouteConstants.EDIT_PROFILE,
      name: RouteConstants.EDIT_PROFILE,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (_) => ProfileEditCubit(ProfileEditRepositoryImpl()),
          child: ProfileEditPage(user: data['user'], tags: data['tags']),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.SYSTEM_NOTIFICATIONS,
      name: RouteConstants.SYSTEM_NOTIFICATIONS,
      builder: (context, state) => const SystemNotificationsPage(),
    ),
    GoRoute(
      path: RouteConstants.NEW_FOLLOWERS,
      name: RouteConstants.NEW_FOLLOWERS,
      builder: (context, state) => const NewFollowersPage(),
    ),
    GoRoute(
      path: RouteConstants.SETTINGS,
      name: RouteConstants.SETTINGS,
      builder: (context, state) => const SettingsPage(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.matchedLocation}')),
  ),
);
