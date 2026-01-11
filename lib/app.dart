import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/font_family.dart';
import 'package:rightflair/core/utils/router.dart';
import 'package:rightflair/feature/authentication/bloc/authentication_bloc.dart';
import 'package:rightflair/feature/choose_username/bloc/choose_username_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/bloc/feed_bloc.dart';

import 'feature/navigation/cubit/navigation_cubit.dart';
import 'feature/navigation/page/analytics/cubit/analytics_cubit.dart';
import 'feature/navigation/page/analytics/repository/analytics_repository.dart';

class RightFlair extends StatelessWidget {
  const RightFlair({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()),
        BlocProvider(create: (_) => ChooseUsernameBloc()),

        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => FeedBloc()),
        BlocProvider(create: (_) => AnalyticsCubit(AnalyticsRepository())),

      ],
      child: MaterialApp.router(
        title: 'RightFlair',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: ThemeData(
          fontFamily: FontFamilyConstants.POPPINS,
          useMaterial3: false,
        ),
        locale: context.locale,
        routerConfig: router,
      ),
    );
  }
}
