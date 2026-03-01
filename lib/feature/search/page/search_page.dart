import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/search/cubit/search_cubit.dart';
import 'package:rightflair/feature/search/repository/search_repository_impl.dart';
import 'package:rightflair/feature/search/widgets/search_appbar.dart';
import 'package:rightflair/feature/search/widgets/search_list.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BaseScaffold(
            canPop: true,
            resizeToAvoidBottomInset: false,
            appBar: SearchAppBarWidget(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.height * 0.02),
                  state.recentSearches.length == 0
                      ? SizedBox.shrink()
                      : RecentSearchesWidget(searches: state.recentSearches),
                  Expanded(child: _content(context, state)),
                  SizedBox(height: context.height * 0.03),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, SearchState state) {
    if (!state.hasSearched) return const SizedBox.shrink();
    if (state.isLoading) return const LoadingComponent();
    if (state.results.isEmpty) return const SearchErrorWidget();
    return const SearchListWidget();
  }
}
