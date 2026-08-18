import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/cadastro_screen.dart';
import '../features/auth/presentation/screens/esqueci_senha_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/usuario/presentation/screens/home_screen.dart';

// TODO(auth): adicionar `redirect` baseado no estado de autenticação
// (RF06/RNF12) quando o UsuarioRepository + provider de sessão existirem —
// por ora as rotas são todas públicas para permitir navegar durante o
// desenvolvimento das telas.
final appRouter = GoRouter(
  initialLocation: '/login',
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
