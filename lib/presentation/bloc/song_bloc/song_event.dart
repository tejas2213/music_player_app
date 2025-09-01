part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class LoadSongs extends SongEvent {}

class RefreshSongs extends SongEvent {}

class SearchSongs extends SongEvent {
  final String query;

  const SearchSongs(this.query);

  @override
  List<Object> get props => [query];
}