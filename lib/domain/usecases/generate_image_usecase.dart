import '../../data/repositories/image_repository.dart';

class GenerateImageUseCase {
  final MockImageRepository repository;
  GenerateImageUseCase({required this.repository});

  Future<String> call(String prompt) async {
    return repository.generate(prompt);
  }
}
