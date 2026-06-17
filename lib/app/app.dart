import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/auth/auth_bloc.dart';
import '../core/auth/auth_event.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root MaterialApp widget
class NasiyaProApp extends StatefulWidget {
  const NasiyaProApp({super.key});

  @override
  State<NasiyaProApp> createState() => _NasiyaProAppState();
}

class _NasiyaProAppState extends State<NasiyaProApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
    _router = createRouter(_authBloc);

    // App ochilganda session tekshirish
    _authBloc.add(const AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1), boldText: false),
      child: MaterialApp.router(
        title: 'Nasiya Pro',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,

        // Router
        routerConfig: _router,

        // Localization
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
        locale: const Locale('uz'),
      ),
    );
  }
}
