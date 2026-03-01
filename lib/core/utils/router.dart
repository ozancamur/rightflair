
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/choose_username/page/choose_username_page.dart';
import 'package:rightflair/feature/authentication/pages/forgot_password_page.dart';
import 'package:rightflair/feature/authentication/pages/login_page.dart';
import 'package:rightflair/feature/authentication/pages/welcome_page.dart';
import 'package:rightflair/feature/post/create_post/page/camera_page.dart';
import 'package:rightflair/feature/post/create_post/page/create_post_page.dart';
import 'package:rightflair/feature/main/navigation/page/navigation_page.dart';
import 'package:rightflair/feature/search/page/search_page.dart';
import 'package:rightflair/feature/notifications/system_notifications/page/system_notifications_page.dart';
import 'package:rightflair/feature/notifications/new_followers/page/new_followers_page.dart';
import 'package:rightflair/feature/settings/page/settings_page.dart';

import '../../feature/authentication/pages/register_page.dart';
import '../../feature/chat/page/chat_page.dart';
import '../../feature/find_friends/page/find_friends_page.dart';
import '../../feature/follow/page/follow_page.dart';
import '../../feature/post/create_post/model/post.dart';
import '../../feature/main/feed/models/user_with_stories.dart';
import '../../feature/post/post_detail/page/post_detail_page.dart';
import '../../feature/post/post_update/page/post_update_page.dart';
import '../../feature/profile_edit/page/profile_edit_page.dart';
import '../../feature/authentication/pages/splash_page.dart';
import '../../feature/story/story_view/page/story_view_page.dart';
import '../../feature/user/page/user_page.dart';
import '../constants/enums/follow_list_type.dart';

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
      builder: (context, state) {
        final Map<String, dynamic> args =
            state.extra as Map<String, dynamic>? ?? {};
        return ChooseUsernamePage(
          username: args['username'],
          canPop: args['canPop'] ?? false,
        );
      },
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
      path: RouteConstants.CAMERA,
      name: RouteConstants.CAMERA,
      builder: (context, state) => const CameraPage(),
    ),
    GoRoute(
      path: RouteConstants.CREATE_POST,
      name: RouteConstants.CREATE_POST,
      builder: (context, state) => const CreatePostPage(),
    ),
    GoRoute(
      path: RouteConstants.POST_DETAIL,
      name: RouteConstants.POST_DETAIL,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PostDetailPage(
          postId: data['postId'] as String,
          isDraft: data['isDraft'] as bool,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.POST_UPDATE,
      name: RouteConstants.POST_UPDATE,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PostUpdatePage(
          post: data['post'] as PostModel,
          isDraft: data['isDraft'] as bool,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.EDIT_PROFILE,
      name: RouteConstants.EDIT_PROFILE,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ProfileEditPage(user: data['user'], tags: data['tags']);
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
      path: RouteConstants.CHAT,
      name: RouteConstants.CHAT,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ChatPage(
          conversationId: data['conversationId'] as String,
          otherUserName: data['otherUserName'] as String,
          otherUserPhoto: data['otherUserPhoto'] as String?,
          otherUserId: data['otherUserId'] as String,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.SETTINGS,
      name: RouteConstants.SETTINGS,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: RouteConstants.USER,
      name: RouteConstants.USER,
      builder: (context, state) => UserPage(userId: state.extra as String),
    ),
    GoRoute(
      path: RouteConstants.FIND_FRIENDS,
      name: RouteConstants.FIND_FRIENDS,
      builder: (context, state) => const FindFriendsPage(),
    ),
    GoRoute(
      path: RouteConstants.FOLLOW,
      name: RouteConstants.FOLLOW,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return FollowPage(
          listType: data['listType'] as FollowListType,
          username: data['username'] as String,
          userId: data['userId'] as String?,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.STORY_VIEWER,
      name: RouteConstants.STORY_VIEWER,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          opaque: false,
          barrierDismissible: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: StoryViewPage(
            isMyStory: data['isMyStory'] as bool,
            stories: data['allStories'] as List<UserWithStoriesModel>,
            index: data['initialUserIndex'] as int,
            onStoryDeleted: data['onStoryDeleted'] as VoidCallback?,
            onStoryViewed: data['onStoryViewed'] as Function(String, String)?,
          ),
        );
      },
    ),
  ],

  errorBuilder: (context, state) => const SplashPage(),
);
