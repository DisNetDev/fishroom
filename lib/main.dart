import 'package:fishroom/core/theme/dropdown_theme.dart';
import 'package:fishroom/core/theme/slider_theme.dart';
import 'package:fishroom/features/splash_screen/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/repositories/supabase_repository.dart';
import 'features/app/cubit/app_cubit.dart';
import 'features/app/usecases/my_secure_storage.dart';
import 'features/fishroom/cubit/tanks_cubit.dart';
import 'features/tank_inhabitants/cubit/inhabitants_cubit.dart';

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

  await SentryFlutter.init(
    (options) {
      options.beforeSend = (event, hint) {
        if (kDebugMode) {
          return null;
        }

        return event;
      };
      options.dsn = kDebugMode
          ? "false-yet"
          : 'https://09181f12e7794ff303bdc7f88309ca26@o4508846445297664.ingest.us.sentry.io/4508846446673920';
      options.attachScreenshot = kDebugMode ? false : true;
      options.environment = appFlavor;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: MultiRepositoryProvider(
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
                  create: (context) =>
                      AppCubit(context.read<SupabaseRepository>())),
              BlocProvider(
                  create: (context) =>
                      InhabitantsCubit(context.read<SupabaseRepository>())),
            ],
            child: ToastificationWrapper(
                child: KeyboardVisibilityProvider(child: MainApp())),
          ),
        ),
      ),
    ),
  );
}

final SupabaseClient supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        // Constrain the text scaling between 0.8 and 1.4
        final constrainedTextScale =
            mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.2);

        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: TextScaler.linear(constrainedTextScale),
          ),
          child: child!,
        );
      },
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 33, 138, 243),
        ),
      ).copyWith(
          sliderTheme: sliderTheme, dropdownMenuTheme: dropdownThemeData),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 33, 138, 243),
        ),
      ).copyWith(
        sliderTheme: sliderTheme,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
