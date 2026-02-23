import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';
import '../../model/camera_filter.dart';

class CameraFilterList extends StatelessWidget {
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;

  const CameraFilterList({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = CameraFilter.filters;
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = index == selectedFilterIndex;
          return GestureDetector(
            onTap: () => onFilterSelected(index),
            child: Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
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
                  const SizedBox(height: 4),
                  Text(
                    filter.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.WHITE : AppColors.WHITE_54,
                      fontSize: 9,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
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
