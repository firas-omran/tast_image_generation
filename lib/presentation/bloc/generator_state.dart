import 'package:equatable/equatable.dart';

enum GeneratorStatus { initial, loading, success, failure }

class GeneratorState extends Equatable {
  final String prompt;
  final String? imagePath;
  final GeneratorStatus status;
  final String? errorMessage;

  const GeneratorState({
    this.prompt = '',
    this.imagePath,
    this.status = GeneratorStatus.initial,
    this.errorMessage,
  });

  GeneratorState copyWith({
    String? prompt,
    String? imagePath,
    GeneratorStatus? status,
    String? errorMessage,
  }) {
    return GeneratorState(
      prompt: prompt ?? this.prompt,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [prompt, imagePath, status, errorMessage];
}
