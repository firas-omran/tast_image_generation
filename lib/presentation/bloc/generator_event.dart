import 'package:equatable/equatable.dart';

abstract class GeneratorEvent extends Equatable {
  const GeneratorEvent();
  @override
  List<Object?> get props => [];
}

class PromptChanged extends GeneratorEvent {
  final String prompt;
  const PromptChanged(this.prompt);
  @override
  List<Object?> get props => [prompt];
}

class GenerateRequested extends GeneratorEvent {
  final bool fresh;
  const GenerateRequested({this.fresh = false});
}

class RetryRequested extends GeneratorEvent {
  const RetryRequested();
}
