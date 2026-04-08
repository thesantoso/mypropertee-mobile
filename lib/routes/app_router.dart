import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/domain/auth_state.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/properties/presentation/screens/properties_screen.dart';
import '../features/properties/presentation/screens/property_detail_screen.dart';
import '../features/units/presentation/screens/units_screen.dart';
import '../features/units/presentation/screens/unit_detail_screen.dart';
import '../features/invoices/presentation/screens/invoices_screen.dart';
import '../features/invoices/presentation/screens/invoice_detail_screen.dart';
import '../features/payments/presentation/screens/payments_screen.dart';
import '../features/incidents/presentation/screens/incidents_screen.dart';
import '../features/incidents/presentation/screens/incident_detail_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../shared/widgets/main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return _buildRouter(authState);
});

GoRouter _buildRouter(AuthState authState) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isInitialOrLoading =
          authState.isInitial || authState.isLoading;
      final isAuthenticated = authState.isAuthenticated;

      if (isInitialOrLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (!isAuthenticated && location != AppRoutes.login) {
        return AppRoutes.login;
      }

      if (isAuthenticated &&
          (location == AppRoutes.login || location == AppRoutes.splash)) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.properties,
            builder: (context, state) => const PropertiesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PropertyDetailScreen(propertyId: id);
                },
                routes: [
                  GoRoute(
                    path: 'units',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return UnitsScreen(propertyId: id);
                    },
                    routes: [
                      GoRoute(
                        path: ':unitId',
                        builder: (context, state) {
                          final unitId = state.pathParameters['unitId']!;
                          return UnitDetailScreen(unitId: unitId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.invoices,
            builder: (context, state) => const InvoicesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InvoiceDetailScreen(invoiceId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.payments,
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.incidents,
            builder: (context, state) => const IncidentsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return IncidentDetailScreen(incidentId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String properties = '/properties';
  static const String invoices = '/invoices';
  static const String payments = '/payments';
  static const String incidents = '/incidents';
  static const String profile = '/profile';

  static String propertyDetail(String id) => '/properties/$id';
  static String propertyUnits(String id) => '/properties/$id/units';
  static String unitDetail(String propertyId, String unitId) =>
      '/properties/$propertyId/units/$unitId';
  static String invoiceDetail(String id) => '/invoices/$id';
  static String incidentDetail(String id) => '/incidents/$id';
}
