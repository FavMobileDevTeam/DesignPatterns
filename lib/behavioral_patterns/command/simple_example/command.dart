import 'package:design_patterns/behavioral_patterns/command/simple_example/command_manager.dart';

abstract class Command {
  void execute();
  void undo();
}

class InsertCommand implements Command {
  final TextEditor editor;
  final String text;

  InsertCommand(this.editor, this.text);

  @override
  void execute() => editor.insert(text);

  @override
  void undo() => editor.delete(text.length);
}
