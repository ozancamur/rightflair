import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/enums/date_range.dart';
import '../../../../core/helpers/date.dart';
import '../model/engagement_chart.dart';
import 'analytics_title.dart';
import 'chart_painter.dart';

class AnalyticsEngagementChartWidget extends StatefulWidget {
  final DateRange selectedRange;
  final List<EngagementChartModel> data;
  final DateRange dateRange;

  const AnalyticsEngagementChartWidget({
    super.key,
    required this.data,
    required this.dateRange,
    required this.selectedRange,
  });

  @override
  State<AnalyticsEngagementChartWidget> createState() =>
      _AnalyticsEngagementChartWidgetState();
}

class _AnalyticsEngagementChartWidgetState
    extends State<AnalyticsEngagementChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnalyticsEngagementChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateRange != widget.dateRange ||
        oldWidget.data != widget.data) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<double> get _chartData =>
      widget.data.map((e) => e.value ?? 0.0).toList();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _animation.value)),
            child: Container(
              padding: EdgeInsets.all(context.width * 0.05),
              margin: EdgeInsets.symmetric(horizontal: context.width * 0.015),
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
                children: [
                  _title(context),
                  SizedBox(height: context.height * 0.02),
                  _graph(context),
                  SizedBox(height: context.height * 0.01),
                  _labelsRow(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextComponent(
          text: AppStrings.ANALYTICS_ENGAGEMENT_OVERVIEW,
          size: [context.width * 0.035],
          weight: FontWeight.w600,
          color: context.colors.primary,
        ),
        DateRangeButton(selectedRange: widget.selectedRange),
      ],
    );
  }

  Widget _graph(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: context.height * 0.2,
          width: double.infinity,
          margin: EdgeInsets.all(context.width * 0.025),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: context.colors.primaryFixedDim),
              bottom: BorderSide(color: context.colors.primaryFixedDim),
            ),
          ),
          child: CustomPaint(
            painter: ChartPainter(
              data: _chartData,
              lineColor: context.colors.scrim,
              fillColor: context.colors.scrim.withOpacity(0.1),
              gridColor: context.colors.primaryFixedDim,
              animationValue: _animation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _labelsRow(BuildContext context) {
    final labels = DateHelper.getLabels(
      data: widget.data,
      dateRange: widget.dateRange,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Row(
        key: ValueKey(widget.dateRange),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels
            .map(
              (label) => Expanded(
                child: Center(
                  child: TextComponent(
                    text: label,
                    size: [context.width * 0.025],
                    color: context.colors.tertiary,
                    tr: false,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
