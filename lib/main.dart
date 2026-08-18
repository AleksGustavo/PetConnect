import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // TODO(firebase): Firebase.initializeApp() aqui, com firebase_options.dart
  // gerado por `flutterfire configure` — ainda não configurado.
  runApp(const ProviderScope(child: PetConnectApp()));
}
