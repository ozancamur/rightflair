import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/auth/presentation/login_page.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteConstants.SPLASH,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteConstants.LOGIN,
      name: RouteConstants.LOGIN,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const LoginPage()),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.matchedLocation}')),
  ),
);
