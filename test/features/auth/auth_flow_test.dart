// Teste manual de verificação, criado para validar o fluxo real de
// autenticação (cadastro -> home -> logout -> login -> senha errada)
// contra o projeto Firebase de verdade, rodando em Chrome headless via
// `flutter test --platform=chrome`. Não faz parte da suíte de CI ainda
// porque cria um usuário real no Firebase Auth a cada execução.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_connect/app.dart';
import 'package:pet_connect/firebase_options.dart';

void main() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testEmail = 'qa.petconnect.$timestamp@example.com';
  const testNome = 'QA PetConnect';
  const testPrimeiroNome = 'QA';
  const testSenha = 'senha123';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  });

  tearDownAll(() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).delete();
      await user.delete();
    }
  });

  Future<void> logout(WidgetTester tester) async {
    // Sair não fica mais num ícone na Home — é preciso entrar em
    // Configurações primeiro (mesmo fluxo do botão de voltar da Home).
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair da conta'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Sair'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  testWidgets('cadastro -> home -> logout -> login -> senha errada', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PetConnectApp()));
    await tester.pumpAndSettle();

    // Abre na splash (tempo mínimo de exibição de 2,5s) antes de decidir
    // entre login/Home — avança o relógio para além desse tempo.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget, reason: 'deveria abrir na tela de login');

    await tester.tap(find.text('Cadastre-se'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget, reason: 'deveria navegar para o cadastro');

    final cadastroFields = find.byType(TextFormField);
    expect(cadastroFields, findsNWidgets(5));
    await tester.enterText(cadastroFields.at(0), testNome); // nome
    await tester.enterText(cadastroFields.at(1), testEmail); // e-mail
    await tester.enterText(cadastroFields.at(2), '19991562584'); // telefone
    await tester.enterText(cadastroFields.at(3), testSenha); // senha
    await tester.enterText(cadastroFields.at(4), testSenha); // confirmar senha

    await tester.tap(find.widgetWithText(ElevatedButton, 'CRIAR CONTA'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Meus Pets'), findsOneWidget, reason: 'cadastro deveria levar direto para a Home');
    expect(find.textContaining('Olá, $testPrimeiroNome'), findsOneWidget,
        reason: 'Home deveria saudar o usuário recém-cadastrado pelo primeiro nome');

    await logout(tester);

    expect(find.text('Login'), findsOneWidget, reason: 'logout deveria voltar para a tela de login');

    final loginFields = find.byType(TextField);
    expect(loginFields, findsNWidgets(2));
    await tester.enterText(loginFields.at(0), testEmail);
    await tester.enterText(loginFields.at(1), testSenha);
    await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Meus Pets'), findsOneWidget,
        reason: 'login com credenciais corretas deveria voltar para a Home');

    await logout(tester);

    final loginFields2 = find.byType(TextField);
    await tester.enterText(loginFields2.at(0), testEmail);
    await tester.enterText(loginFields2.at(1), 'senhaErrada999');
    await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Login'), findsOneWidget, reason: 'senha errada não deveria navegar para a Home');
    expect(find.text('E-mail ou senha inválidos.'), findsOneWidget,
        reason: 'deveria mostrar a mensagem de erro genérica de credenciais inválidas');
  });
}
