part of 'topic_form_cubit.dart';

@immutable
abstract class TopicFormState extends Equatable{
  final bool isLoading;
  final String? errorMessage;

  const TopicFormState({required this.isLoading, this.errorMessage});
}

class TopicFormInitial extends TopicFormState {
  const TopicFormInitial({required super.isLoading, super.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}
