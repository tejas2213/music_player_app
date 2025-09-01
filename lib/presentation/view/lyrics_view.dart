import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/dependencies.dart';
import 'package:music_app/domain/entities/lyrics_entity.dart';
import 'package:music_app/domain/repositories/lyrics_repository.dart';
import 'package:music_app/domain/usecases/get_lyrics.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({super.key});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  late Future<LyricsEntity> _lyricsFuture;

  @override
  void initState() {
    super.initState();
    final state = context.read<PlayerBloc>().state;
    if (state is PlayerPlaying) {
      _lyricsFuture = GetLyrics(getIt<LyricsRepository>()).call(
        state.currentSong.artist,
        state.currentSong.title,
        state.currentSong.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics'),
      ),
      body: FutureBuilder<LyricsEntity>(
        future: _lyricsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final lyrics = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lyrics.source.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Source: ${lyrics.source}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  Text(
                    lyrics.lyrics,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No lyrics available'));
        },
      ),
    );
  }
}