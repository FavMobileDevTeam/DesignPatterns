import 'package:flutter/material.dart';

// Класс Memento (Снимок), который хранит состояние редактора
class EditorMemento {
  final String text;
  final TextSelection selection;
  final DateTime timestamp;

  EditorMemento({
    required this.text,
    required this.selection,
    required this.timestamp,
  });
}

// Класс Originator (Создатель), представляющий редактор текста
class TextEditor {
  String _text;
  TextSelection _selection;
  final TextEditingController _controller;

  TextEditor()
      : _text = '',
        _selection = const TextSelection.collapsed(offset: 0),
        _controller = TextEditingController();

  String get text => _text;
  TextSelection get selection => _selection;
  TextEditingController get controller => _controller;

  // Обновляет состояние редактора
  void updateState(String newText, TextSelection newSelection) {
    _text = newText;
    _selection = newSelection;

    // Синхронизируем состояние с контроллером
    _controller.value = TextEditingValue(
      text: _text,
      selection: _selection,
    );
  }

  // Создает снимок текущего состояния
  EditorMemento createSnapshot() {
    return EditorMemento(
      text: _text,
      selection: _selection,
      timestamp: DateTime.now(),
    );
  }

  // Восстанавливает состояние из снимка
  void restoreFromSnapshot(EditorMemento memento) {
    _text = memento.text;
    _selection = memento.selection;

    // Синхронизируем состояние с контроллером
    _controller.value = TextEditingValue(
      text: _text,
      selection: _selection,
    );
  }
}

// Класс Caretaker (Опекун), управляющий историей снимков
class HistoryManager {
  final List<EditorMemento> _history = [];
  int _currentIndex = -1;
  final int _maxHistorySize = 100;

  // Сохраняет состояние редактора
  void saveState(TextEditor editor) {
    // Удаляем все снимки после текущего индекса (если мы делали undo и создаем новое состояние)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Добавляем новый снимок
    _history.add(editor.createSnapshot());
    _currentIndex++;

    // Очищаем старые снимки, если достигли максимального размера истории
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _currentIndex--;
    }
  }

  // Отменяет последнее действие (Undo)
  bool undo(TextEditor editor) {
    if (_currentIndex > 0) {
      _currentIndex--;
      editor.restoreFromSnapshot(_history[_currentIndex]);
      return true;
    }
    return false;
  }

  // Повторяет отмененное действие (Redo)
  bool redo(TextEditor editor) {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      editor.restoreFromSnapshot(_history[_currentIndex]);
      return true;
    }
    return false;
  }

  // Получает информацию о доступности undo/redo
  bool get canUndo => _currentIndex > 0;
  bool get canRedo => _currentIndex < _history.length - 1;

  // Очищает историю
  void clear() {
    _history.clear();
    _currentIndex = -1;
  }
}

// Основной виджет текстового редактора с историей
class TextEditorWithHistory extends StatefulWidget {
  const TextEditorWithHistory({super.key});

  @override
  State<TextEditorWithHistory> createState() => _TextEditorWithHistoryState();
}

class _TextEditorWithHistoryState extends State<TextEditorWithHistory> {
  final TextEditor _editor = TextEditor();
  final HistoryManager _historyManager = HistoryManager();
  bool _textChangeFromUser = true;

  @override
  void initState() {
    super.initState();

    // Сохраняем начальное пустое состояние
    _historyManager.saveState(_editor);

    // Слушаем изменения в текстовом поле
    _editor.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _editor.controller.removeListener(_handleTextChange);
    _editor.controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    // Игнорируем изменения, вызванные восстановлением из снимка
    if (!_textChangeFromUser) return;

    // Обновляем состояние редактора
    _editor.updateState(
      _editor.controller.text,
      _editor.controller.selection,
    );

    // Сохраняем новое состояние в историю
    // В реальном приложении можно использовать debounce для снижения количества сохранений
    _historyManager.saveState(_editor);

    // Обновляем UI для отражения доступности undo/redo
    setState(() {});
  }

  void _handleUndo() {
    if (_historyManager.canUndo) {
      setState(() {
        _textChangeFromUser = false;
        _historyManager.undo(_editor);
        _textChangeFromUser = true;
      });
    }
  }

  void _handleRedo() {
    if (_historyManager.canRedo) {
      setState(() {
        _textChangeFromUser = false;
        _historyManager.redo(_editor);
        _textChangeFromUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактор с историей'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _historyManager.canUndo ? _handleUndo : null,
            tooltip: 'Отменить',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _historyManager.canRedo ? _handleRedo : null,
            tooltip: 'Повторить',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 60,
          child: TextField(
            controller: _editor.controller,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              hintText: 'Начните вводить текст...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

// Главный класс приложения
class MementoPatternApp extends StatelessWidget {
  const MementoPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Пример паттерна Снимок',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TextEditorWithHistory(),
    );
  }
}

void main() {
  runApp(const MementoPatternApp());
}
