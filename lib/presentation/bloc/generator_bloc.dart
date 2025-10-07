import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import 'generator_event.dart';
import 'generator_state.dart';

class GeneratorBloc extends Bloc<GeneratorEvent, GeneratorState> {
  final GenerateImageUseCase useCase;
  GeneratorBloc({required this.useCase}) : super(const GeneratorState()) {
    on<PromptChanged>((event, emit) {
      emit(state.copyWith(prompt: event.prompt));
    });

    on<GenerateRequested>((event, emit) async {
      emit(state.copyWith(status: GeneratorStatus.loading, errorMessage: null));
      try {
        final image = await useCase(state.prompt);
        emit(state.copyWith(
          status: GeneratorStatus.success,
          imagePath: image,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: GeneratorStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });

    on<RetryRequested>((event, emit) {
      add(const GenerateRequested(fresh: true));
    });
  }
}
