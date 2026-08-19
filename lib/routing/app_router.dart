import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/cadastro_screen.dart';
import '../features/auth/presentation/screens/esqueci_senha_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/usuario/presentation/providers/auth_providers.dart';
import '../features/usuario/presentation/screens/home_screen.dart';

const _authRoutes = ['/login', '/cadastro', '/esqueci-senha'];

/// Recria o GoRouter sempre que o estado de autenticação muda, para que o
/// `redirect` abaixo reavalie com o valor mais recente (RF06, RNF12).
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = _authRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroScreen(),
      ),
      GoRoute(
        path: '/esqueci-senha',
        builder: (context, state) => const EsqueciSenhaScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
