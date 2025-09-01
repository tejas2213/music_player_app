part of 'player_bloc.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerPlaying extends PlayerState {
  final SongEntity currentSong;
  final List<SongEntity> playlist;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isShuffling;
  final bool isRepeating;

  const PlayerPlaying({
    required this.currentSong,
    required this.playlist,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isShuffling,
    required this.isRepeating,
  });

  PlayerPlaying copyWith({
    SongEntity? currentSong,
    List<SongEntity>? playlist,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isShuffling,
    bool? isRepeating,
  }) {
    return PlayerPlaying(
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
      isRepeating: isRepeating ?? this.isRepeating,
    );
  }

  @override
  List<Object> get props => [
    currentSong,
    playlist,
    position,
    duration,
    isPlaying,
    isShuffling,
    isRepeating,
  ];
}

class PlayerError extends PlayerState {
  final String message;

  const PlayerError(this.message);

  @override
  List<Object> get props => [message];
}