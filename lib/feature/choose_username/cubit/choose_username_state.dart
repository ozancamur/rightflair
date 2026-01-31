part of 'choose_username_cubit.dart';

class ChooseUsernameState extends Equatable {
  final bool isLoading;
  final bool isUnique;
  final String? checkedUsername;
  const ChooseUsernameState({
    this.isLoading = false,
    this.isUnique = false,
    this.checkedUsername,
  });

  ChooseUsernameState copyWith({
    bool? isLoading,
    bool? isUnique,
    String? checkedUsername,
  }) {
    return ChooseUsernameState(
      isLoading: isLoading ?? this.isLoading,
      isUnique: isUnique ?? this.isUnique,
      checkedUsername: checkedUsername ?? this.checkedUsername,
    );
  }

  @override
  List<Object?> get props => [isLoading, isUnique, checkedUsername];
}
