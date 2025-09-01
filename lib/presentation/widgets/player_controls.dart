import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerPlaying) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: state.isShuffling ? Colors.blue : null,
                ),
                onPressed: () {
                  context.read<PlayerBloc>().add(ToggleShuffle());
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () {
                  context.read<PlayerBloc>().add(PreviousSong());
                },
              ),
              IconButton(
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 36,
                ),
                onPressed: () {
                  if (state.isPlaying) {
                    context.read<PlayerBloc>().add(PauseSong());
                  } else {
                    context.read<PlayerBloc>().add(ResumeSong());
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () {
                  context.read<PlayerBloc>().add(NextSong());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: state.isRepeating ? Colors.blue : null,
                ),
                onPressed: () {
                  context.read<PlayerBloc>().add(ToggleRepeat());
                },
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}