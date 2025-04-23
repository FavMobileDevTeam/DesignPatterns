import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor Pattern Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Интерфейс Посетителя
abstract class DocumentVisitor {
  void visitTextDocument(TextDocument document);
  void visitImageDocument(ImageDocument document);
  void visitTableDocument(TableDocument document);
}

// Интерфейс Элемента
abstract class Document {
  String name;
  String content;

  Document(this.name, this.content);

  void accept(DocumentVisitor visitor);
  Widget buildPreview();
}

// Конкретные Элементы
class TextDocument extends Document {
  TextDocument(super.name, super.content);

  @override
  void accept(DocumentVisitor visitor) {
    visitor.visitTextDocument(this);
  }

  @override
  Widget buildPreview() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

class ImageDocument extends Document {
  final String imageUrl; // В реальном приложении это мог бы быть URL или путь к файлу

  ImageDocument(super.name, this.imageUrl, super.content);

  @override
  void accept(DocumentVisitor visitor) {
    visitor.visitImageDocument(this);
  }

  @override
  Widget buildPreview() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(child: Icon(Icons.image, size: 40)),
          ),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

class TableDocument extends Document {
  final List<List<String>> rows;

  TableDocument(super.name, this.rows, super.content);

  @override
  void accept(DocumentVisitor visitor) {
    visitor.visitTableDocument(this);
  }

  @override
  Widget buildPreview() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: rows.map((row) {
                return TableRow(
                  children: row.map((cell) {
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(cell),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

// Конкретные Посетители
class JsonExportVisitor implements DocumentVisitor {
  String result = "";

  @override
  void visitTextDocument(TextDocument document) {
    Map<String, dynamic> json = {
      'type': 'text',
      'name': document.name,
      'content': document.content,
    };
    result += "${jsonEncode(json)}\n";
  }

  @override
  void visitImageDocument(ImageDocument document) {
    Map<String, dynamic> json = {
      'type': 'image',
      'name': document.name,
      'description': document.content,
      'url': document.imageUrl,
    };
    result += "${jsonEncode(json)}\n";
  }

  @override
  void visitTableDocument(TableDocument document) {
    Map<String, dynamic> json = {
      'type': 'table',
      'name': document.name,
      'description': document.content,
      'data': document.rows,
    };
    result += "${jsonEncode(json)}\n";
  }
}

class HtmlExportVisitor implements DocumentVisitor {
  String result = "<html><body>\n";

  @override
  void visitTextDocument(TextDocument document) {
    result += "<div class='text-document'>\n";
    result += "  <h2>${document.name}</h2>\n";
    result += "  <p>${document.content}</p>\n";
    result += "</div>\n";
  }

  @override
  void visitImageDocument(ImageDocument document) {
    result += "<div class='image-document'>\n";
    result += "  <h2>${document.name}</h2>\n";
    result += "  <img src='${document.imageUrl}' alt='${document.name}'>\n";
    result += "  <p>${document.content}</p>\n";
    result += "</div>\n";
  }

  @override
  void visitTableDocument(TableDocument document) {
    result += "<div class='table-document'>\n";
    result += "  <h2>${document.name}</h2>\n";
    result += "  <table border='1'>\n";

    for (var row in document.rows) {
      result += "    <tr>\n";
      for (var cell in row) {
        result += "      <td>$cell</td>\n";
      }
      result += "    </tr>\n";
    }

    result += "  </table>\n";
    result += "  <p>${document.content}</p>\n";
    result += "</div>\n";
  }

  String getHtml() {
    return "$result</body></html>";
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Document> documents = [
    TextDocument('Заметка о встрече',
        'Встреча назначена на вторник в 15:00. Обсудим новые требования проекта.'),
    ImageDocument('Диаграмма архитектуры', 'https://example.com/arch-diagram.png',
        'Высокоуровневая схема архитектуры нашего приложения.'),
    TableDocument(
        'Квартальный отчет',
        [
          ['Квартал', 'Доход', 'Расходы', 'Прибыль'],
          ['Q1', '\$100,000', '\$80,000', '\$20,000'],
          ['Q2', '\$120,000', '\$90,000', '\$30,000'],
          ['Q3', '\$150,000', '\$100,000', '\$50,000'],
        ],
        'Финансовые результаты за последние три квартала.'),
  ];

  void _exportAsJson() {
    final visitor = JsonExportVisitor();

    for (var document in documents) {
      document.accept(visitor);
    }

    _showExportResult('JSON Export', visitor.result);
  }

  void _exportAsHtml() {
    final visitor = HtmlExportVisitor();

    for (var document in documents) {
      document.accept(visitor);
    }

    _showExportResult('HTML Export', visitor.getHtml());
  }

  void _showExportResult(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(content, style: TextStyle(fontFamily: 'monospace')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Посетитель (Visitor) в Flutter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: documents.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return Card(
                  child: documents[index].buildPreview(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _exportAsJson,
                  child: Text('Экспорт в JSON'),
                ),
                ElevatedButton(
                  onPressed: _exportAsHtml,
                  child: Text('Экспорт в HTML'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
