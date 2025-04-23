import 'package:design_patterns/behavioral_patterns/iterator/real_case/models.dart';
import 'package:flutter/material.dart';

// Пример использования
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простой пример паттерна Итератор',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookScreen(),
    );
  }
}

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookCollection _bookCollection = BookCollection();
  List<Book> _booksToShow = [];
  String _selectedAuthor = "Все авторы";
  late List<String> _authors;

  @override
  void initState() {
    super.initState();

    // Заполняем коллекцию книгами
    _bookCollection.addBook(Book("Война и мир", "Лев Толстой", 1869));
    _bookCollection.addBook(Book("Преступление и наказание", "Федор Достоевский", 1866));
    _bookCollection.addBook(Book("Анна Каренина", "Лев Толстой", 1877));
    _bookCollection.addBook(Book("Мастер и Маргарита", "Михаил Булгаков", 1967));
    _bookCollection.addBook(Book("Идиот", "Федор Достоевский", 1869));
    _bookCollection.addBook(Book("Воскресение", "Лев Толстой", 1899));

    // Получаем список авторов
    _authors = ["Все авторы"];
    BookIterator iterator = _bookCollection.createIterator();
    while (iterator.hasNext()) {
      Book book = iterator.next();
      if (!_authors.contains(book.author)) {
        _authors.add(book.author);
      }
    }

    // Изначально показываем все книги
    _showAllBooks();
  }

  void _showAllBooks() {
    _booksToShow = [];
    BookIterator iterator = _bookCollection.createIterator();
    while (iterator.hasNext()) {
      _booksToShow.add(iterator.next());
    }
  }

  void _showBooksByAuthor(String author) {
    _booksToShow = [];
    AuthorBookIterator iterator = _bookCollection.createAuthorIterator(author);
    while (iterator.hasNext()) {
      _booksToShow.add(iterator.next());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Библиотека книг'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedAuthor,
              isExpanded: true,
              items: _authors.map((String author) {
                return DropdownMenuItem<String>(
                  value: author,
                  child: Text(author),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAuthor = newValue!;
                  if (_selectedAuthor == "Все авторы") {
                    _showAllBooks();
                  } else {
                    _showBooksByAuthor(_selectedAuthor);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _booksToShow.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_booksToShow[index].title),
                  subtitle: Text('${_booksToShow[index].author}, ${_booksToShow[index].year}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
