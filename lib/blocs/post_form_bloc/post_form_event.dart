part of 'post_form_bloc.dart';

@immutable
abstract class PostFormEvent {}

class DeletePostEvent extends PostFormEvent {}

class AddPhotoEvent extends PostFormEvent {
  final ImageSource imageSource;

  AddPhotoEvent({required this.imageSource});
}

class AddPostEvent extends PostFormEvent {}