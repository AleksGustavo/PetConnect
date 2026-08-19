import 'package:firebase_core/firebase_core.dart';

/// Traduz uma falha de upload (Firebase Storage) para uma mensagem que
/// ajuda a diferenciar "sem permissão" (Storage Security Rules ainda não
/// liberam escrita, ou o bucket nunca foi ativado no Console) de outras
/// falhas — o retorno genérico do Storage sozinho não deixa isso claro.
String describirErroUpload(Object error, {String item = 'o arquivo'}) {
  if (error is FirebaseException &&
      (error.code == 'unauthorized' || error.code == 'permission-denied')) {
    return 'Sem permissão para enviar $item. Verifique as regras de segurança do Firebase Storage '
        'no Console (e se o Storage está ativado para este projeto).';
  }
  return 'Não foi possível enviar $item. Tente novamente.';
}
