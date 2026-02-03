part of 'analytics_cubit.dart';

class AnalyticsState extends Equatable {
  final bool isLoading;
  final AnalyticsModel? data;
  final DateRange selectedDateRange;
  const AnalyticsState({
    this.isLoading = false,
    required this.data,
    this.selectedDateRange = DateRange.last7Days,
  });

  AnalyticsState copyWith({
    bool? isLoading,
    AnalyticsModel? data,
    DateRange? selectedDateRange,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    data ?? AnalyticsModel(),
    selectedDateRange,
  ];
}
