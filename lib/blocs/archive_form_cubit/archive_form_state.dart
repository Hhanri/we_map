part of 'archive_form_cubit.dart';

@immutable
abstract class ArchiveFormState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const ArchiveFormState({required this.isLoading, this.errorMessage});
}

class ArchiveFormInitial extends ArchiveFormState {

  const ArchiveFormInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
