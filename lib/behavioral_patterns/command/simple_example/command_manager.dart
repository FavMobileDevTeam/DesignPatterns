import 'package:design_patterns/behavioral_patterns/command/simple_example/command.dart';

class CommandManager {
  final List<Command> _history = [];
  final List<Command> _redoStack = [];

  void run(Command command) {
    command.execute();
    _history.add(command);
    _redoStack.clear();
  }

  void undo() {
    if (_history.isNotEmpty) {
      final command = _history.removeLast();
      command.undo();
      _redoStack.add(command);
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      final command = _redoStack.removeLast();
      command.execute();
      _history.add(command);
    }
  }
}

class TextEditor {
  String _text = "";

  void insert(String value) {
    _text += value;
    print("Inserted: $value -> $_text");
  }

  void delete(int length) {
    _text = _text.substring(0, _text.length - length);
    print("Deleted $length chars -> $_text");
  }

  String get text => _text;
}
