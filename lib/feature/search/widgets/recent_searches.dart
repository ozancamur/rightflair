import 'package:flutter/widgets.dart';

import '../../../core/extensions/context.dart';
import 'recent_search_label.dart';
import 'recent_search_list.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String>? searches;
  const RecentSearchesWidget({super.key, this.searches});

  @override
  Widget build(BuildContext context) {
    return searches == null
        ? const SizedBox.shrink()
        : SizedBox(
            height: context.height * .1,
            width: context.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.height * 0.015,
              children: [
                const RecentSearchLabelWidget(),
                RecentSearchListWidget(searches: searches ?? []),
              ],
            ),
          );
  }
}
