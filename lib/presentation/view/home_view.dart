import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:music_app/presentation/widgets/song_tile.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SongBloc>().add(LoadSongs());
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<SongBloc>().add(RefreshSongs());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
              ),
              onChanged: (value) {
                context.read<SongBloc>().add(SearchSongs(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SongBloc, SongState>(
              builder: (context, songState) {
                if (songState is SongLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (songState is SongError) {
                  return Center(child: Text(songState.message));
                } else if (songState is SongLoaded) {
                  return BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, favoritesState) {
                      final favorites = favoritesState is FavoritesLoaded
                          ? favoritesState.favorites
                          : [];

                      return ListView.builder(
                        itemCount: songState.filteredSongs.length,
                        itemBuilder: (context, index) {
                          final song = songState.filteredSongs[index];
                          final isFavorite = favorites.any((fav) => fav.id == song.id);

                          return SongTile(
                            song: song,
                            isFavorite: isFavorite,
                            onTap: () {
                              context.read<PlayerBloc>().add(PlaySong(
                                song: song,
                                playlist: songState.filteredSongs,
                              ));
                              context.push('/now_playing');
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('No songs found'));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}