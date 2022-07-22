part of 'topic_form_bloc.dart';

@immutable
abstract class TopicFormEvent {}

class EditTopicEvent extends TopicFormEvent {
  final TopicFormState currentState;

  EditTopicEvent({required this.currentState});
}

class DeleteTopicEvent extends TopicFormEvent {}

class AddPostEvent extends TopicFormEvent {}

class DeletePostEvent extends TopicFormEvent {
  final PostModel post;
  DeletePostEvent({required this.post});
}

class EmitEditingState extends TopicFormEvent {
  final bool isLoading;
  final String? errorMessage;
  EmitEditingState({required this.isLoading, this.errorMessage});
}

class EmitViewingState extends TopicFormEvent {
  final bool isLoading;
  final String? errorMessage;

  EmitViewingState({required this.isLoading, this.errorMessage});
}