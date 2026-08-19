import 'package:intl/intl.dart';

/// Formato de data usado em todo o banco existente (`dd/MM/yyyy`), ver
/// "Convenção de datas" em docs/modelo-dados-firestore.md.
final _formatter = DateFormat('dd/MM/yyyy');

DateTime? parseBrDate(String value) {
  if (value.isEmpty) return null;
  try {
    return _formatter.parseStrict(value);
  } catch (_) {
    return null;
  }
}

String formatBrDate(DateTime date) => _formatter.format(date);
