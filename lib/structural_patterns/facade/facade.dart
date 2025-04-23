// Подсистема 1
class AudioPlayer {
  void turnOn() {
    print('Аудиоплеер включен');
  }

  void turnOff() {
    print('Аудиоплеер выключен');
  }

  void playAudio(String file) {
    print('Воспроизведение аудио: $file');
  }
}

// Подсистема 2
class Display {
  void turnOn() {
    print('Дисплей включен');
  }

  void turnOff() {
    print('Дисплей выключен');
  }

  void showImage(String file) {
    print('Отображение изображения: $file');
  }
}

// Подсистема 3
class HardDrive {
  String getAudioFile(String name) {
    return 'audio_$name.mp3';
  }

  String getImageFile(String name) {
    return 'image_$name.jpg';
  }
}

// Фасад
class MultimediaFacade {
  final AudioPlayer _audio = AudioPlayer();
  final Display _display = Display();
  final HardDrive _hardDrive = HardDrive();

  void playMultimedia(String name) {
    print('\nНачало воспроизведения мультимедиа...');
    _audio.turnOn();
    _display.turnOn();

    String audioFile = _hardDrive.getAudioFile(name);
    String imageFile = _hardDrive.getImageFile(name);

    _audio.playAudio(audioFile);
    _display.showImage(imageFile);
  }

  void stopMultimedia() {
    print('\nЗавершение воспроизведения мультимедиа...');
    _audio.turnOff();
    _display.turnOff();
  }
}

void main() {
  final facade = MultimediaFacade();

  // Использование фасада для простого управления сложной подсистемой
  facade.playMultimedia('song');
  facade.stopMultimedia();
}
