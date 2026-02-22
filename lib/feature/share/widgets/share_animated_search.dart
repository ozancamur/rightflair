import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import 'share_user.dart';

class ShareAnimatedSearchWidget extends StatelessWidget {
  const ShareAnimatedSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (prev, curr) =>
          prev.isSearchOpen != curr.isSearchOpen ||
          prev.searchResults != curr.searchResults ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final slideAnimation =
                Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: state.isSearchOpen
              ? _SearchContent(key: const ValueKey('search'))
              : const SizedBox.shrink(key: ValueKey('empty')),
        );
      },
    );
  }
}

class _SearchContent extends StatelessWidget {
  const _SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareCubit>();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          child: Container(
            height: context.height * 0.05,
            decoration: BoxDecoration(
              color: context.colors.onSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: cubit.searchController,
              focusNode: cubit.searchFocusNode,
              style: TextStyle(
                color: context.colors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: context.colors.primary,
              onChanged: (query) => cubit.searchUsers(query),
              decoration: InputDecoration(
                fillColor: context.colors.onSecondary,
                filled: true,
                hintText: AppStrings.SEARCH_PLACEHOLDER.tr(),
                hintStyle: TextStyle(
                  color: context.colors.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: context.width * 0.04,
                    right: context.width * 0.035,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.SEARCH_FILLED,
                    width: context.width * 0.01,
                    height: context.width * 0.01,
                    colorFilter: ColorFilter.mode(
                      context.colors.primaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => cubit.closeSearch(),
                  child: Padding(
                    padding: EdgeInsets.all(context.width * 0.03),
                    child: SvgPicture.asset(
                      AppIcons.CLOSE,
                      width: context.width * 0.01,
                      height: context.width * 0.01,
                      colorFilter: ColorFilter.mode(
                        context.colors.primaryContainer,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.04,
                  vertical: context.height * 0.015,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.height * 0.01),
        BlocBuilder<ShareCubit, ShareState>(
          buildWhen: (prev, curr) =>
              prev.searchResults != curr.searchResults ||
              prev.isLoading != curr.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.03),
                child: SizedBox(
                  width: context.width * 0.05,
                  height: context.width * 0.05,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.primary,
                  ),
                ),
              );
            }

            if (state.searchResults.isEmpty) {
              if (cubit.searchController.text.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.03,
                  ),
                  child: Text(
                    AppStrings.SHARE_DIALOG_NO_USER.tr(),
                    style: TextStyle(
                      color: context.colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: context.height * 0.35),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: context.height * 0.005),
                itemCount: state.searchResults.length,
                itemBuilder: (context, index) {
                  final user = state.searchResults[index];
                  return ShareUserWidget(user: user);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
