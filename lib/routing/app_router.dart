import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/cadastro_screen.dart';
import '../features/auth/presentation/screens/esqueci_senha_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/pet/domain/historico_medico.dart';
import '../features/pet/domain/pet.dart';
import '../features/pet/domain/vacina.dart';
import '../features/pet/presentation/screens/historico_form_screen.dart';
import '../features/pet/presentation/screens/historico_list_screen.dart';
import '../features/pet/presentation/screens/pet_detail_screen.dart';
import '../features/pet/presentation/screens/pet_form_screen.dart';
import '../features/pet/presentation/screens/vacina_form_screen.dart';
import '../features/pet/presentation/screens/vacina_list_screen.dart';
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
      GoRoute(
        path: '/pet/novo',
        builder: (context, state) => const PetFormScreen(),
      ),
      GoRoute(
        path: '/pet/:id',
        builder: (context, state) => PetDetailScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pet/:id/editar',
        builder: (context, state) => PetFormScreen(pet: state.extra as Pet?),
      ),
      GoRoute(
        path: '/pet/:id/vacinas',
        builder: (context, state) => VacinaListScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pet/:id/vacinas/nova',
        builder: (context, state) => VacinaFormScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pet/:id/vacinas/:vacinaId/editar',
        builder: (context, state) => VacinaFormScreen(
          petId: state.pathParameters['id']!,
          vacina: state.extra as Vacina?,
        ),
      ),
      GoRoute(
        path: '/pet/:id/historico',
        builder: (context, state) => HistoricoListScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pet/:id/historico/novo',
        builder: (context, state) => HistoricoFormScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pet/:id/historico/:historicoId/editar',
        builder: (context, state) => HistoricoFormScreen(
          petId: state.pathParameters['id']!,
          historico: state.extra as HistoricoMedico?,
        ),
      ),
    ],
  );
});
