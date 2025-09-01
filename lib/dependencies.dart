import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:music_app/core/constants/app_constants.dart';
import 'package:music_app/core/services/audio_service_handler.dart';
import 'package:music_app/data/datasources/local/database_helper.dart';
import 'package:music_app/data/datasources/local/local_data_source.dart';
import 'package:music_app/data/datasources/remote/lyrics_data_source.dart';
import 'package:music_app/data/repositories/lyrics_repository_impl.dart';
import 'package:music_app/data/repositories/song_repository_impl.dart';
import 'package:music_app/domain/repositories/lyrics_repository.dart';
import 'package:music_app/domain/repositories/song_repository.dart';
import 'package:music_app/domain/usecases/get_favorites.dart';
import 'package:music_app/domain/usecases/get_lyrics.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import 'package:music_app/domain/usecases/toggle_favorite.dart';
import 'package:music_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:music_app/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:music_app/router.dart';

// Instance of GetIt (Service Locator for dependency injection)
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  getIt.registerLazySingleton<LyricsDataSource>(
    () => LyricsDataSource(client: http.Client()),
  );

  // Repositories
  getIt.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(
      localDataSource: getIt<LocalDataSource>(),
      databaseHelper: getIt<DatabaseHelper>(),
    ),
  );

  getIt.registerLazySingleton<LyricsRepository>(
    () => LyricsRepositoryImpl(
      lyricsDataSource: getIt<LyricsDataSource>(),
      databaseHelper: getIt<DatabaseHelper>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetSongs>(
    () => GetSongs(getIt<SongRepository>()),
  );

  getIt.registerLazySingleton<GetFavorites>(
    () => GetFavorites(getIt<SongRepository>()),
  );

  getIt.registerLazySingleton<ToggleFavorite>(
    () => ToggleFavorite(getIt<SongRepository>()),
  );

  getIt.registerLazySingleton<GetLyrics>(
    () => GetLyrics(getIt<LyricsRepository>()),
  );

  // Blocs (State Management)
  getIt.registerFactory<SongBloc>(() => SongBloc(getSongs: getIt<GetSongs>()));

  getIt.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(
      getFavorites: getIt<GetFavorites>(),
      toggleFavorite: getIt<ToggleFavorite>(),
    ),
  );

  getIt.registerFactory<PlayerBloc>(
    () => PlayerBloc(
      audioPlayer: getIt<AudioPlayer>(),
      audioHandler: getIt<AudioPlayerHandler>(),
    ),
  );

  getIt.registerFactory<ThemeBloc>(
    () => ThemeBloc(databaseHelper: getIt<DatabaseHelper>()),
  );

  // Audio Player
  getIt.registerLazySingleton<AudioPlayer>(() => AudioPlayer());

  getIt.registerLazySingleton<AudioPlayerHandler>(() => AudioPlayerHandler());

  getIt.registerSingletonAsync<AudioHandler>(() async {
    return await AudioService.init(
      builder: () => getIt<AudioPlayerHandler>(),
      config: const AudioServiceConfig(
        androidNotificationChannelId:
            AppConstants.audioServiceNotificationChannelId,
        androidNotificationChannelName:
            AppConstants.audioServiceNotificationChannelName,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  });

  // Router
  getIt.registerLazySingleton<GoRouter>(() => AppRouter.router);
}
