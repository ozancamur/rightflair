import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class AnalyticsStatCardWidget extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final double growth;

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
        color: AppDarkColors.INACTIVE,
        borderRadius: BorderRadius.circular(context.width * 0.05),
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
                  AppDarkColors.WHITE75,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.width * 0.02),
              TextComponent(
                text: title,
                size: [context.width * 0.035],
                color: AppDarkColors.WHITE75,
              ),
            ],
          ),
          TextComponent(
            text: value,
            size: [context.width * 0.07],
            weight: FontWeight.w600,
            tr: false,
          ),
          Row(
            children: [
              SvgPicture.asset(
                growth >= 0 ? AppIcons.ANALYTIC_UP : AppIcons.ANALYTIC_DOWN,
                height: context.width * 0.04,
                colorFilter: ColorFilter.mode(
                  growth >= 0 ? AppDarkColors.GREEN : AppDarkColors.RED,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.width * 0.01),
              TextComponent(
                text: "${growth >= 0 ? '+' : ''}${growth}%",
                size: [context.width * 0.035],
                color: growth >= 0 ? AppDarkColors.GREEN : AppDarkColors.RED,
                tr: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
