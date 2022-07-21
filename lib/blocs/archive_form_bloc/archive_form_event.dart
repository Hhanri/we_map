part of 'archive_form_bloc.dart';

@immutable
abstract class ArchiveFormEvent {}

class DeleteArchiveEvent extends ArchiveFormEvent {}

class AddPhotoEvent extends ArchiveFormEvent {
  final ImageSource imageSource;

  AddPhotoEvent({required this.imageSource});
}

class AddArchiveEvent extends ArchiveFormEvent {}