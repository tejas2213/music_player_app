import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/core/services/audio_service_handler.dart';
import 'package:music_app/domain/entities/song_entity.dart';

part 'player_event.dart';
part 'player_state.dart';

// class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
//   final AudioPlayer audioPlayer;
//   List<SongEntity> _playlist = [];
//   int _currentIndex = 0;
//   bool _isShuffling = false;
//   bool _isRepeating = false;
//   List<int> _originalIndices = [];

//   PlayerBloc({required this.audioPlayer}) : super(PlayerInitial()) {
//     on<PlaySong>(_onPlaySong);
//     on<PauseSong>(_onPauseSong);
//     on<ResumeSong>(_onResumeSong);
//     on<NextSong>(_onNextSong);
//     on<PreviousSong>(_onPreviousSong);
//     on<SeekTo>(_onSeekTo);
//     on<ToggleShuffle>(_onToggleShuffle);
//     on<ToggleRepeat>(_onToggleRepeat);
//     on<UpdatePosition>(_onUpdatePosition);

//     audioPlayer.playerStateStream.listen((playerState) {
//       if (playerState.playing) {
//         add(UpdatePosition(
//           position: audioPlayer.position,
//           duration: audioPlayer.duration ?? Duration.zero,
//         ));
//       }
//     });

//     audioPlayer.positionStream.listen((position) {
//       add(UpdatePosition(
//         position: position,
//         duration: audioPlayer.duration ?? Duration.zero,
//       ));
//     });
//   }

//   Future<void> _onPlaySong(PlaySong event, Emitter<PlayerState> emit) async {
//     try {
//       _playlist = event.playlist;
//       _currentIndex = _playlist.indexOf(event.song);
//       _originalIndices = List.generate(_playlist.length, (index) => index);

//       if (_isShuffling) {
//         _shufflePlaylist();
//       }

//       await audioPlayer.setAudioSource(
//         ConcatenatingAudioSource(
//           children: _playlist.map((song) => AudioSource.uri(Uri.parse(song.uri))).toList(),
//         ),
//         initialIndex: _currentIndex,
//       );

//       await audioPlayer.play();

//       emit(PlayerPlaying(
//         currentSong: event.song,
//         playlist: _playlist,
//         position: Duration.zero,
//         duration: audioPlayer.duration ?? Duration.zero,
//         isPlaying: true,
//         isShuffling: _isShuffling,
//         isRepeating: _isRepeating,
//       ));
//     } catch (e) {
//       emit(PlayerError(e.toString()));
//     }
//   }

//   Future<void> _onPauseSong(PauseSong event, Emitter<PlayerState> emit) async {
//     if (state is PlayerPlaying) {
//       await audioPlayer.pause();
//       final currentState = state as PlayerPlaying;
//       emit(currentState.copyWith(isPlaying: false));
//     }
//   }

//   Future<void> _onResumeSong(ResumeSong event, Emitter<PlayerState> emit) async {
//     if (state is PlayerPlaying) {
//       await audioPlayer.play();
//       final currentState = state as PlayerPlaying;
//       emit(currentState.copyWith(isPlaying: true));
//     }
//   }

//   Future<void> _onNextSong(NextSong event, Emitter<PlayerState> emit) async {
//     if (state is PlayerPlaying) {
//       final currentState = state as PlayerPlaying;
//       if (_currentIndex < _playlist.length - 1 || _isRepeating) {
//         _currentIndex = (_currentIndex + 1) % _playlist.length;
//         await audioPlayer.seekToNext();
//         emit(currentState.copyWith(
//           currentSong: _playlist[_currentIndex],
//           isPlaying: true,
//         ));
//       }
//     }
//   }

//   Future<void> _onPreviousSong(PreviousSong event, Emitter<PlayerState> emit) async {
//     if (state is PlayerPlaying) {
//       final currentState = state as PlayerPlaying;
//       if (_currentIndex > 0 || _isRepeating) {
//         _currentIndex = (_currentIndex - 1) % _playlist.length;
//         await audioPlayer.seekToPrevious();
//         emit(currentState.copyWith(
//           currentSong: _playlist[_currentIndex],
//           isPlaying: true,
//         ));
//       }
//     }
//   }

//   Future<void> _onSeekTo(SeekTo event, Emitter<PlayerState> emit) async {
//     if (state is PlayerPlaying) {
//       await audioPlayer.seek(event.position);
//       final currentState = state as PlayerPlaying;
//       emit(currentState.copyWith(position: event.position));
//     }
//   }

//   void _onToggleShuffle(ToggleShuffle event, Emitter<PlayerState> emit) {
//     if (state is PlayerPlaying) {
//       _isShuffling = !_isShuffling;
//       final currentState = state as PlayerPlaying;

//       if (_isShuffling) {
//         _shufflePlaylist();
//       } else {
//         _unshufflePlaylist();
//       }

//       emit(currentState.copyWith(
//         isShuffling: _isShuffling,
//         playlist: _playlist,
//       ));
//     }
//   }

//   void _onToggleRepeat(ToggleRepeat event, Emitter<PlayerState> emit) {
//     if (state is PlayerPlaying) {
//       _isRepeating = !_isRepeating;
//       final currentState = state as PlayerPlaying;
//       audioPlayer.setLoopMode(_isRepeating ? LoopMode.all : LoopMode.off);
//       emit(currentState.copyWith(isRepeating: _isRepeating));
//     }
//   }

//   void _onUpdatePosition(UpdatePosition event, Emitter<PlayerState> emit) {
//     if (state is PlayerPlaying) {
//       final currentState = state as PlayerPlaying;
//       emit(currentState.copyWith(
//         position: event.position,
//         duration: event.duration,
//       ));
//     }
//   }

//   void _shufflePlaylist() {
//     final currentSong = _playlist[_currentIndex];
//     _playlist.shuffle();
//     _currentIndex = _playlist.indexOf(currentSong);
//   }

//   void _unshufflePlaylist() {
//     final currentSong = _playlist[_currentIndex];
//     _playlist = _originalIndices.map((index) => _playlist[index]).toList();
//     _currentIndex = _playlist.indexOf(currentSong);
//   }

//   @override
//   Future<void> close() {
//     audioPlayer.dispose();
//     return super.close();
//   }
// }



class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer audioPlayer;
  final AudioPlayerHandler audioHandler;
  List<SongEntity> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffling = false;
  bool _isRepeating = false;

  PlayerBloc({required this.audioPlayer, required this.audioHandler}) : super(PlayerInitial()) {
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
    on<SeekTo>(_onSeekTo);
    on<ToggleShuffle>(_onToggleShuffle);
    on<ToggleRepeat>(_onToggleRepeat);
    on<UpdatePosition>(_onUpdatePosition);

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        add(UpdatePosition(
          position: audioPlayer.position,
          duration: audioPlayer.duration ?? Duration.zero,
        ));
      }
    });

    audioPlayer.positionStream.listen((position) {
      add(UpdatePosition(
        position: position,
        duration: audioPlayer.duration ?? Duration.zero,
      ));
    });
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<PlayerState> emit) async {
    try {
      _playlist = event.playlist;
      _currentIndex = _playlist.indexOf(event.song);

      // Set up audio service
      await audioHandler.setQueue(_playlist, _currentIndex);
      await audioHandler.play();

      emit(PlayerPlaying(
        currentSong: event.song,
        playlist: _playlist,
        position: Duration.zero,
        duration: audioPlayer.duration ?? Duration.zero,
        isPlaying: true,
        isShuffling: _isShuffling,
        isRepeating: _isRepeating,
      ));
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<PlayerState> emit) async {
    if (state is PlayerPlaying) {
      await audioHandler.pause();
      final currentState = state as PlayerPlaying;
      emit(currentState.copyWith(isPlaying: false));
    }
  }

  Future<void> _onResumeSong(ResumeSong event, Emitter<PlayerState> emit) async {
    if (state is PlayerPlaying) {
      await audioHandler.play();
      final currentState = state as PlayerPlaying;
      emit(currentState.copyWith(isPlaying: true));
    }
  }

  Future<void> _onNextSong(NextSong event, Emitter<PlayerState> emit) async {
    if (state is PlayerPlaying) {
      final currentState = state as PlayerPlaying;
      if (_currentIndex < _playlist.length - 1 || _isRepeating) {
        _currentIndex = (_currentIndex + 1) % _playlist.length;
        await audioHandler.skipToNext();
        emit(currentState.copyWith(
          currentSong: _playlist[_currentIndex],
          isPlaying: true,
        ));
      }
    }
  }

  Future<void> _onPreviousSong(PreviousSong event, Emitter<PlayerState> emit) async {
    if (state is PlayerPlaying) {
      final currentState = state as PlayerPlaying;
      if (_currentIndex > 0 || _isRepeating) {
        _currentIndex = (_currentIndex - 1) % _playlist.length;
        await audioHandler.skipToPrevious();
        emit(currentState.copyWith(
          currentSong: _playlist[_currentIndex],
          isPlaying: true,
        ));
      }
    }
  }

  Future<void> _onSeekTo(SeekTo event, Emitter<PlayerState> emit) async {
    if (state is PlayerPlaying) {
      await audioHandler.seek(event.position);
      final currentState = state as PlayerPlaying;
      emit(currentState.copyWith(position: event.position));
    }
  }

  void _onToggleShuffle(ToggleShuffle event, Emitter<PlayerState> emit) {
    if (state is PlayerPlaying) {
      _isShuffling = !_isShuffling;
      final currentState = state as PlayerPlaying;
      emit(currentState.copyWith(isShuffling: _isShuffling));
    }
  }

  void _onToggleRepeat(ToggleRepeat event, Emitter<PlayerState> emit) {
    if (state is PlayerPlaying) {
      _isRepeating = !_isRepeating;
      final currentState = state as PlayerPlaying;
      audioPlayer.setLoopMode(_isRepeating ? LoopMode.all : LoopMode.off);
      emit(currentState.copyWith(isRepeating: _isRepeating));
    }
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<PlayerState> emit) {
    if (state is PlayerPlaying) {
      final currentState = state as PlayerPlaying;
      emit(currentState.copyWith(
        position: event.position,
        duration: event.duration,
      ));
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}