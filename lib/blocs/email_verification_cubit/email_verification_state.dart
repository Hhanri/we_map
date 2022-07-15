part of 'email_verification_cubit.dart';

@immutable
abstract class EmailVerificationState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const EmailVerificationState({required this.isLoading, this.errorMessage});
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
