part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class PlaySong extends PlayerEvent {
  final SongEntity song;
  final List<SongEntity> playlist;

  const PlaySong({required this.song, required this.playlist});

  @override
  List<Object> get props => [song, playlist];
}

class PauseSong extends PlayerEvent {}

class ResumeSong extends PlayerEvent {}

class NextSong extends PlayerEvent {}

class PreviousSong extends PlayerEvent {}

class SeekTo extends PlayerEvent {
  final Duration position;

  const SeekTo(this.position);

  @override
  List<Object> get props => [position];
}

class ToggleShuffle extends PlayerEvent {}

class ToggleRepeat extends PlayerEvent {}

class UpdatePosition extends PlayerEvent {
  final Duration position;
  final Duration duration;

  const UpdatePosition({required this.position, required this.duration});

  @override
  List<Object> get props => [position, duration];
}