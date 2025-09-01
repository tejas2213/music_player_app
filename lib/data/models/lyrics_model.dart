class LyricsModel {
  final String lyrics;
  final String source;

  LyricsModel({
    required this.lyrics,
    required this.source,
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      lyrics: json['lyrics'] ?? 'Lyrics not found',
      source: json['source'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lyrics': lyrics,
      'source': source,
    };
  }
}