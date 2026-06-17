import 'package:get_it/get_it.dart';
import '../../core/auth/token_storage.dart';
import '../../core/auth/auth_bloc.dart';
import '../../core/api/dio_client.dart';
import '../../core/config/app_config.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_manager.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/sources/auth_remote_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/debts/data/repositories/debt_repository_impl.dart';
import '../../features/debts/data/sources/debt_remote_source.dart';
import '../../features/debts/data/sources/debt_local_source.dart';
import '../../features/debts/domain/repositories/debt_repository.dart';
import '../../features/debts/domain/usecases/get_debts_usecase.dart';
import '../../features/debts/domain/usecases/get_debt_detail_usecase.dart';
import '../../features/debts/domain/usecases/get_debt_stats_usecase.dart';
import '../../features/debts/domain/usecases/create_debt_usecase.dart';
import '../../features/debts/domain/usecases/delete_debt_usecase.dart';
import '../../features/debts/presentation/bloc/debt_bloc.dart';

final getIt = GetIt.instance;

/// Barcha dependency larni register qilish
Future<void> configureDependencies(AppConfig config) async {
  // ─── Config ───────────────────────────────────────────
  getIt.registerSingleton<AppConfig>(config);

  // ─── Core: Token Storage ───────────────────────────────
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // ─── Core: Local Database (Drift) ─────────────────────
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ─── Core: Dio Client ─────────────────────────────────
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenStorage: getIt<TokenStorage>(),
      config: getIt<AppConfig>(),
    ),
  );

  // ─── Auth: Remote Source ──────────────────────────────
  getIt.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSource(dio: getIt<DioClient>().dio),
  );

  // ─── Auth: Repository ─────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteSource: getIt<AuthRemoteSource>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // ─── Auth: BLoC ───────────────────────────────────────
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // ─── Debts: Remote Source ─────────────────────────────
  getIt.registerLazySingleton<DebtRemoteSource>(
    () => DebtRemoteSource(dio: getIt<DioClient>().dio),
  );

  // ─── Debts: Local Source ──────────────────────────────
  getIt.registerLazySingleton<DebtLocalSource>(
    () => DebtLocalSource(db: getIt<AppDatabase>()),
  );

  // ─── Debts: Repository (offline-first) ───────────────
  getIt.registerLazySingleton<DebtRepository>(
    () => DebtRepositoryImpl(
      remoteSource: getIt<DebtRemoteSource>(),
      localSource: getIt<DebtLocalSource>(),
    ),
  );

  // ─── Debts: UseCases ─────────────────────────────────
  getIt.registerLazySingleton(() => GetDebtsUseCase(getIt<DebtRepository>()));
  getIt.registerLazySingleton(() => GetDebtDetailUseCase(getIt<DebtRepository>()));
  getIt.registerLazySingleton(() => GetDebtStatsUseCase(getIt<DebtRepository>()));
  getIt.registerLazySingleton(() => CreateDebtUseCase(getIt<DebtRepository>()));
  getIt.registerLazySingleton(() => DeleteDebtUseCase(getIt<DebtRepository>()));

  // ─── Debts: BLoC (factory — har sahifada yangi) ──────
  getIt.registerFactory<DebtBloc>(
    () => DebtBloc(
      getDebts: getIt<GetDebtsUseCase>(),
      getStats: getIt<GetDebtStatsUseCase>(),
      createDebt: getIt<CreateDebtUseCase>(),
      deleteDebt: getIt<DeleteDebtUseCase>(),
    ),
  );

  // ─── Sync Manager ────────────────────────────────────
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(
      db: getIt<AppDatabase>(),
      debtRemoteSource: getIt<DebtRemoteSource>(),
    ),
  );
}
