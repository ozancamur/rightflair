import 'package:flutter/material.dart';
import 'package:rightflair/core/utils/router.dart';

class RightFlair extends StatelessWidget {
  const RightFlair({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RightFlair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
