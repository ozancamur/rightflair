import 'package:flutter/material.dart';

import '../../../../../core/extensions/context.dart';

class FeedAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      backgroundColor: context.colors.secondary,
      foregroundColor: context.colors.primary,
      toolbarHeight: context.height * .05,
      elevation: 0,
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: context.height * .045,
            width: context.height * .045,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
