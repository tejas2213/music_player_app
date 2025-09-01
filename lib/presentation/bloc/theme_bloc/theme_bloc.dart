import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/data/datasources/local/database_helper.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final DatabaseHelper databaseHelper;

  ThemeBloc({required this.databaseHelper}) : super(ThemeInitial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = !state.isDark;
    await databaseHelper.saveSetting('isDark', newTheme.toString());
    emit(ThemeLoaded(newTheme));
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDarkString = await databaseHelper.getSetting('isDark');
    final isDark = isDarkString == 'true';
    emit(ThemeLoaded(isDark));
  }
}