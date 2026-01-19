import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/search/cubit/search_cubit.dart';
import 'package:rightflair/feature/search/widgets/recent_search_chip.dart';
import 'package:rightflair/feature/search/widgets/search_text_field.dart';

import '../../../core/base/page/base_scaffold.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatelessWidget {
  const _SearchPageView();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.height * 0.01),
              _searchField(context),
              SizedBox(height: context.height * 0.03),
              _recentSearches(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    return Row(
      spacing: context.width * 0.03,
      children: [
        BackButtonComponent(),
        Expanded(
          child: SearchTextField(
            controller: context.read<SearchCubit>().searchController,
            focusNode: context.read<SearchCubit>().searchFocusNode,
            hintText: AppStrings.SEARCH_PLACEHOLDER,
            onSubmitted: (query) => context.read<SearchCubit>().search(query),
          ),
        ),
      ],
    );
  }

  Widget _recentSearches(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.recentSearches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.height * 0.015,
          children: [
            _recentSearchesLabel(context),
            _recentSearchesList(context, state.recentSearches),
          ],
        );
      },
    );
  }

  Widget _recentSearchesLabel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
      child: TextComponent(
        text: AppStrings.SEARCH_RECENT_SEARCHES,
        color: context.colors.primaryContainer,
        size: FontSizeConstants.SMALL,
        weight: FontWeight.w600,
        spacing: 0.5,
      ),
    );
  }

  Widget _recentSearchesList(BuildContext context, List<String> searches) {
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
