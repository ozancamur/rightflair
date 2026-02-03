import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../../../../../core/constants/string.dart';
import '../cubit/analytics_cubit.dart';
import '../widgets/analytics_engagement_chart.dart';
import '../widgets/analytics_grid.dart';
import '../widgets/analytics_title.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AnalyticsCubit>().fetchAnalytics();

    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: _appbar(state),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: state.isLoading
                ? LoadingComponent()
                : SingleChildScrollView(
                    child: Column(
                      spacing: context.height * 0.03,
                      children: [
                        AnalyticsGridWidget(data: state.data),
                        AnalyticsEngagementChartWidget(
                          data:
                              state.data?.engagementChart
                                  ?.map((e) => (e.value as double))
                                  .toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  AppBarComponent _appbar(AnalyticsState state) {
    return AppBarComponent(
      title: AppStrings.ANALYTICS_TITLE,
      actions: [DateRangeButton(selectedRange: state.selectedDateRange)],
    );
  }
}
