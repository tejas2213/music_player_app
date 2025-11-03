import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/presentation/widgets/player_controls.dart';
import 'package:music_app/presentation/widgets/seek_bar.dart';

class NowPlayingView extends StatelessWidget {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lyrics_rounded),
            onPressed: () => context.push('/lyrics'),
          ),
        ],
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerPlaying) {
            Uint8List? albumArtBytes;
            if (state.currentSong.albumArt != null) {
              albumArtBytes = Uint8List.fromList(
                state.currentSong.albumArt!.codeUnits,
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primary.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (albumArtBytes != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                albumArtBytes,
                                width: 220,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            CircleAvatar(
                              radius: 110,
                              backgroundColor: theme.brightness == Brightness.dark
                                  ? const Color(0xFF1F1F25)
                                  : const Color(0xFFE9E8EF),
                              child: const Icon(
                                Icons.music_note,
                                size: 80,
                                color: Colors.black54,
                              ),
                            ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Text(
                                  state.currentSong.title,
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.currentSong.artist,
                                  style: theme.textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SeekBar(),
                  const SizedBox(height: 8),
                  const PlayerControls(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return const Center(child: Text('No song playing'));
        },
      ),
    );
  }
}
