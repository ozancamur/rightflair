import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/context.dart';
import '../cubit/search_cubit.dart';
import 'recent_search_chip.dart';

class RecentSearchListWidget extends StatelessWidget {
  final List<String> searches;
  const RecentSearchListWidget({super.key, required this.searches});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.width * 0.02,
      runSpacing: context.height * 0.01,
      children: searches.map((search) {
        return RecentSearchChip(
          label: search,
          onTap: () {
            context.read<SearchCubit>().searchController.text = search;
            context.read<SearchCubit>().search(search);
          },
          onDelete: () {
            context.read<SearchCubit>().removeRecentSearch(search);
          },
        );
      }).toList(),
    );
  }
}
