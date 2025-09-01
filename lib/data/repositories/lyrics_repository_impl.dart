import 'package:music_app/data/datasources/local/database_helper.dart';
import 'package:music_app/data/datasources/remote/lyrics_data_source.dart';
import 'package:music_app/domain/entities/lyrics_entity.dart';
import 'package:music_app/domain/repositories/lyrics_repository.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsDataSource lyricsDataSource;
  final DatabaseHelper databaseHelper;

  LyricsRepositoryImpl({
    required this.lyricsDataSource,
    required this.databaseHelper,
  });

  @override
  Future<LyricsEntity> getLyrics(String artist, String title, String songId) async {
    final cachedLyrics = await databaseHelper.getCachedLyrics(songId);
    if (cachedLyrics != null) {
      return LyricsEntity(
        lyrics: cachedLyrics['lyrics'] as String,
        source: cachedLyrics['source'] as String,
      );
    }

    try {
      final lyricsData = await lyricsDataSource.getLyrics(artist, title);
      final lyricsEntity = LyricsEntity(
        lyrics: lyricsData['lyrics'] as String,
        source: lyricsData['source'] as String,
      );

      await databaseHelper.cacheLyrics({
        'song_id': songId,
        'lyrics': lyricsEntity.lyrics,
        'source': lyricsEntity.source,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      return lyricsEntity;
    } catch (e) {
      return LyricsEntity(
        lyrics: 'Failed to load lyrics: $e',
        source: 'Error',
      );
    }
  }
}