# Debt Management System — Flutter Mobile Intelligence

## Project Context
B2B SaaS qarz boshqaruv tizimi — Flutter mobile app.
Backend: NestJS + PostgreSQL (schema-per-tenant).
Offline-first, multi-role, multi-branch.

---

## Tech Stack (Flutter)

| Layer | Package | Why |
|---|---|---|
| State | `flutter_bloc` | Predictable, testable, scalable |
| Navigation | `go_router` | Declarative, deep linking, auth guard |
| Local DB | `drift` | Type-safe SQLite, offline sync |
| HTTP | `dio` + `retrofit` | Interceptors, type-safe API |
| DI | `get_it` + `injectable` | Service locator, testable |
| Secure storage | `flutter_secure_storage` | JWT, PIN storage |
| Notifications | `firebase_messaging` | Push notifications |
| PDF | `pdf` + `printing` | Report generation |
| Forms | `reactive_forms` | Complex validation |
| Connectivity | `connectivity_plus` | Online/offline detection |
| Localization | `flutter_localizations` | UZ/RU/EN |

---

## Folder Structure

```
lib/
├── app/
│   ├── app.dart              # MaterialApp + router
│   ├── di/                   # get_it setup
│   └── theme/                # colors, text styles, spacing
│
├── core/
│   ├── api/
│   │   ├── dio_client.dart   # base dio setup
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart    # JWT attach + refresh
│   │   │   ├── tenant_interceptor.dart  # X-Tenant-ID header
│   │   │   └── error_interceptor.dart
│   │   └── api_result.dart   # Success/Failure wrapper
│   ├── db/
│   │   ├── app_database.dart # drift database
│   │   └── tables/           # local tables
│   ├── sync/
│   │   ├── sync_manager.dart
│   │   └── sync_queue.dart
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   └── token_storage.dart
│   └── utils/
│       ├── formatters.dart   # currency, date
│       └── validators.dart
│
├── features/
│   ├── dashboard/
│   ├── debts/
│   ├── payments/
│   ├── customers/
│   ├── audit/
│   ├── reports/
│   ├── branches/
│   └── settings/
│
└── shared/
    ├── widgets/              # reusable UI components
    └── extensions/           # BuildContext, String extensions
```

### Feature folder pattern (har bir feature bir xil)
```
features/debts/
├── data/
│   ├── models/
│   │   ├── debt_model.dart         # JSON serializable
│   │   └── debt_model.g.dart       # generated
│   ├── repositories/
│   │   └── debt_repository_impl.dart
│   └── sources/
│       ├── debt_remote_source.dart  # API calls
│       └── debt_local_source.dart   # drift queries
├── domain/
│   ├── entities/
│   │   └── debt.dart               # pure dart, no JSON
│   ├── repositories/
│   │   └── debt_repository.dart    # abstract
│   └── usecases/
│       ├── create_debt_usecase.dart
│       ├── get_debts_usecase.dart
│       └── add_payment_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── debt_bloc.dart
    │   ├── debt_event.dart
    │   └── debt_state.dart
    ├── pages/
    │   ├── debt_list_page.dart
    │   ├── debt_detail_page.dart
    │   └── create_debt_page.dart
    └── widgets/
        ├── debt_card.dart
        └── debt_status_badge.dart
```

---

## State Management: BLoC Pattern

### Bloc structure
```dart
// Events — foydalanuvchi nima qildi
abstract class DebtEvent {}
class LoadDebts extends DebtEvent { final DebtFilter filter; }
class CreateDebt extends DebtEvent { final CreateDebtDto dto; }
class AddPayment extends DebtEvent { final String debtId; final PaymentDto dto; }
class RefreshDebts extends DebtEvent {}

// States — UI qanday ko'rinadi
abstract class DebtState {}
class DebtInitial extends DebtState {}
class DebtLoading extends DebtState {}
class DebtLoaded extends DebtState {
  final List<Debt> debts;
  final DebtStats stats;
  final bool hasMore;
}
class DebtError extends DebtState { final String message; }
class DebtCreating extends DebtState {}
class DebtCreated extends DebtState { final Debt debt; }
```

### Rules
- Bloc da UI logic yo'q — faqat usecase chaqiradi
- UseCase da business logic — bloc va repository orasida
- Repository da data source tanlovi (remote vs local)
- Har bir page o'zining BlocProvider ga wrap qilinadi

---

## Navigation: go_router

```dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isLoggedIn = context.read<AuthBloc>().state is Authenticated;
    if (!isLoggedIn) return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_,__) => LoginPage()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (_,__) => DashboardPage()),
        GoRoute(
          path: '/debts',
          builder: (_,__) => DebtListPage(),
          routes: [
            GoRoute(path: ':id', builder: (_,s) => DebtDetailPage(id: s.pathParameters['id']!)),
            GoRoute(path: 'create', builder: (_,__) => CreateDebtPage()),
          ],
        ),
        GoRoute(path: '/customers', builder: (_,__) => CustomerListPage()),
        GoRoute(path: '/payments', builder: (_,__) => PaymentListPage()),
        GoRoute(path: '/reports', builder: (_,__) => ReportsPage()),
        GoRoute(path: '/audit', builder: (_,__) => AuditLogPage()),
      ],
    ),
  ],
);
```

---

## API Layer: Dio + Retrofit

```dart
// Base setup
class DioClient {
  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 30),
    ));
    dio.interceptors.addAll([
      AuthInterceptor(),     // JWT attach + auto refresh
      TenantInterceptor(),   // X-Tenant-ID header
      LogInterceptor(),      // debug only
    ]);
    return dio;
  }
}

// Retrofit — type-safe API
@RestApi()
abstract class DebtApiService {
  factory DebtApiService(Dio dio) = _DebtApiService;

  @GET('/debts')
  Future<PaginatedResponse<DebtModel>> getDebts(@Queries() DebtFilter filter);

  @POST('/debts')
  Future<DebtModel> createDebt(@Body() CreateDebtDto dto);

  @GET('/debts/{id}')
  Future<DebtModel> getDebt(@Path('id') String id);

  @PATCH('/debts/{id}')
  Future<DebtModel> updateDebt(@Path('id') String id, @Body() UpdateDebtDto dto);

  @POST('/payments')
  Future<PaymentModel> addPayment(@Body() CreatePaymentDto dto);
}
```

### Auth Interceptor (JWT auto-refresh)
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(options, handler) {
    final token = tokenStorage.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(error, handler) async {
    if (error.response?.statusCode == 401) {
      // refresh token → retry
      final newToken = await authService.refresh();
      error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(error.requestOptions);
      handler.resolve(response);
    } else {
      handler.next(error);
    }
  }
}
```

---

## Local Database: Drift (Offline)

```dart
// Local tables
class LocalDebts extends Table {
  TextColumn get id => text()();
  TextColumn get debtNumber => text()();
  TextColumn get customerId => text()();
  RealColumn get totalAmount => real()();
  RealColumn get paidAmount => real()();
  TextColumn get status => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get rawJson => text()();        // full JSON cached
  BoolColumn get pendingSync => boolean().withDefault(Const(false))();
  TextColumn get pendingAction => text().nullable()(); // CREATE/UPDATE/DELETE
  DateTimeColumn get cachedAt => dateTime()();
}

class LocalPendingActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();     // debt/payment
  TextColumn get action => text()();         // CREATE/UPDATE/DELETE
  TextColumn get payload => text()();        // JSON
  IntColumn get retryCount => integer().withDefault(Const(0))();
  DateTimeColumn get createdAt => dateTime()();
}
```

---

## Offline Sync Strategy

```dart
class SyncManager {
  // Network restored → bu method ishga tushadi
  Future<void> syncPending() async {
    final actions = await db.getPendingActions();
    for (final action in actions) {
      try {
        await _processAction(action);
        await db.deletePendingAction(action.id);
      } catch (e) {
        await db.incrementRetry(action.id);
        if (action.retryCount >= 3) await _flagForManualReview(action);
      }
    }
  }
}

// Offline da yoziladigan action
Future<void> createDebt(CreateDebtDto dto) async {
  final localId = const Uuid().v4();
  // 1. Local DB ga yoz
  await db.insertDebt(LocalDebt(id: localId, pendingSync: true, ...));
  // 2. Queue ga qo'sh
  await db.insertPendingAction(PendingAction(
    entityType: 'debt',
    action: 'CREATE',
    payload: jsonEncode(dto.toJson()),
  ));
  // 3. UI ga darhol ko'rsat (optimistic UI)
}
```

### Offline available
- Debt yaratish ✓
- Payment qabul qilish ✓
- Customer ko'rish (cached) ✓
- Debt ro'yxati (cached) ✓

### Online only
- Reports export ✗
- Audit log ✗
- User management ✗
- Real-time dashboard ✗

---

## RBAC — UI Level

```dart
// Auth state da role saqlanadi
class UserSession {
  final String userId;
  final String role;        // owner/manager/seller/accountant
  final String branchId;
  final List<String> permissions;
}

// Permission check widget
class PermissionGate extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final session = context.read<AuthBloc>().session;
    if (session.permissions.contains(permission)) return child;
    return fallback ?? SizedBox.shrink();
  }
}

// Ishlatish
PermissionGate(
  permission: 'debt:delete',
  child: DeleteButton(onTap: () => bloc.add(DeleteDebt(id))),
)
```

### Role-based navigation
```dart
// Seller — faqat 3 tab ko'radi
// Manager — 4 tab
// Owner — hammasi
List<BottomNavItem> getNavItems(String role) {
  return switch(role) {
    'seller'     => [debts, payments, customers],
    'manager'    => [dashboard, debts, payments, customers],
    'accountant' => [dashboard, reports, audit],
    _            => [dashboard, debts, payments, customers, reports, audit, settings],
  };
}
```

---

## UI/UX Rules

### Design principles
- Katta tugmalar (min 48px height) — bozor sharoitida qulay
- Minimal text input — dropdown va scanner afzal
- Offline indicator — har doim ko'rinadi
- Swipe actions — debt card da: to'lash, tahrirlash

### Color system
```dart
class AppColors {
  // Status colors
  static const active   = Color(0xFF1D9E75);  // teal
  static const overdue  = Color(0xFFE24B4A);  // red
  static const partial  = Color(0xFFEF9F27);  // amber
  static const paid     = Color(0xFF639922);  // green

  // Role colors (avatar background)
  static const owner     = Color(0xFF1D9E75);
  static const manager   = Color(0xFF378ADD);
  static const seller    = Color(0xFF7F77DD);
  static const accountant = Color(0xFFD85A30);
}
```

### Currency formatter
```dart
// Har doim shu formatter ishlatiladi
String formatAmount(double amount) {
  return NumberFormat('#,##0', 'uz').format(amount) + ' UZS';
  // → "1,250,000 UZS"
}
```

### Date formatter
```dart
String formatDate(DateTime date) => DateFormat('dd.MM.yyyy').format(date);
String formatDateTime(DateTime dt) => DateFormat('dd.MM.yyyy HH:mm').format(dt);
String formatRelative(DateTime date) {
  final diff = date.difference(DateTime.now()).inDays;
  if (diff == 0) return 'Bugun';
  if (diff == 1) return 'Ertaga';
  if (diff == -1) return 'Kecha';
  if (diff < 0) return '${diff.abs()} kun oldin';
  return '$diff kun qoldi';
}
```

---

## Key Widgets (Shared)

```dart
// DebtCard — asosiy list item
DebtCard({
  required Debt debt,
  required VoidCallback onTap,
  VoidCallback? onPayTap,
})

// StatusBadge
StatusBadge(status: debt.status)   // active/paid/overdue/partial

// AmountDisplay — ranglar bilan
AmountDisplay(amount: 1250000, type: AmountType.debt)

// CustomerAvatar — initials
CustomerAvatar(name: 'Alisher Karimov', size: 40)

// OfflineBanner — offline bo'lsa ko'rinadi
OfflineBanner()

// ConfirmDialog — destructive actions uchun
ConfirmDialog(
  title: 'Qarzni o\'chirish',
  message: 'Bu amalni qaytarib bo\'lmaydi',
  onConfirm: () {},
)

// LoadMoreList — pagination
LoadMoreList<Debt>(
  items: debts,
  onLoadMore: () => bloc.add(LoadMoreDebts()),
  itemBuilder: (debt) => DebtCard(debt: debt),
)
```

---

## Notification Handling

```dart
// Firebase setup
class NotificationService {
  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    // Background tap → navigate
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });
  }

  void _handleNavigation(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'debt_overdue':
        router.push('/debts/${data['debt_id']}');
      case 'payment_received':
        router.push('/debts/${data['debt_id']}');
      case 'suspicious_activity':
        router.push('/audit');
    }
  }
}
```

---

## Error Handling

```dart
// API result wrapper — exception emas
sealed class ApiResult<T> {
  const factory ApiResult.success(T data) = Success;
  const factory ApiResult.failure(AppError error) = Failure;
}

// Error types
enum AppError {
  network,        // internet yo'q
  unauthorized,   // token expired
  forbidden,      // permission yo'q
  notFound,
  serverError,
  unknown,
}

// UI da
result.when(
  success: (data) => bloc.emit(DebtLoaded(data)),
  failure: (error) => switch(error) {
    AppError.network    => bloc.emit(DebtError('Internet yo\'q')),
    AppError.forbidden  => bloc.emit(DebtError('Ruxsat yo\'q')),
    _                   => bloc.emit(DebtError('Xatolik yuz berdi')),
  },
);
```

---

## Performance Rules

- List da `const` constructor — har doim
- Image caching: `cached_network_image`
- Pagination: 20 item per page
- Heavy computation → `compute()` isolate
- `ListView.builder` — `ListView` emas
- Bloc `buildWhen` — keraksiz rebuild oldini oladi

```dart
BlocBuilder<DebtBloc, DebtState>(
  buildWhen: (prev, curr) => prev.debts != curr.debts, // faqat list o'zgarganda
  builder: (context, state) => DebtList(debts: state.debts),
)
```

---

## Testing Strategy

```
unit/
├── usecases/         # business logic tests
├── repositories/     # mock API tests
└── blocs/            # bloc tests (bloc_test package)

widget/
├── debt_card_test.dart
└── create_debt_page_test.dart

integration/
└── debt_flow_test.dart   # create → payment → close
```

---

## Build & Flavors

```
Flutter flavors:
├── development   → dev API, debug tools
├── staging       → staging API, Sentry
└── production    → prod API, no debug
```

```bash
# Build commands
flutter run --flavor development -t lib/main_dev.dart
flutter build apk --flavor production -t lib/main_prod.dart
flutter build ipa --flavor production -t lib/main_prod.dart
```

---

## Antigravity Agent Rules (Flutter)

### Code generation rules
- Har bir feature: `data → domain → presentation` tartibida
- Model da faqat `fromJson/toJson` — business logic yo'q
- Entity da faqat pure Dart — Flutter import yo'q
- UseCase da faqat bir responsibility (Single Responsibility)
- Bloc da `emit` faqat try/catch ichida

### Naming rules
```
Pages:    DebtListPage, CreateDebtPage
Blocs:    DebtBloc, PaymentBloc
Events:   LoadDebts, CreateDebt, AddPayment
States:   DebtLoaded, DebtLoading, DebtError
Models:   DebtModel (JSON), Debt (Entity)
Widgets:  DebtCard, StatusBadge (noun, not verb)
```

### Import rules
- `domain` layer — faqat pure dart import
- `data` layer — dio, drift, models
- `presentation` — flutter, bloc, widgets
- Cross-feature import yo'q — faqat shared/ dan

### Amount rules
- `double` emas — `int` (tiyin da saqlash) yoki `Decimal` package
- Display da har doim `formatAmount()` ishlatiladi
- API ga `int` (so'm × 100) yuboriladi, display da `/100`

### Security rules
- JWT → `flutter_secure_storage` (SharedPreferences emas)
- PIN → bcrypt hash, secure storage da
- Sensitive data → memory cache da 15 daqiqadan ko'p emas
- Screenshot → production da `FLAG_SECURE` yoqiladi
