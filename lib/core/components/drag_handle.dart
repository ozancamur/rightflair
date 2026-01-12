import 'package:flutter/material.dart';

import '../constants/dark_color.dart';
import '../extensions/context.dart';

class DragHandleComponent extends StatelessWidget {
  const DragHandleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: context.height * 0.01,
        bottom: context.height * 0.005,
      ),
      width: context.width * 0.1,
      height: context.height * 0.005,
      decoration: BoxDecoration(
        color: AppDarkColors.WHITE32,
        borderRadius: BorderRadius.circular(context.width * 0.005),
      ),
    );
  }
}