// ignore_for_file: prefer-match-file-name

import 'package:fishroom/features/IAP/iap_service.dart';
import 'package:fishroom/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/repositories/supabase_repository.dart';
import 'features/app/cubit/app_cubit.dart';
import 'features/app/usecases/my_secure_storage.dart';
import 'features/fishroom/cubit/tanks_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      authOptions: FlutterAuthClientOptions(
        localStorage: MySecureStorage(),
      ));

  runApp(MultiRepositoryProvider(
    providers: [
      //Global Repositories
      RepositoryProvider(create: (context) => SupabaseRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        //Global Blocs
        BlocProvider(
            create: (context) => TanksCubit(
                supabaseRepository: context.read<SupabaseRepository>())),
        BlocProvider(
            create: (context) => AppCubit(context.read<SupabaseRepository>())),
      ],
      child: ToastificationWrapper(child: MainApp()),
    ),
  ));
}

final SupabaseClient supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        sliderTheme: const SliderThemeData(
          trackHeight: 10.0,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 33, 138, 243),
        ),
      ).copyWith(
        snackBarTheme: SnackBarThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          contentTextStyle: const TextStyle(color: Colors.black),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 10.0,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
