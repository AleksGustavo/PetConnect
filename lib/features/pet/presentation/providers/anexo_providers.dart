import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cloudinary_anexo_repository.dart';
import '../../domain/anexo_repository.dart';

/// Upload/remoção de arquivos — usado para anexos de histórico médico
/// (RF24) e fotos de perfil (pet e tutor). Implementado via Cloudinary (ver
/// core/config/cloudinary_config.dart), não Firebase Storage: o Storage
/// passou a exigir o plano pago (Blaze) no projeto Firebase real.
final anexoRepositoryProvider = Provider<AnexoRepository>((ref) {
  return CloudinaryAnexoRepository();
});
