import '../repositories/lyrics_repository.dart';
import '../entities/lyrics_entity.dart';

class GetLyrics {
  final LyricsRepository repository;

  GetLyrics(this.repository);

  Future<LyricsEntity> call(String artist, String title, String songId) async {
    return await repository.getLyrics(artist, title, songId);
  }
}