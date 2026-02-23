import 'package:flutter/material.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';
import '../model/story_filter.dart';

class StoryFilterList extends StatelessWidget {
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;

  const StoryFilterList({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = StoryFilter.filters;
    return SizedBox(
      height: context.height * .076,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.width * .04),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = index == selectedFilterIndex;
          return GestureDetector(
            onTap: () => onFilterSelected(index),
            child: Container(
              width: context.width * .13,
              margin: EdgeInsets.symmetric(horizontal: context.width * .015),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.width * .11,
                    height: context.width * .11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.WHITE
                            : AppColors.WHITE_30,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: ColorFiltered(
                        colorFilter: filter.colorMatrix != null
                            ? ColorFilter.matrix(filter.colorMatrix!)
                            : const ColorFilter.mode(
                                AppColors.TRANSPARENT,
                                BlendMode.multiply,
                              ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pink.shade200,
                                Colors.orange.shade200,
                                Colors.blue.shade200,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * .005),
                  TextComponent(
                    text: filter.name,
                    tr: false,
                    size: const [9],
                    color: isSelected ? AppColors.WHITE : AppColors.WHITE_54,
                    weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                    maxLine: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
