import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/base/base_scaffold.dart';
import 'package:rightflair/core/constants/image.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';

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

    // Fade-in animation (only once at the beginning)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Up and down movement animation (continuously repeating)
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _moveAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
    );

    // Start fade-in first, then start movement animation when it finishes
    _fadeController.forward().then((_) {
      _moveController.repeat(reverse: true);
    });

    // Authentication check and navigation
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a bit for the animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Firebase Auth check
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to main screen
      context.go(RouteConstants.NAVIGATION);
    } else {
      // User is not logged in, navigate to register screen
      context.go(RouteConstants.REGISTER);
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
