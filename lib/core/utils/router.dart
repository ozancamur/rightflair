import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/authentication/presentation/pages/choose_username_page.dart';
import 'package:rightflair/feature/authentication/presentation/pages/forgot_password_page.dart';
import 'package:rightflair/feature/authentication/presentation/pages/login_page.dart';
import 'package:rightflair/feature/authentication/presentation/pages/welcome_page.dart';

import '../../feature/authentication/presentation/pages/register_page.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteConstants.CHOOSE_USERNAME,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteConstants.WELCOME,
      name: RouteConstants.WELCOME,
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: RouteConstants.REGISTER,
      name: RouteConstants.REGISTER,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteConstants.CHOOSE_USERNAME,
      name: RouteConstants.CHOOSE_USERNAME,
      builder: (context, state) => const ChooseUsernamePage(),
    ),
    GoRoute(
      path: RouteConstants.LOGIN,
      name: RouteConstants.LOGIN,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.FORGOT_PASSWORD,
      name: RouteConstants.FORGOT_PASSWORD,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.matchedLocation}')),
  ),
);
