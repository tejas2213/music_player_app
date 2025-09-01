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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lyrics),
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

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (albumArtBytes != null)
                          Image.memory(
                            albumArtBytes,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        else
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.black54,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          state.currentSong.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          state.currentSong.artist,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SeekBar(),
                const PlayerControls(),
                const SizedBox(height: 20),
              ],
            );
          }
          return const Center(child: Text('No song playing'));
        },
      ),
    );
  }
}
