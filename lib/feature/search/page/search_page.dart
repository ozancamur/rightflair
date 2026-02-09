import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/utils/dialogs/error.dart';
import 'package:rightflair/feature/search/cubit/search_cubit.dart';
import 'package:rightflair/feature/search/repository/search_repository_impl.dart';
import 'package:rightflair/feature/search/widgets/search_appbar.dart';
import 'package:rightflair/feature/search/widgets/search_post_widget.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_error.dart';

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
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          dialogError(
            context,
            message: state.errorMessage!,
            title: AppStrings.ERROR_DEFAULT,
          );
        }
      },
      builder: (context, state) {
        return BaseScaffold(
          appBar: SearchAppBarWidget(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.height * 0.02),
                RecentSearchesWidget(searches: state.recentSearches),
                SizedBox(height: context.height * 0.02),
                Expanded(child: _content(context, state))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, SearchState state) {
    return state.searchResults.isNotEmpty
        ? _posts(context, state)
        : (state.isLoading && state.searchResults.isEmpty)
        ? LoadingComponent()
        : (state.errorMessage != null)
        ? SearchErrorWidget(
            message: state.errorMessage ?? AppStrings.ERROR_DEFAULT,
          )
        : const SizedBox.shrink();
  }

  Widget _posts(BuildContext context, SearchState state) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.width * 0.02,
        mainAxisSpacing: context.height * 0.02,
        childAspectRatio: 0.75,
      ),
      itemCount: state.searchResults.length + (state.hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.searchResults.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SearchPostWidget(post: state.searchResults[index]);
      },
    );
  }
}
