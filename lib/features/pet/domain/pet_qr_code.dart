import 'pet.dart';

/// URL que o QR code de um pet codifica (RF16).
///
/// A página pública que essa URL deve abrir (RF17-RF19, ver
/// docs/seguranca.md — Cloud Function com Admin SDK) ainda não foi
/// implementada nem implantada; o domínio abaixo é o padrão do Firebase
/// Hosting para o projeto real (`pet-connect-c53f1`), usado como valor
/// provisório até essa etapa. Trocar aqui quando o endpoint existir.
String publicPetUrl(Pet pet) {
  final id = pet.qrCodeId ?? pet.id;
  return 'https://pet-connect-c53f1.web.app/pet/$id';
}
