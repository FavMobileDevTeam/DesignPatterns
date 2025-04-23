// Базовый класс пользователя
abstract class User {
  String name;
  List<String> chatHistory = [];
  List<User> contacts = [];

  User(this.name);

  void send(String message) {
    String formattedMessage = "${_getCurrentTime()} [$name]: $message";
    print("$name отправляет: $message");

    // Отправляем сообщение всем контактам
    for (var contact in contacts) {
      if (contact != this) {
        contact.receive(formattedMessage);
      }
    }
    // Сохраняем свою копию сообщения
    receive("$formattedMessage (отправлено вами)");
  }

  void sendPrivate(String message, User receiver) {
    String formattedMessage = "${_getCurrentTime()} [ЛИЧНОЕ от $name]: $message";
    print("$name отправляет личное сообщение для ${receiver.name}: $message");

    receiver.receivePrivate(formattedMessage, this);
    receivePrivate("$formattedMessage (отправлено вами)", receiver);
  }

  void receive(String message) {
    chatHistory.add(message);
    print("$name получает: $message");
  }

  void receivePrivate(String message, User sender) {
    chatHistory.add(message);
    print("$name получает личное сообщение: $message");
  }

  void addContact(User user) {
    if (!contacts.contains(user)) {
      contacts.add(user);
      user.contacts.add(this);

      String joinMessage = "${_getCurrentTime()} [СИСТЕМА] ${user.name} присоединился к чату";
      _broadcastSystemMessage(joinMessage);
    }
  }

  void removeContact(User user) {
    if (contacts.remove(user)) {
      user.contacts.remove(this);

      String leaveMessage = "${_getCurrentTime()} [СИСТЕМА] ${user.name} покинул чат";
      _broadcastSystemMessage(leaveMessage);
    }
  }

  void _broadcastSystemMessage(String message) {
    for (var contact in contacts) {
      contact.receive(message);
    }
    receive(message);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute}:${now.second}";
  }

  void printChatHistory() {
    print("\n===== Журнал сообщений $name =====");
    for (String message in chatHistory) {
      print(message);
    }
    print("============================");
  }
}

// Обычный пользователь
class ChatUser extends User {
  ChatUser(String name) : super(name);
}

// Премиум пользователь
class PremiumUser extends ChatUser {
  bool _invisibleMode = false;

  PremiumUser(String name) : super(name);

  void toggleInvisibleMode() {
    _invisibleMode = !_invisibleMode;
    print("$name ${_invisibleMode ? "включил" : "выключил"} режим невидимки");
  }

  @override
  void send(String message) {
    if (_invisibleMode) {
      message = "[Анонимно] $message";
    }
    super.send(message);
  }
}

// Демонстрация работы
void main() {
  // Создаем пользователей
  final alice = ChatUser("Алиса");
  final bob = ChatUser("Боб");
  final charlie = PremiumUser("Чарли");

  // Добавляем пользователей в контакты друг друга
  alice.addContact(bob);
  alice.addContact(charlie);
  bob.addContact(charlie);

  // Демонстрация обмена сообщениями
  alice.send("Привет всем!");
  bob.send("Привет, Алиса!");

  // Приватные сообщения
  alice.sendPrivate("Как дела, Боб?", bob);
  bob.sendPrivate("Все хорошо, спасибо!", alice);

  // Демонстрация премиум-функционала
  charlie.toggleInvisibleMode();
  charlie.send("Никто не знает, кто это написал :)");

  // Пользователь покидает чат
  bob.removeContact(alice);
  bob.removeContact(charlie);

  // Еще несколько сообщений
  alice.send("Боб покинул нас :(");
  charlie.send("Остались только мы!");

  // Вывод истории сообщений для каждого пользователя
  alice.printChatHistory();
  bob.printChatHistory();
  charlie.printChatHistory();
}
