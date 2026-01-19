import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

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
        backgroundColor: context.colors.secondary,
        appBar: appBar,
        body: body,
        bottomNavigationBar: navigation,
      ),
    );
  }
}
