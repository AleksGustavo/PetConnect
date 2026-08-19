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

  testWidgets('cadastro -> home -> logout -> login -> senha errada', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PetConnectApp()));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget, reason: 'deveria abrir na tela de login');

    await tester.tap(find.text('Cadastre-se'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget, reason: 'deveria navegar para o cadastro');

    final cadastroFields = find.byType(TextFormField);
    expect(cadastroFields, findsNWidgets(6));
    await tester.enterText(cadastroFields.at(0), testNome); // nome
    await tester.enterText(cadastroFields.at(1), testEmail); // e-mail
    await tester.enterText(cadastroFields.at(2), '19991562584'); // telefone

    // Nascimento é somente leitura (preenchido via showDatePicker).
    await tester.tap(cadastroFields.at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${DateTime.now().day}'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(cadastroFields.at(4), testSenha); // senha
    await tester.enterText(cadastroFields.at(5), testSenha); // confirmar senha

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'CRIAR CONTA'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Meus pets'), findsOneWidget, reason: 'cadastro deveria levar direto para a Home');
    expect(find.textContaining('Bem-vindo, $testNome'), findsOneWidget,
        reason: 'Home deveria mostrar o nome do usuário recém-cadastrado');
    expect(find.text(testEmail), findsOneWidget, reason: 'Home deveria mostrar o e-mail do usuário');

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Login'), findsOneWidget, reason: 'logout deveria voltar para a tela de login');

    final loginFields = find.byType(TextField);
    expect(loginFields, findsNWidgets(2));
    await tester.enterText(loginFields.at(0), testEmail);
    await tester.enterText(loginFields.at(1), testSenha);
    await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Meus pets'), findsOneWidget, reason: 'login com credenciais corretas deveria voltar para a Home');

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle(const Duration(seconds: 2));

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
