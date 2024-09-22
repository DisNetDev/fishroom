import 'package:fishroom/features/fishroom/views/my_tanks.dart';
import 'package:fishroom/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/fishroom/cubit/tanks_cubit.dart';
import '/core/constants.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
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
          ),
        ).copyWith(
          //Snackbar theme, remember to change this here and in dark theme below
          snackBarTheme: SnackBarThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            contentTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
        darkTheme: ThemeData.from(
          colorScheme: const ColorScheme.dark(
            primary: Color.fromARGB(255, 33, 138, 243),
          ),
        ).copyWith(
          // Snackbar theme, remember to change this here and in light theme above
          snackBarTheme: SnackBarThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            contentTextStyle: const TextStyle(color: Colors.black),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MyTanks(),
      ),
    );
  }
}
