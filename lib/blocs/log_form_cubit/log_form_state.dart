part of 'log_form_cubit.dart';

@immutable
abstract class LogFormState extends Equatable{
  final bool isLoading;
  final String? errorMessage;

  const LogFormState({required this.isLoading, this.errorMessage});
}

class LogFormInitial extends LogFormState {
  const LogFormInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
