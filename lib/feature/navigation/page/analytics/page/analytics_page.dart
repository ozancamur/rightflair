import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../cubit/analytics_cubit.dart';
import '../repository/analytics_repository.dart';
import '../widgets/analytics_content.dart';
import '../widgets/analytics_title.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AnalyticsCubit(AnalyticsRepository())..fetchAnalytics(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          child: Column(
            spacing: context.height * .05,
            children: [
              // Header
              const AnalyticsTitleWidget(),
              // Content
              const AnalyticsContentWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
