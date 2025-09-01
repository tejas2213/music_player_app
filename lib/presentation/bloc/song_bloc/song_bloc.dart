import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/usecases/get_songs.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetSongs getSongs;
  List<SongEntity> allSongs = [];

  SongBloc({required this.getSongs}) : super(SongInitial()) {
    on<LoadSongs>(_onLoadSongs);
    on<RefreshSongs>(_onRefreshSongs);
    on<SearchSongs>(_onSearchSongs);
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      allSongs = await getSongs();
      emit(SongLoaded(songs: allSongs, filteredSongs: allSongs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onRefreshSongs(RefreshSongs event, Emitter<SongState> emit) async {
    try {
      allSongs = await getSongs();
      emit(SongLoaded(songs: allSongs, filteredSongs: allSongs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  void _onSearchSongs(SearchSongs event, Emitter<SongState> emit) {
    if (state is SongLoaded) {
      final currentState = state as SongLoaded;
      if (event.query.isEmpty) {
        emit(currentState.copyWith(filteredSongs: allSongs));
      } else {
        final filtered = allSongs.where((song) =>
          song.title.toLowerCase().contains(event.query.toLowerCase()) ||
          song.artist.toLowerCase().contains(event.query.toLowerCase()) ||
          song.album.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
        emit(currentState.copyWith(filteredSongs: filtered));
      }
    }
  }
}