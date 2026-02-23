import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/context.dart';
import '../cubit/find_friends_cubit.dart';
import 'find_friends_search_field.dart';

class FindFriendsSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final Function()? onClear;
  const FindFriendsSearchWidget({
    super.key,
    required this.controller,
    required this.isSearching,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.01,
      ),
      child: FindFriendsSearchField(
        controller: controller,
        showClear: isSearching,
        onClear: onClear,
        onChanged: (value) => context.read<FindFriendsCubit>().search(value),
      ),
    );
  }
}
