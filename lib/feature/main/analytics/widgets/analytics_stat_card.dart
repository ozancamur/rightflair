import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class AnalyticsStatCardWidget extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final int growth;

  const AnalyticsStatCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.onBackground,
        borderRadius: BorderRadius.circular(context.width * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: context.width * 0.05,
                colorFilter: ColorFilter.mode(
                  context.colors.primaryContainer,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.width * 0.02),
              TextComponent(
                text: title,
                size: [context.width * 0.035],
                color: context.colors.primaryContainer,
              ),
            ],
          ),
          TextComponent(
            text: value,
            size: [context.width * 0.07],
            weight: FontWeight.w600,
            color: context.colors.primaryContainer,
            tr: false,
          ),
          Row(
            children: [
              SvgPicture.asset(
                _getGrowthIcon(),
                height: context.width * 0.04,
                colorFilter: ColorFilter.mode(
                  _getGrowthColor(context),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.width * 0.01),
              TextComponent(
                text: _getGrowthText(),
                size: [context.width * 0.035],
                color: _getGrowthColor(context),
                tr: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGrowthIcon() {
    if (growth > 0) return AppIcons.ANALYTIC_UP;
    if (growth < 0) return AppIcons.ANALYTIC_DOWN;
    return AppIcons.ANALYTIC_EQUAL;
  }

  Color _getGrowthColor(BuildContext context) {
    if (growth > 0) return context.colors.inverseSurface;
    if (growth < 0) return context.colors.error;
    return context.colors.tertiary;
  }

  String _getGrowthText() {
    if (growth > 0) return '+$growth%';
    if (growth < 0) return '$growth%';
    return '0%';
  }
}
