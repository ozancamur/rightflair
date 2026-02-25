import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/base/page/base_scaffold.dart';
import 'package:rightflair/core/constants/image.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/config.dart';
import '../../../core/services/deep_link.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _config();
  }

  Future<void> _config() async {
    await Config().init();
    DeepLinkService().initialize();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      if (kDebugMode) {
        debugPrint(
          "USER JWT TOKEN :> ${Supabase.instance.client.auth.currentSession?.accessToken}",
        );
        debugPrint("USER ID :> ${user.id}");
      }
      context.go(RouteConstants.NAVIGATION);
    } else {
      context.go(RouteConstants.WELCOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Image.asset(AppImages.SPLASH),
      ),
    );
  }
}
