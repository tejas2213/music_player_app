import 'dart:convert';
import 'package:http/http.dart' as http;

class LyricsDataSource {
  final http.Client client;

  LyricsDataSource({required this.client});

  Future<Map<String, dynamic>> getLyrics(String artist, String title) async {
    try {
      final encodedArtist = Uri.encodeComponent(artist.trim());
      final encodedTitle = Uri.encodeComponent(title.trim());

      final response = await client.get(
        Uri.parse("https://api.lyrics.ovh/v1/$encodedArtist/$encodedTitle"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'lyrics': data['lyrics'],
          'source': 'Lyrics.ovh',
        };
      } else {
        throw Exception('Failed to fetch lyrics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch lyrics: $e');
    }
  }
}