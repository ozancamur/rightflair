import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/auth/presentation/login_page.dart';
import 'package:rightflair/feature/auth/presentation/welcome_page.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteConstants.WELCOME,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteConstants.WELCOME,
      name: RouteConstants.WELCOME,
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: RouteConstants.LOGIN,
      name: RouteConstants.LOGIN,
      builder: (context, state) => const LoginPage(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.matchedLocation}')),
  ),
);
