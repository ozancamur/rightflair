import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/button/back_button.dart';
import 'package:rightflair/core/components/post/post.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/utils/dialogs/error.dart';
import 'package:rightflair/feature/search/cubit/search_cubit.dart';
import 'package:rightflair/feature/search/repository/search_repository_impl.dart';
import 'package:rightflair/feature/search/widgets/recent_search_chip.dart';
import 'package:rightflair/feature/search/widgets/search_text_field.dart';

import '../../../core/base/page/base_scaffold.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(SearchRepositoryImpl()),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final cubit = context.read<SearchCubit>();
      final query = cubit.searchController.text;
      if (query.isNotEmpty) {
        cubit.loadMore(query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          dialogError(
            context,
            message: state.errorMessage!,
            title: 'Search Error',
          );
        }
      },
      child: BaseScaffold(
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
                Expanded(child: _content(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.searchResults.isNotEmpty) {
          return _searchResults(context, state);
        } else if (state.isLoading && state.searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return _errorWidget(context, state.errorMessage!);
        } else {
          return _recentSearches(context);
        }
      },
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

  Widget _searchResults(BuildContext context, SearchState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.searchResults.length + (state.hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.searchResults.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: context.height * 0.02),
          child: PostComponent(
            post: state.searchResults[index],
            onComment: () {
              // TODO: Navigate to post detail page
            },
            onSave: () {
              // TODO: Implement save post
            },
            onShare: () {
              // TODO: Implement share post
            },
          ),
        );
      },
    );
  }

  Widget _errorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colors.error),
          SizedBox(height: context.height * 0.02),
          TextComponent(
            text: message,
            color: context.colors.error,
            size: FontSizeConstants.NORMAL,
            align: TextAlign.center,
          ),
        ],
      ),
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
