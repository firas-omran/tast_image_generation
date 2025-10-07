import 'dart:math';
import 'dart:async';

class MockImageRepository {
  // Генератор случайных чисел
  final _random = Random();

  // Список изображений для имитации
  final _images = [
    'assets/images/img1.jpeg',
    'assets/images/img2.jpeg',
    'assets/images/img3.jpeg',
  ];

  // Метод для "генерации" изображения на основе текстового запроса
  Future<String> generate(String prompt) async {
    // Имитация задержки генерации (2-3 секунды)
    await Future.delayed(Duration(seconds: 2 + _random.nextInt(2)));

    // 20% вероятность ошибки генерации
    if (_random.nextDouble() < 0.5) {
      throw Exception("Mock generation failed"); // Генерация не удалась
    }

    // Выбираем случайное изображение из списка
    return _images[_random.nextInt(_images.length)];
  }
}
