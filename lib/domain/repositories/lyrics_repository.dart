import '../entities/lyrics_entity.dart';

abstract class LyricsRepository {
  Future<LyricsEntity> getLyrics(String artist, String title, String songId);
}