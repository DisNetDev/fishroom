import 'package:fishroom/features/fishroom/views/my_tanks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/fishroom/cubit/tanks_cubit.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TanksCubit(),
      child: MaterialApp(
        theme: ThemeData.from(
            colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 33, 138, 243),
        )),
        darkTheme: ThemeData.from(
            colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 33, 138, 243),
        )),
        themeMode: ThemeMode.system,
        home: const MyTanks(),
      ),
    );
  }
}
