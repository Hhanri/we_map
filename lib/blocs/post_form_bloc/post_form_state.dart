part of 'post_form_bloc.dart';

@immutable
abstract class PostFormState {
  final bool isLoading;
  final String? errorMessage;

  const PostFormState({required this.isLoading, this.errorMessage});
}

class PostFormInitial extends PostFormState {
  final List<XFile> images;
  const PostFormInitial({required super.isLoading, super.errorMessage, required this.images});
}
