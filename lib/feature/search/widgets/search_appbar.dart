import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/components/appbar.dart';

import '../../../core/components/button/back_button.dart';
import '../../../core/constants/string.dart';
import '../cubit/search_cubit.dart';
import 'search_text_field.dart';

class SearchAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const SearchAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      title: _search(context),
    );
  }

  SearchTextField _search(BuildContext context) {
    return SearchTextField(
      controller: context.read<SearchCubit>().searchController,
      focusNode: context.read<SearchCubit>().searchFocusNode,
      hintText: AppStrings.SEARCH_PLACEHOLDER,
      onSubmitted: (query) {
        if (query.trim().length >= 2) {
          context.read<SearchCubit>().search(query);
        }
      },
    );
  }
}
