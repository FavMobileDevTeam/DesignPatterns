// Интерфейс наблюдателя
abstract class Observer {
  void update(String news);
}

// Интерфейс издателя
abstract class Subject {
  void attach(Observer observer);
  void detach(Observer observer);
  void notifyObservers();
}

// Конкретный издатель - новостное агентство
class NewsAgency implements Subject {
  final List<Observer> _observers = [];
  String _news = '';

  String get news => _news;

  void setNews(String news) {
    _news = news;
    notifyObservers();
  }

  @override
  void attach(Observer observer) {
    _observers.add(observer);
  }

  @override
  void detach(Observer observer) {
    _observers.remove(observer);
  }

  @override
  void notifyObservers() {
    for (var observer in _observers) {
      observer.update(_news);
    }
  }
}

// Конкретный наблюдатель - новостной канал
class NewsChannel implements Observer {
  final String name;
  String _lastNews = '';

  NewsChannel(this.name);

  String get lastNews => _lastNews;

  @override
  void update(String news) {
    _lastNews = news;
  }
}
