class SongModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int duration;
  final String? albumArt;
  final String uri;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    this.albumArt,
    required this.uri,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'albumArt': albumArt,
      'uri': uri,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'],
      title: map['title'] ?? 'Unknown',
      artist: map['artist'] ?? 'Unknown',
      album: map['album'] ?? 'Unknown',
      duration: map['duration'] ?? 0,
      albumArt: map['albumArt'],
      uri: map['uri'],
    );
  }
}