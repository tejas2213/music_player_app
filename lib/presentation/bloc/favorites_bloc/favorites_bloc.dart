import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/usecases/get_favorites.dart';
import 'package:music_app/domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favorites = await getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      await toggleFavorite(song: event.song, isFavorite: event.isFavorite);
      final favorites = await getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}