part of 'archive_form_bloc.dart';

@immutable
abstract class ArchiveFormState {
  final bool isLoading;
  final String? errorMessage;

  const ArchiveFormState({required this.isLoading, this.errorMessage});
}

class ArchiveFormInitial extends ArchiveFormState {
  final List<XFile> images;
  const ArchiveFormInitial({required super.isLoading, super.errorMessage, required this.images});
}
