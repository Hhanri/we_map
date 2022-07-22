part of 'create_user_profile_cubit.dart';

@immutable
abstract class CreateUserProfileState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const CreateUserProfileState({required this.isLoading, this.errorMessage});
}

class CreateUserProfileInitial extends CreateUserProfileState {
  const CreateUserProfileInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
