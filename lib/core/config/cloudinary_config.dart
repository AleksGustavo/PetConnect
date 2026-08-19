/// Credenciais do Cloudinary, usadas para upload de fotos (pet, tutor) e
/// anexos do histórico médico (RF24) — substituto do Firebase Storage, que
/// passou a exigir o plano pago (Blaze) no projeto Firebase real.
///
/// Como preencher:
/// 1. Crie uma conta gratuita em https://cloudinary.com (não pede cartão).
/// 2. No Dashboard, copie o "Cloud name" e cole em [cloudinaryCloudName].
/// 3. Vá em Settings → Upload → Upload presets → Add upload preset, crie um
///    preset com "Signing Mode" = "Unsigned", salve e cole o nome dele em
///    [cloudinaryUploadPreset].
///
/// Cloud name e upload preset "unsigned" não são segredos — é o uso
/// pretendido pelo Cloudinary para apps client-side sem backend próprio
/// (só permitem upload, não dão acesso de gerência da conta).
const cloudinaryCloudName = 'SEU_CLOUD_NAME_AQUI';
const cloudinaryUploadPreset = 'SEU_UPLOAD_PRESET_AQUI';
