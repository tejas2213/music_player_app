import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class LocalDataSource {
  final OnAudioQuery _audioQuery = OnAudioQuery();

   Future<bool> requestPermission() async {
    try {
      bool hasPermission = await _audioQuery.permissionsStatus();
      
      if (!hasPermission) {
        hasPermission = await _audioQuery.permissionsRequest();
      }
      
      return hasPermission;
    } catch (e) {
      return false;
    }
  }

  Future<List<SongModel>> getSongs() async {
    try {
      final hasPermission = await requestPermission();
      
      if (!hasPermission) {
        throw Exception('Permission denied to access audio files');
      }
      
      return await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } catch (e) {
      throw Exception('Failed to get songs: $e');
    }
  }

  Future<Uint8List?> getAlbumArt(int songId) async {
    try {
      final hasPermission = await requestPermission();
      
      if (!hasPermission) {
        return null;
      }
      
      return await _audioQuery.queryArtwork(
        songId, 
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 200,
      );
    } catch (e) {
      return null;
    }
  }
}