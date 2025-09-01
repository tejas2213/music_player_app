import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/bloc/theme_bloc/theme_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Dark Theme'),
                value: state.isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
          const ListTile(
            title: Text('About'),
            subtitle: Text('Music Player v1.0.0'),
          ),
        ],
      ),
    );
  }
}