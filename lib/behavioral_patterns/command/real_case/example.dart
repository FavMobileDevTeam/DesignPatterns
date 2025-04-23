import 'package:design_patterns/behavioral_patterns/command/real_case/example_command.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рисовалка с паттерном Команда',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DrawingCanvas(),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<DrawingPoint> points = [];
  final CommandHistory commandHistory = CommandHistory();
  List<DrawingPoint> currentLine = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Рисовалка с отменой/повтором'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: commandHistory.canUndo()
                ? () {
                    setState(() {
                      commandHistory.undo();
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: commandHistory.canRedo()
                ? () {
                    setState(() {
                      commandHistory.redo();
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                commandHistory.execute(ClearCanvasCommand(points));
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              currentLine = [];
              final paint = Paint()
                ..color = selectedColor
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round;

              currentLine.add(DrawingPoint(
                offset: details.localPosition,
                paint: paint,
              ));
            },
            onPanUpdate: (details) {
              final paint = Paint()
                ..color = selectedColor
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round;

              setState(() {
                currentLine.add(DrawingPoint(
                  offset: details.localPosition,
                  paint: paint,
                ));
              });
            },
            onPanEnd: (_) {
              if (currentLine.isNotEmpty) {
                setState(() {
                  commandHistory.execute(AddLineCommand(points, List.from(currentLine)));
                  currentLine = [];
                });
              }
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(points: points, currentLine: currentLine),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: EdgeInsets.only(bottom: 16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildColorButton(Colors.black),
            _buildColorButton(Colors.red),
            _buildColorButton(Colors.blue),
            _buildColorButton(Colors.green),
            SizedBox(
              height: 16,
              child: Slider(
                value: strokeWidth,
                min: 1.0,
                max: 20.0,
                onChanged: (value) {
                  setState(() {
                    strokeWidth = value;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Класс для отрисовки линий на холсте
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final List<DrawingPoint> currentLine;

  DrawingPainter({required this.points, required this.currentLine});

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем сохраненные линии
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        points[i].offset,
        points[i + 1].offset,
        points[i].paint,
      );
    }

    // Рисуем текущую линию
    for (int i = 0; i < currentLine.length - 1; i++) {
      canvas.drawLine(
        currentLine[i].offset,
        currentLine[i + 1].offset,
        currentLine[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
