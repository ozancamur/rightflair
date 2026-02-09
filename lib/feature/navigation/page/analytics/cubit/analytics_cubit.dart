import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/analytics.dart';
import '../../../../../core/constants/enums/date_range.dart';
import '../repository/analytics_repository_impl.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  DateRange _selectedDateRange = DateRange.last7Days;

  final AnalyticsRepositoryImpl _repo;
  AnalyticsCubit(this._repo) : super(AnalyticsState(data: AnalyticsModel()));

  DateRange get selectedDateRange => _selectedDateRange;

  Future<void> fetchAnalytics({DateRange? dateRange}) async {
    if (dateRange != null) {
      _selectedDateRange = dateRange;
    }
    emit(state.copyWith(isLoading: true));
    try {
      final data = await _repo.getAnalytics(dateRange: _selectedDateRange);
      if (data != null) {
        emit(
          state.copyWith(
            isLoading: false,
            data: data,
            selectedDateRange: _selectedDateRange,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void changeDateRange(DateRange dateRange) {
    if (_selectedDateRange != dateRange) {
      fetchAnalytics(dateRange: dateRange);
    }
  }
}
