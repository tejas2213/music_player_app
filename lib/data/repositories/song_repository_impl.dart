import 'dart:typed_data';

import 'package:music_app/data/datasources/local/database_helper.dart';
import 'package:music_app/data/datasources/local/local_data_source.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/repositories/song_repository.dart';


class SongRepositoryImpl implements SongRepository {
  final LocalDataSource localDataSource;
  final DatabaseHelper databaseHelper;

  SongRepositoryImpl({
    required this.localDataSource,
    required this.databaseHelper,
  });

  @override
  Future<bool> requestPermission() async {
    return await localDataSource.requestPermission();
  }

  @override
  Future<List<SongEntity>> getSongs() async {
    final songs = await localDataSource.getSongs();
    final List<SongEntity> songEntities = [];

    for (final song in songs) {
      Uint8List? albumArtData;
      try {
        albumArtData = await localDataSource.getAlbumArt(song.id);
      } catch (e) {
        albumArtData = null;
      }

      songEntities.add(SongEntity(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist ?? 'Unknown',
        album: song.album ?? 'Unknown',
        duration: song.duration ?? 0,
        albumArt: albumArtData != null ? String.fromCharCodes(albumArtData) : null,
        uri: song.uri ?? '',
      ));
    }

    return songEntities;
  }


  @override
  Future<void> addToFavorites(SongEntity song) async {
    await databaseHelper.insertFavorite({
      'id': song.id,
      'title': song.title,
      'artist': song.artist,
      'album': song.album,
      'duration': song.duration,
      'albumArt': song.albumArt,
      'uri': song.uri,
    });
  }

  @override
  Future<void> removeFromFavorites(String id) async {
    await databaseHelper.removeFavorite(id);
  }

  @override
  Future<List<SongEntity>> getFavorites() async {
    final favorites = await databaseHelper.getFavorites();
    return favorites.map((fav) => SongEntity(
      id: fav['id'] as String,
      title: fav['title'] as String,
      artist: fav['artist'] as String,
      album: fav['album'] as String,
      duration: fav['duration'] as int,
      albumArt: fav['albumArt'] as String?,
      uri: fav['uri'] as String,
    )).toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return await databaseHelper.isFavorite(id);
  }
}