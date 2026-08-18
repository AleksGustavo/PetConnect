import 'package:flutter/material.dart';

/// Placeholder — lista de pets do tutor (RF11), criar pet e configurações
/// de conta entram em uma próxima etapa.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pets')),
      body: const Center(child: Text('Lista de pets — em breve')),
    );
  }
}
