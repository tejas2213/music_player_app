import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/core/theme/app_theme.dart';
import 'package:music_app/dependencies.dart';
import 'package:music_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_app/presentation/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:music_app/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:music_app/router.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await Permission.audio.request();
  await Permission.photos.request();
  await Permission.mediaLibrary.request();
  await Permission.storage.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => getIt<ThemeBloc>()..add(LoadTheme()),
        ),
        BlocProvider<SongBloc>(
          create: (context) => getIt<SongBloc>(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => getIt<FavoritesBloc>(),
        ),
        BlocProvider<PlayerBloc>(
          create: (context) => getIt<PlayerBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Music Player',
            theme: state.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
