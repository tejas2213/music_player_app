import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:music_app/presentation/widgets/song_tile.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message));
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }

            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final song = state.favorites[index];

                return SongTile(
                  song: song,
                  isFavorite: true,
                  onTap: () {
                    final songState = context.read<SongBloc>().state;
                    if (songState is SongLoaded) {
                      context.read<PlayerBloc>().add(PlaySong(
                        song: song,
                        playlist: state.favorites,
                      ));
                      context.push('/now_playing');
                    }
                  },
                );
              },
            );
          }
          return const Center(child: Text('No favorites yet'));
        },
      ),
    );
  }
}