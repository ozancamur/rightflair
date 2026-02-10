import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/base/page/base_scaffold.dart';
import 'package:rightflair/core/constants/image.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _moveController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _moveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _moveAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
    );

    _fadeController.forward().then((_) {
      _moveController.repeat(reverse: true);
    });

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      if (kDebugMode) {
        debugPrint("USER JWT TOKEN :> ${Supabase.instance.client.auth.currentSession?.accessToken}");
        debugPrint("USER ID :> ${user.id}");
      }
      context.go(RouteConstants.NAVIGATION);
    } else {
      context.go(RouteConstants.WELCOME);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedBuilder(
              animation: _moveAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _moveAnimation.value),
                  child: child,
                );
              },
              child: Image.asset(AppImages.LOGO),
            ),
          ),
        ),
      ),
    );
  }
}
