import 'package:flutter/material.dart';

// Стратегия для форматирования текста
abstract class TextFormattingStrategy {
  String format(String text);
}

// Конкретные стратегии форматирования
class UpperCaseStrategy implements TextFormattingStrategy {
  @override
  String format(String text) => text.toUpperCase();
}

class LowerCaseStrategy implements TextFormattingStrategy {
  @override
  String format(String text) => text.toLowerCase();
}

class CapitalizeStrategy implements TextFormattingStrategy {
  @override
  String format(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

// TextFormatter использует стратегию форматирования
class TextFormatter extends ChangeNotifier {
  TextFormattingStrategy _strategy;
  String _text = '';

  TextFormatter(this._strategy);

  String get text => _text;

  void setStrategy(TextFormattingStrategy strategy) {
    _strategy = strategy;
    _formatText();
  }

  void updateText(String newText) {
    _text = _strategy.format(newText);
    notifyListeners();
  }

  void _formatText() {
    _text = _strategy.format(_text);
    notifyListeners();
  }
}

void main() {
  runApp(const MaterialApp(
    home: TextFormattingDemo(),
  ));
}

// Пример использования в виджете
class TextFormattingDemo extends StatefulWidget {
  const TextFormattingDemo({super.key});

  @override
  State<TextFormattingDemo> createState() => _TextFormattingDemoState();
}

class _TextFormattingDemoState extends State<TextFormattingDemo> {
  final TextFormatter _formatter = TextFormatter(LowerCaseStrategy());
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formatter.addListener(() {
      _controller.text = _formatter.text;
    });
  }

  @override
  void dispose() {
    _formatter.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Formatting Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => _formatter.updateText(value),
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _formatter.setStrategy(LowerCaseStrategy()),
                  child: Text('lowercase'),
                ),
                ElevatedButton(
                  onPressed: () => _formatter.setStrategy(UpperCaseStrategy()),
                  child: Text('UPPERCASE'),
                ),
                ElevatedButton(
                  onPressed: () => _formatter.setStrategy(CapitalizeStrategy()),
                  child: Text('Capitalize'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
