part of 'create_story_cubit.dart';

class CreateStoryState extends Equatable {
  final bool? isLoading;
  const CreateStoryState({required this.isLoading});

  CreateStoryState copyWith({bool? isLoading}) {
    return CreateStoryState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [isLoading ?? false];
}
