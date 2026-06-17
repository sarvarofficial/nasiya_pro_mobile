import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'app/di/injection.dart';
import 'core/auth/auth_bloc.dart';
import 'core/config/app_config.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/debts/presentation/bloc/debt_bloc.dart';
import 'features/debts/presentation/bloc/debt_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Screen orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // DI setup
  await configureDependencies(AppConfig.dev);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<DebtBloc>(
          create: (_) => getIt<DebtBloc>()..add(const LoadDebts()),
        ),
      ],
      child: const NasiyaProApp(),
    ),
  );
}
