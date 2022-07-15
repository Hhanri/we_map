part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const SignUpState({required this.isLoading, this.errorMessage});
}

class SignUpInitial extends SignUpState {
  const SignUpInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
