import 'package:design_patterns/behavioral_patterns/mediator/simple_example/example.dart';

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
