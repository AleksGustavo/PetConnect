/// Traduz uma falha de upload (Cloudinary) para uma mensagem que ajuda a
/// diferenciar "configuração incompleta" (cloud name/upload preset ainda
/// não preenchidos em core/config/cloudinary_config.dart) de outras falhas.
String describirErroUpload(Object error, {String item = 'o arquivo'}) {
  final mensagem = error.toString();
  if (mensagem.contains('SEU_CLOUD_NAME_AQUI') ||
      mensagem.contains('SEU_UPLOAD_PRESET_AQUI') ||
      mensagem.contains('Upload preset not found') ||
      mensagem.contains('cloud_name')) {
    return 'Configuração do Cloudinary incompleta — confira cloudinaryCloudName e '
        'cloudinaryUploadPreset em lib/core/config/cloudinary_config.dart.';
  }
  return 'Não foi possível enviar $item. Verifique sua conexão e tente novamente.';
}
