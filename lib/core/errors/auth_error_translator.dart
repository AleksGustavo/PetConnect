/// Traduz códigos de erro do Firebase Auth para mensagens em português,
/// específicas o suficiente para orientar o usuário mas sem revelar se um
/// e-mail existe ou não na base (RNF08, ver docs/seguranca.md).
String translateAuthError(String code) {
  switch (code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'E-mail ou senha inválidos.';
    case 'email-already-in-use':
      return 'Já existe uma conta com este e-mail.';
    case 'weak-password':
      return 'A senha precisa ter pelo menos 6 caracteres.';
    case 'invalid-email':
      return 'E-mail inválido.';
    case 'network-request-failed':
      return 'Falha de conexão. Verifique sua internet.';
    case 'too-many-requests':
      return 'Muitas tentativas seguidas. Aguarde um pouco e tente de novo.';
    default:
      return 'Não foi possível completar a operação. Tente novamente.';
  }
}
