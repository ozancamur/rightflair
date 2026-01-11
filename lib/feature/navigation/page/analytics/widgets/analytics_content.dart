import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/extensions/context.dart';
import '../cubit/analytics_cubit.dart';
import 'analytics_engagement_chart.dart';
import 'analytics_grid.dart';

class AnalyticsContentWidget extends StatelessWidget {
  const AnalyticsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnalyticsError) {
            return Center(child: TextComponent(text: state.message, tr: false));
          } else if (state is AnalyticsLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AnalyticsGridWidget(data: state.data),
                  SizedBox(height: context.height * 0.03),
                  AnalyticsEngagementChartWidget(
                    data: state.data.engagementData,
                  ),
                  SizedBox(height: context.height * 0.1), // Bottom padding
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
