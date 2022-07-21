part of 'new_archive_form_cubit.dart';

@immutable
abstract class NewArchiveFormState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const NewArchiveFormState({required this.isLoading, this.errorMessage});
}

class NewArchiveFormInitial extends NewArchiveFormState {
  const NewArchiveFormInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
