import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../../../../../core/components/text/appbar_title.dart';
import '../../../../../core/constants/string.dart';
import '../cubit/analytics_cubit.dart';
import '../widgets/analytics_engagement_chart.dart';
import '../widgets/analytics_grid.dart';
import '../widgets/analytics_title.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();
    if (!cubit.state.isLoading && cubit.state.data?.likes == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cubit.fetchAnalytics();
      });
    }

    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: _appbar(context, state),
          body: _body(context, state),
        );
      },
    );
  }

  AppBarComponent _appbar(BuildContext context, AnalyticsState state) {
    return AppBarComponent(
      title: AppbarTitleComponent(title: AppStrings.ANALYTICS_TITLE),
      centerTitle: true,
      actions: [DateRangeButton(selectedRange: state.selectedDateRange)],
    );
  }

  Padding _body(BuildContext context, AnalyticsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: state.isLoading
          ? LoadingComponent()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.height * 0.02),
                  AnalyticsGridWidget(data: state.data),
                  SizedBox(height: context.height * 0.03),
                  AnalyticsEngagementChartWidget(
                    data: state.data?.engagementChart ?? [],
                    dateRange: state.selectedDateRange,
                  ),
                ],
              ),
            ),
    );
  }
}
