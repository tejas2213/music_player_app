import 'package:music_app/domain/entities/song_entity.dart';

import '../repositories/song_repository.dart';

class GetSongs {
  final SongRepository repository;

  GetSongs(this.repository);

  Future<List<SongEntity>> call() async {
    return await repository.getSongs();
  }
}