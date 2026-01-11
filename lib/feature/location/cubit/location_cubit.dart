import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/location_repository_impl.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  Timer? _debounce;

  final LocationRepositoryImpl _repo;
  LocationCubit(this._repo) : super(LocationInitial());

  void searchLocation(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      emit(LocationInitial());
      return;
    } // wait 0.5s before calling API

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(LocationLoading());
      try {
        final locations = await _repo.searchCities(query);
        emit(LocationLoaded(locations));
      } catch (e) {
        emit(LocationError("Failed to fetch locations"));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
