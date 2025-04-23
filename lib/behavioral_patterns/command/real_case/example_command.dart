import 'dart:ui';

abstract class Command {
  void execute();
  void undo();
}

// Класс, представляющий точку на холсте
class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

// Команда для добавления линии на холст
class AddLineCommand implements Command {
  final List<DrawingPoint> canvasPoints;
  final List<DrawingPoint> linePoints;

  AddLineCommand(this.canvasPoints, this.linePoints);

  @override
  void execute() {
    canvasPoints.addAll(linePoints);
  }

  @override
  void undo() {
    if (linePoints.isNotEmpty) {
      canvasPoints.removeRange(canvasPoints.length - linePoints.length, canvasPoints.length);
    }
  }
}

// Команда для очистки холста
class ClearCanvasCommand implements Command {
  final List<DrawingPoint> canvasPoints;
  late List<DrawingPoint> _backup;

  ClearCanvasCommand(this.canvasPoints) {
    _backup = List.from(canvasPoints);
  }

  @override
  void execute() {
    _backup = List.from(canvasPoints);
    canvasPoints.clear();
  }

  @override
  void undo() {
    canvasPoints.addAll(_backup);
  }
}

// Класс для управления историей команд
class CommandHistory {
  final List<Command> _commands = [];
  int _currentIndex = -1;

  void execute(Command command) {
    // Удаляем все команды после текущего индекса
    if (_currentIndex < _commands.length - 1) {
      _commands.removeRange(_currentIndex + 1, _commands.length);
    }

    _commands.add(command);
    command.execute();
    _currentIndex++;
  }

  bool canUndo() => _currentIndex >= 0;
  bool canRedo() => _currentIndex < _commands.length - 1;

  void undo() {
    if (canUndo()) {
      _commands[_currentIndex].undo();
      _currentIndex--;
    }
  }

  void redo() {
    if (canRedo()) {
      _currentIndex++;
      _commands[_currentIndex].execute();
    }
  }
}
