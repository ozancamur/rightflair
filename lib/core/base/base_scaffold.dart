import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';

class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? navigation;
  const BaseScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppDarkColors.SECONDARY,
        appBar: appBar,
        body: body,
        bottomNavigationBar: navigation,
      ),
    );
  }
}
