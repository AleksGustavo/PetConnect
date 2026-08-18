import 'package:flutter/material.dart';

/// Paleta extraída do layout de login enviado (tons de marrom/creme,
/// remetendo a pelagem de cachorro/gato). Único tema por enquanto —
/// sem modo escuro, já que não foi pedido.
abstract final class AppColors {
  static const Color brandDark = Color(0xFF3E2415);
  static const Color brandMedium = Color(0xFF5C3A24);
  static const Color brandLight = Color(0xFF7A5137);

  static const Color background = Color(0xFFFBEADD);
  static const Color surface = Color(0xFFFFF8F0);

  static const Color textOnBrand = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3E2415);
  static const Color textMuted = Color(0xFF9C7B5F);

  static const Color error = Color(0xFFB3261E);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandDark, brandLight],
  );
}
