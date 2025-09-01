part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final List<SongEntity> songs;
  final List<SongEntity> filteredSongs;

  const SongLoaded({required this.songs, required this.filteredSongs});

  SongLoaded copyWith({
    List<SongEntity>? songs,
    List<SongEntity>? filteredSongs,
  }) {
    return SongLoaded(
      songs: songs ?? this.songs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
    );
  }

  @override
  List<Object> get props => [songs, filteredSongs];
}

class SongError extends SongState {
  final String message;

  const SongError(this.message);

  @override
  List<Object> get props => [message];
}