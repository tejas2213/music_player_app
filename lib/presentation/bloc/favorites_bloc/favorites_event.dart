part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final SongEntity song;
  final bool isFavorite;

  const ToggleFavoriteEvent({required this.song, required this.isFavorite});

  @override
  List<Object> get props => [song, isFavorite];
}