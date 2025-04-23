// Простая модель данных для книги
class Book {
  final String title;
  final String author;
  final int year;

  Book(this.title, this.author, this.year);

  @override
  String toString() => '$title ($year) by $author';
}

// Класс коллекция книг с собственным итератором
class BookCollection {
  // Внутренняя коллекция книг
  final List<Book> _books = [];

  // Добавление книги в коллекцию
  void addBook(Book book) {
    _books.add(book);
  }

  // Создание и возврат итератора для всех книг
  BookIterator createIterator() {
    return BookIterator(_books);
  }

  // Создание и возврат итератора только для книг определенного автора
  AuthorBookIterator createAuthorIterator(String author) {
    return AuthorBookIterator(_books, author);
  }
}

// Базовый интерфейс итератора
abstract class Iterator<T> {
  bool hasNext();
  T next();
}

// Конкретный итератор для всех книг
class BookIterator implements Iterator<Book> {
  final List<Book> _books;
  int _currentIndex = 0;

  BookIterator(this._books);

  @override
  bool hasNext() {
    return _currentIndex < _books.length;
  }

  @override
  Book next() {
    if (!hasNext()) {
      throw Exception("No more books!");
    }
    return _books[_currentIndex++];
  }
}

// Специализированный итератор для книг определенного автора
class AuthorBookIterator implements Iterator<Book> {
  final List<Book> _books;
  final String _author;
  int _currentIndex = 0;

  AuthorBookIterator(this._books, this._author);

  @override
  bool hasNext() {
    // Находим следующую книгу нужного автора
    while (_currentIndex < _books.length) {
      if (_books[_currentIndex].author == _author) {
        return true;
      }
      _currentIndex++;
    }
    return false;
  }

  @override
  Book next() {
    if (!hasNext()) {
      throw Exception("No more books by this author!");
    }
    return _books[_currentIndex++];
  }
}
