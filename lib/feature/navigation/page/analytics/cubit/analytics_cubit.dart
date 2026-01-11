import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/analytics_model.dart';
import '../repository/analytics_repository.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsCubit(this._repository) : super(AnalyticsInitial());

  Future<void> fetchAnalytics() async {
    emit(AnalyticsLoading());
    try {
      final data = await _repository.getAnalytics();
      emit(AnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
