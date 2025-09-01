import '../entities/song_entity.dart';
import '../repositories/song_repository.dart';

class ToggleFavorite {
  final SongRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call({required SongEntity song, required bool isFavorite}) async {
    if (isFavorite) {
      await repository.removeFromFavorites(song.id);
    } else {
      await repository.addToFavorites(song);
    }
  }
}