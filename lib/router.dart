import 'package:go_router/go_router.dart';
import 'package:music_app/presentation/view/lyrics_view.dart';
import 'package:music_app/presentation/view/main_layout.dart';
import 'package:music_app/presentation/view/now_playing_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: '/now_playing',
        name: 'now_playing',
        builder: (context, state) => const NowPlayingView(),
      ),
      GoRoute(
        path: '/lyrics',
        name: 'lyrics',
        builder: (context, state) => const LyricsView(),
      ),
    ],
  );
}
