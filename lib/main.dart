import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/theme/dropdown_theme.dart';
import 'package:fishroom/core/theme/slider_theme.dart';
import 'package:fishroom/core/usecases/init_hydrated_bloc.dart';
import 'package:fishroom/features/release_notes/cubit/release_notes_cubit.dart';
import 'package:fishroom/features/splash_screen/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/repositories/supabase_repository.dart';
import 'features/app/cubit/app_cubit.dart';
import 'features/app/usecases/my_secure_storage.dart';
import 'features/community_tank/cubit/community_tank_cubit.dart';
import 'features/fishroom/cubit/tanks_cubit.dart';
import 'features/tank_inhabitants/cubit/inhabitants_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHydratedBloc();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env[kDebugMode ? 'SUPABASE_STAGING_URL' : 'SUPABASE_URL']!,
      anonKey: dotenv
          .env[kDebugMode ? 'SUPABASE_STAGING_ANON_KEY' : 'SUPABASE_ANON_KEY']!,
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
              BlocProvider(create: (context) => ReleaseNotesCubit()),
              BlocProvider(
                  create: (context) => TanksCubit(
                      supabaseRepository: context.read<SupabaseRepository>())),
              BlocProvider(
                  create: (context) =>
                      AppCubit(context.read<SupabaseRepository>())),
              BlocProvider(
                  create: (context) =>
                      InhabitantsCubit(context.read<SupabaseRepository>())),
              BlocProvider(
                  create: (context) => CommunityTankCubit(
                      supabaseRepository: context.read<SupabaseRepository>())),
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
          primary: kTertiaryColor,
        ),
      ).copyWith(
          dividerColor: Colors.transparent,
          sliderTheme: sliderTheme,
          dropdownMenuTheme: dropdownThemeDataLight),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: kTertiaryColor,
        ),
      ).copyWith(
          dividerColor: Colors.transparent,
          sliderTheme: sliderTheme,
          dropdownMenuTheme: dropdownThemeDataDark),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
