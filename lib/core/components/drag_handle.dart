import 'package:flutter/material.dart';

class DragHandleComponent extends StatelessWidget {
  const DragHandleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}