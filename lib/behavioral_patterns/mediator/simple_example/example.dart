// Интерфейс посредника
abstract class ChatMediator {
  void sendMessage(String message, User sender);
  void sendPrivateMessage(String message, User sender, User receiver);
  void addUser(User user);
  void removeUser(User user);
}

// Абстрактный класс пользователя (коллеги)
abstract class User {
  ChatMediator mediator;
  String name;
  List<String> chatHistory = [];

  User(this.mediator, this.name);

  void send(String message);
  void sendPrivate(String message, User receiver);
  void receive(String message);
  void receivePrivate(String message, User sender);

  String getName() {
    return name;
  }

  List<String> getChatHistory() {
    return chatHistory;
  }

  void printChatHistory() {
    print("\n===== Журнал сообщений $name =====");
    for (String message in chatHistory) {
      print(message);
    }
    print("============================");
  }
}

// Конкретная реализация посредника
class ChatRoom implements ChatMediator {
  final List<User> _users = [];
  final _formatter = DateTime.now();

  @override
  void addUser(User user) {
    _users.add(user);
    String joinMessage = "${_getCurrentTime()} [СИСТЕМА] ${user.getName()} присоединился к чату";
    _broadcastSystemMessage(joinMessage);
  }

  @override
  void removeUser(User user) {
    _users.remove(user);
    String leaveMessage = "${_getCurrentTime()} [СИСТЕМА] ${user.getName()} покинул чат";
    _broadcastSystemMessage(leaveMessage);
  }

  @override
  void sendMessage(String message, User sender) {
    String formattedMessage = "${_getCurrentTime()} [${sender.getName()}]: $message";
    for (User user in _users) {
      // Отправляем сообщение всем пользователям, включая отправителя
      if (user != sender) {
        user.receive(formattedMessage);
      } else {
        // Отправитель получает свое сообщение с отметкой
        user.receive("$formattedMessage (отправлено вами)");
      }
    }
  }

  @override
  void sendPrivateMessage(String message, User sender, User receiver) {
    String formattedMessage = "${_getCurrentTime()} [ЛИЧНОЕ от ${sender.getName()}]: $message";
    for (User user in _users) {
      if (user == receiver) {
        user.receivePrivate(formattedMessage, sender);
        break;
      }
    }
    // Отправитель также сохраняет копию отправленного сообщения
    sender.receivePrivate("$formattedMessage (отправлено вами)", receiver);
  }

  void _broadcastSystemMessage(String message) {
    for (User user in _users) {
      user.receive(message);
    }
  }

  String _getCurrentTime() {
    return "${_formatter.hour}:${_formatter.minute}:${_formatter.second}";
  }
}

// Конкретная реализация пользователя
class ChatUser extends User {
  ChatUser(super.mediator, super.name);

  @override
  void send(String message) {
    print("$name отправляет: $message");
    mediator.sendMessage(message, this);
  }

  @override
  void sendPrivate(String message, User receiver) {
    print("$name отправляет личное сообщение для ${receiver.getName()}: $message");
    mediator.sendPrivateMessage(message, this, receiver);
  }

  @override
  void receive(String message) {
    chatHistory.add(message);
    print("$name получает: $message");
  }

  @override
  void receivePrivate(String message, User sender) {
    chatHistory.add(message);
    print("$name получает личное сообщение: $message");
  }
}

// Премиум-пользователь с дополнительными возможностями
class PremiumUser extends ChatUser {
  bool _invisibleMode = false;

  PremiumUser(ChatMediator mediator, String name) : super(mediator, name);

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
  // Создаем посредника - чат-комнату
  final chatRoom = ChatRoom();

  // Создаем пользователей
  final alice = ChatUser(chatRoom, "Алиса");
  final bob = ChatUser(chatRoom, "Боб");
  final charlie = PremiumUser(chatRoom, "Чарли");

  // Добавляем пользователей в чат
  chatRoom.addUser(alice);
  chatRoom.addUser(bob);
  chatRoom.addUser(charlie);

  // Демонстрация обмена сообщениями
  alice.send("Привет всем!");
  bob.send("Привет, Алиса!");

  // Приватные сообщения
  alice.sendPrivate("Как дела, Боб?", bob);
  bob.sendPrivate("Все хорошо, спасибо!", alice);

  // Демонстрация премиум-функционала
  (charlie).toggleInvisibleMode();
  charlie.send("Никто не знает, кто это написал :)");

  // Пользователь покидает чат
  chatRoom.removeUser(bob);

  // Еще несколько сообщений
  alice.send("Боб покинул нас :(");
  charlie.send("Остались только мы!");

  // Вывод истории сообщений для каждого пользователя
  alice.printChatHistory();
  bob.printChatHistory();
  charlie.printChatHistory();
}
