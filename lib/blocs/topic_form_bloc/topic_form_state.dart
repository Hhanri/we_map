part of 'topic_form_bloc.dart';

@immutable
abstract class TopicFormState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  const TopicFormState({required this.isLoading, this.errorMessage});
}

class TopicFormViewState extends TopicFormState {
  const TopicFormViewState({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}

class TopicFormEditState extends TopicFormState {
  const TopicFormEditState({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}