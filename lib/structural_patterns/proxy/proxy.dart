// Общий интерфейс для реального объекта и прокси
abstract class FileAccess {
  void readFile(String fileName);
  void writeFile(String fileName, String content);
}

// Реальный объект
class RealFileAccess implements FileAccess {
  @override
  void readFile(String fileName) {
    print('Чтение файла: $fileName');
  }

  @override
  void writeFile(String fileName, String content) {
    print('Запись в файл $fileName: $content');
  }
}

// Прокси для контроля доступа
class FileAccessProxy implements FileAccess {
  final RealFileAccess _realFileAccess = RealFileAccess();
  final String _userRole;

  FileAccessProxy(this._userRole);

  bool _checkAccess(String operation) {
    switch (_userRole) {
      case 'admin':
        return true;
      case 'user':
        return operation == 'read';
      default:
        return false;
    }
  }

  @override
  void readFile(String fileName) {
    if (_checkAccess('read')) {
      print('Прокси: проверка доступа на чтение пройдена');
      _realFileAccess.readFile(fileName);
    } else {
      print('Прокси: отказано в доступе на чтение');
    }
  }

  @override
  void writeFile(String fileName, String content) {
    if (_checkAccess('write')) {
      print('Прокси: проверка доступа на запись пройдена');
      _realFileAccess.writeFile(fileName, content);
    } else {
      print('Прокси: отказано в доступе на запись');
    }
  }
}

void main() {
  // Создаём прокси для пользователя с ролью admin
  final adminProxy = FileAccessProxy('admin');
  print('Действия администратора:');
  adminProxy.readFile('data.txt');
  adminProxy.writeFile('data.txt', 'новые данные');

  print('\nДействия обычного пользователя:');
  // Создаём прокси для обычного пользователя
  final userProxy = FileAccessProxy('user');
  userProxy.readFile('data.txt'); // Разрешено
  userProxy.writeFile('data.txt', 'попытка записи'); // Запрещено

  print('\nДействия гостя:');
  // Создаём прокси для гостя
  final guestProxy = FileAccessProxy('guest');
  guestProxy.readFile('data.txt'); // Запрещено
  guestProxy.writeFile('data.txt', 'попытка записи'); // Запрещено
}
