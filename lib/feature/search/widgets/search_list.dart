import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../core/extensions/context.dart';
import '../cubit/search_cubit.dart';
import 'search_list_item.dart';

class SearchListWidget extends StatefulWidget {
  const SearchListWidget({super.key});

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<SearchListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: state.results.length + (state.isPaginating ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.results.length) {
              return LoadingComponent();
            }
            return SearchListItemWidget(user: state.results[index]);
          },
        );
      },
    );
  }
}
