import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_bloc.dart';
import '../../core/auth/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/debts/presentation/pages/debt_list_page.dart';
import '../../features/debts/presentation/pages/debt_detail_page.dart';
import '../../features/debts/presentation/pages/create_debt_page.dart';
import '../../features/payments/presentation/pages/payment_pages.dart';
import '../../features/payments/presentation/pages/create_payment_page.dart';
import '../../features/customers/presentation/pages/customer_pages.dart';
import '../../features/customers/presentation/pages/create_customer_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/register_owner_page.dart';
import '../../features/users/presentation/pages/user_list_page.dart';
import '../../features/users/presentation/pages/create_user_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/audit/presentation/pages/audit_logs_page.dart';
import '../../features/debts/presentation/pages/overdue_debts_page.dart';
import '../../shared/widgets/main_shell.dart';

/// App router — go_router konfiguratsiyasi
///
/// Auth guard + ShellRoute + bottom navigation
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // Auth guard
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthAuthenticated;
      final location = state.matchedLocation;
      final isPublicRoute = location == '/login' || location == '/register' || location == '/splash';

      // Hali tekshirilyapti -> splashga
      if (authState is AuthInitial || authState is AuthLoading) {
        if (location != '/splash') return '/splash';
        return null;
      }

      // Tekshirildi, kirmagan -> loginga (agar public page'da bo'lmasa)
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      // Kirdi, lekin public pageda turibdi -> dashboardga
      if (isLoggedIn && isPublicRoute) {
        return '/dashboard';
      }
      
      return null;
    },

    // Listen to auth changes
    refreshListenable: _AuthRefreshNotifier(authBloc),

    routes: [
      // Splash
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),

      // Auth
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterOwnerPage()),

      // Staff Management (Top-level protected route for Owner/Admin)
      GoRoute(
        path: '/users',
        builder: (_, __) => const UserListPage(),
        routes: [
          GoRoute(path: 'create', builder: (_, __) => const CreateUserPage()),
        ],
      ),

      // Reports & Audit (Protected)
      GoRoute(path: '/reports', builder: (_, __) => const ReportsPage()),
      GoRoute(path: '/audit', builder: (_, __) => const AuditLogsPage()),

      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            child: navigationShell,
          );
        },
        branches: [
          // Dashboard tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),

          // Debts tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/debts',
                builder: (_, __) => const DebtListPage(),
                routes: [
                  GoRoute(
                    path: 'overdue',
                    builder: (_, __) => const OverdueDebtsPage(),
                  ),
                  GoRoute(
                    path: 'create',
                    builder: (_, __) => const CreateDebtPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        DebtDetailPage(id: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),

          // Payments tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/payments',
                builder: (_, __) => const PaymentListPage(),
                routes: [
                  GoRoute(path: 'create', builder: (_, __) => const CreatePaymentPage()),
                ],
              ),
            ],
          ),

          // Customers tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                builder: (_, __) => const CustomerListPage(),
                routes: [
                  GoRoute(path: 'create', builder: (_, __) => const CreateCustomerPage()),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        CustomerDetailPage(id: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),

          // Settings tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Auth state o'zgarganda router ni refresh qilish
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}
