import '../entities/song_entity.dart';

abstract class SongRepository {
  Future<bool> requestPermission();
  Future<List<SongEntity>> getSongs();
  Future<void> addToFavorites(SongEntity song);
  Future<void> removeFromFavorites(String id);
  Future<List<SongEntity>> getFavorites();
  Future<bool> isFavorite(String id);
}