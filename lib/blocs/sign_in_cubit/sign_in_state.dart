part of 'sign_in_cubit.dart';


@immutable
abstract class SignInState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const SignInState({required this.isLoading, this.errorMessage});
}

class SignInInitial extends SignInState {
  const SignInInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
