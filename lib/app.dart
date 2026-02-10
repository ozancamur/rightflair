import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/utils/router.dart';
import 'package:rightflair/feature/authentication/bloc/authentication_bloc.dart';
import 'package:rightflair/feature/authentication/repository/authentication_repository_impl.dart';
import 'package:rightflair/feature/choose_username/cubit/choose_username_cubit.dart';
import 'package:rightflair/feature/choose_username/repository/choose_username_repository_impl.dart';
import 'package:rightflair/feature/comments/cubit/comments_cubit.dart';
import 'package:rightflair/feature/comments/repository/comments_repository_impl.dart';
import 'package:rightflair/feature/post/create_post/repository/create_post_repository.dart';
import 'package:rightflair/feature/story/create_story/repository/create_story_repository_impl.dart';
import 'package:rightflair/feature/main/inbox/cubit/inbox_cubit.dart';
import 'package:rightflair/feature/location/cubit/location_cubit.dart';
import 'package:rightflair/feature/main/feed/bloc/feed_bloc.dart';
import 'package:rightflair/feature/main/profile/cubit/profile_cubit.dart';
import 'package:rightflair/feature/main/profile/repository/profile_repository_impl.dart';
import 'package:rightflair/feature/notifications/new_followers/cubit/new_followers_cubit.dart';
import 'package:rightflair/feature/post/post_detail/cubit/post_detail_cubit.dart';
import 'package:rightflair/feature/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:rightflair/feature/profile_edit/repository/profile_edit_repository_impl.dart';
import 'package:rightflair/feature/search/cubit/search_cubit.dart';
import 'package:rightflair/feature/settings/cubit/settings_cubit.dart';
import 'package:rightflair/feature/story/story_view/repository/story_view_repository_impl.dart';
import 'package:rightflair/feature/user/cubit/user_cubit.dart';
import 'package:rightflair/feature/user/repository/user_repository_impl.dart';

import 'core/config/theme_notifier.dart';
import 'core/constants/theme.dart';
import 'feature/chat/cubit/chat_cubit.dart';
import 'feature/chat/repository/chat_repository_impl.dart';
import 'feature/post/create_post/cubit/create_post_cubit.dart';
import 'feature/story/create_story/cubit/create_story_cubit.dart';
import 'feature/main/analytics/repository/analytics_repository_impl.dart';
import 'feature/main/feed/repository/feed_repository_impl.dart';
import 'feature/main/inbox/repository/inbox_repository_impl.dart';
import 'feature/location/repository/location_repository_impl.dart';
import 'feature/main/navigation/cubit/navigation_cubit.dart';
import 'feature/main/analytics/cubit/analytics_cubit.dart';
import 'feature/notifications/new_followers/repository/new_followers_repository_impl.dart';
import 'feature/post/post_detail/repository/post_detail_repository_impl.dart';
import 'feature/search/repository/search_repository_impl.dart';
import 'feature/settings/repository/settings_repository_impl.dart';
import 'feature/story/story_view/cubit/story_view_cubit.dart';

class RightFlair extends StatelessWidget {
  const RightFlair({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(AuthenticationRepositoryImpl())),
        BlocProvider(create: (_) => ChooseUsernameCubit(ChooseUsernameRepositoryImpl())),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => FeedBloc(FeedRepositoryImpl())),
        BlocProvider(create: (_) => AnalyticsCubit(AnalyticsRepositoryImpl())),
        BlocProvider(create: (_) => InboxCubit(InboxRepositoryImpl())),
        BlocProvider(create: (_) => ProfileCubit(ProfileRepositoryImpl())),
        BlocProvider(create: (_) => ProfileEditCubit(ProfileEditRepositoryImpl())),
        BlocProvider(create: (_) => UserCubit(UserRepositoryImpl())),
        BlocProvider(create: (_) => PostDetailCubit(PostDetailRepositoryImpl())),
        BlocProvider(create: (_) => SettingsCubit(SettingsRepositoryImpl())),
        BlocProvider(create: (_) => CreatePostCubit(CreatePostRepositoryImpl())),
        BlocProvider(create: (_) => LocationCubit(LocationRepositoryImpl())),
        BlocProvider(create: (_) => CommentsCubit(CommentsRepositoryImpl())),
        BlocProvider(create: (_) => ChatCubit(ChatRepositoryImpl())),
        BlocProvider(create: (_) => CreateStoryCubit(CreateStoryRepositoryImpl())),
        BlocProvider(create: (_) => StoryViewCubit(StoryViewRepositoryImpl())),
        BlocProvider(create: (_) => SearchCubit(SearchRepositoryImpl())),
        BlocProvider(create: (_) => NewFollowersCubit(NewFollowersRepositoryImpl())),
      ],
      child: MaterialApp.router(
        title: AppConstants.APP_NAME,
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
