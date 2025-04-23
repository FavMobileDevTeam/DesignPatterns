// Iterator interface
abstract class MusicIterator {
  bool hasNext();
  Song? next();
  void reset();
}

// Class representing a musical composition
class Song {
  final String title;
  final String artist;
  final String genre;
  final int durationInSeconds;

  Song(this.title, this.artist, this.genre, this.durationInSeconds);

  @override
  String toString() {
    return '$artist - $title (${_formatDuration()})';
  }

  String _formatDuration() {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '$minutes:${seconds < 10 ? '0$seconds' : seconds}';
  }
}

// Collection interface
abstract class Playlist {
  void addSong(Song song);
  void removeSong(Song song);
  MusicIterator getRegularIterator();
  MusicIterator getShuffleIterator();
  MusicIterator getGenreIterator(String genre);
}

// Concrete playlist implementation
class MusicPlaylist implements Playlist {
  final List<Song> _songs = [];
  final String name;

  MusicPlaylist(this.name);

  @override
  void addSong(Song song) {
    _songs.add(song);
  }

  @override
  void removeSong(Song song) {
    _songs.remove(song);
  }

  @override
  MusicIterator getRegularIterator() {
    return RegularMusicIterator(_songs);
  }

  @override
  MusicIterator getShuffleIterator() {
    return ShuffleMusicIterator(_songs);
  }

  @override
  MusicIterator getGenreIterator(String genre) {
    return GenreMusicIterator(_songs, genre);
  }

  String getName() => name;

  int getTotalSongs() => _songs.length;
}

// Concrete iterator for sequential traversal
class RegularMusicIterator implements MusicIterator {
  final List<Song> _songs;
  int _currentPosition = 0;

  RegularMusicIterator(this._songs);

  @override
  bool hasNext() {
    return _currentPosition < _songs.length;
  }

  @override
  Song? next() {
    if (hasNext()) {
      return _songs[_currentPosition++];
    }
    return null;
  }

  @override
  void reset() {
    _currentPosition = 0;
  }
}

// Concrete iterator for random traversal
class ShuffleMusicIterator implements MusicIterator {
  final List<Song> _songs;
  late List<int> _shuffleIndices;
  int _currentPosition = 0;

  ShuffleMusicIterator(this._songs) {
    _generateShuffleIndices();
  }

  void _generateShuffleIndices() {
    _shuffleIndices = List.generate(_songs.length, (i) => i);
    _shuffleIndices.shuffle();
  }

  @override
  bool hasNext() {
    return _currentPosition < _shuffleIndices.length;
  }

  @override
  Song? next() {
    if (hasNext()) {
      int index = _shuffleIndices[_currentPosition++];
      return _songs[index];
    }
    return null;
  }

  @override
  void reset() {
    _currentPosition = 0;
    _generateShuffleIndices(); // Create new shuffle order
  }
}

// Concrete iterator for genre-based traversal
class GenreMusicIterator implements MusicIterator {
  final List<Song> _songs;
  final String _genre;
  int _currentPosition = 0;
  late List<int> _genreIndices;

  GenreMusicIterator(this._songs, this._genre) {
    _collectGenreIndices();
  }

  void _collectGenreIndices() {
    _genreIndices = [];
    for (int i = 0; i < _songs.length; i++) {
      if (_songs[i].genre.toLowerCase() == _genre.toLowerCase()) {
        _genreIndices.add(i);
      }
    }
  }

  @override
  bool hasNext() {
    return _currentPosition < _genreIndices.length;
  }

  @override
  Song? next() {
    if (hasNext()) {
      int index = _genreIndices[_currentPosition++];
      return _songs[index];
    }
    return null;
  }

  @override
  void reset() {
    _currentPosition = 0;
  }
}

// Demo
void main() {
  // Create playlist and add songs
  var myPlaylist = MusicPlaylist('My Playlist');

  myPlaylist.addSong(Song('Bohemian Rhapsody', 'Queen', 'Rock', 354));
  myPlaylist.addSong(Song('Billie Jean', 'Michael Jackson', 'Pop', 294));
  myPlaylist.addSong(Song('Nothing Else Matters', 'Metallica', 'Rock', 386));
  myPlaylist.addSong(Song('Shape of You', 'Ed Sheeran', 'Pop', 233));
  myPlaylist.addSong(Song('Master of Puppets', 'Metallica', 'Rock', 515));
  myPlaylist.addSong(Song('Bad Guy', 'Billie Eilish', 'Pop', 194));

  print('=== Playlist: ${myPlaylist.getName()} (${myPlaylist.getTotalSongs()} songs) ===\n');

  // Regular iterator demo
  print('--- Regular playback ---');
  var regularIterator = myPlaylist.getRegularIterator();
  while (regularIterator.hasNext()) {
    print(regularIterator.next());
  }

  // Shuffle iterator demo
  print('\n--- Shuffle playback ---');
  var shuffleIterator = myPlaylist.getShuffleIterator();
  while (shuffleIterator.hasNext()) {
    print(shuffleIterator.next());
  }

  // Second run of shuffle iterator after reset (different order)
  shuffleIterator.reset();
  print('\n--- Repeat shuffle playback (different order) ---');
  while (shuffleIterator.hasNext()) {
    print(shuffleIterator.next());
  }

  // Genre iterator demo
  print('\n--- Playing only Rock ---');
  var rockIterator = myPlaylist.getGenreIterator('Rock');
  while (rockIterator.hasNext()) {
    print(rockIterator.next());
  }

  print('\n--- Playing only Pop ---');
  var popIterator = myPlaylist.getGenreIterator('Pop');
  while (popIterator.hasNext()) {
    print(popIterator.next());
  }
}
