// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_player_app/domain/entities/song_entity.dart';
// import 'package:music_player_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';

// class SongTile extends StatelessWidget {
//   final SongEntity song;
//   final VoidCallback onTap;
//   final bool isFavorite;

//   const SongTile({
//     Key? key,
//     required this.song,
//     required this.onTap,
//     required this.isFavorite,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.grey[300],
//         child: const Icon(Icons.music_note, color: Colors.black54),
//       ),
//       title: Text(
//         song.title,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//       subtitle: Text(
//         '${song.artist} • ${song.album}',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: Theme.of(context).textTheme.bodyMedium,
//       ),
//       trailing: IconButton(
//         icon: Icon(
//           isFavorite ? Icons.favorite : Icons.favorite_border,
//           color: isFavorite ? Colors.red : null,
//         ),
//         onPressed: () {
//           context.read<FavoritesBloc>().add(ToggleFavoriteEvent(
//             song: song,
//             isFavorite: isFavorite,
//           ));
//         },
//       ),
//       onTap: onTap,
//     );
//   }
// }


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';

class SongTile extends StatelessWidget {
  final SongEntity song;
  final VoidCallback onTap;
  final bool isFavorite;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? albumArtBytes;
    if (song.albumArt != null) {
      albumArtBytes = Uint8List.fromList(song.albumArt!.codeUnits);
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: albumArtBytes != null
                    ? Image.memory(
                        albumArtBytes,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFF1F1F25)
                            : const Color(0xFFE9E8EF),
                        child: const Icon(Icons.music_note, color: Colors.black54),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${song.artist} • ${song.album}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? scheme.error : theme.iconTheme.color,
                ),
                onPressed: () {
                  context.read<FavoritesBloc>().add(ToggleFavoriteEvent(
                    song: song,
                    isFavorite: isFavorite,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}