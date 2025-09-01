import 'package:music_app/domain/entities/song_entity.dart';

import '../repositories/song_repository.dart';

class GetFavorites {
  final SongRepository repository;

  GetFavorites(this.repository);

  Future<List<SongEntity>> call() async {
    return await repository.getFavorites();
  }
}