class SongEntity {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int duration;
  final String? albumArt;
  final String uri;

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    this.albumArt,
    required this.uri,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}