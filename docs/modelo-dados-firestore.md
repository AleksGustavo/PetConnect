# Modelo de Dados — Firestore (proposta inicial)

> ⚠️ **A confirmar**: o usuário mencionou já ter uma modelagem de banco pronta que quer reaproveitar, mas ainda não foi compartilhada. O que segue é uma proposta de trabalho, alinhada aos requisitos funcionais, para não bloquear o início do projeto — deve ser reconciliada com a estrutura real assim que ela for compartilhada.

## Coleções

### `users/{uid}`
Documento por tutor, com o mesmo ID do usuário no Firebase Auth (`uid`).

```json
{
  "name": "string",
  "email": "string",
  "phone": "string | null",
  "photoUrl": "string | null",
  "createdAt": "timestamp"
}
```

### `pets/{petId}`
`petId` gerado automaticamente pelo Firestore (string aleatória — não sequencial, importante para a segurança do QR code).

```json
{
  "tutorId": "string (uid do tutor)",
  "name": "string",
  "species": "string",
  "breed": "string",
  "birthDate": "timestamp",
  "photoUrl": "string | null",
  "qrCodeId": "string",
  "publicContact": {
    "showPhone": "boolean",
    "message": "string | null"
  },
  "createdAt": "timestamp"
}
```

`qrCodeId` pode ser igual a `petId` ou um valor separado (útil se quisermos suportar "regenerar QR code" sem trocar o ID do pet — nesse caso, o `qrCodeId` muda, mas o `petId` permanece; a Cloud Function pública resolve por `qrCodeId`, não por `petId`, e valida se ele ainda é o vigente).

### `pets/{petId}/vaccines/{vaccineId}`

```json
{
  "name": "string",
  "appliedAt": "timestamp",
  "nextDoseAt": "timestamp | null",
  "vet": "string | null",
  "notes": "string | null"
}
```

### `pets/{petId}/medicalHistory/{recordId}`

```json
{
  "date": "timestamp",
  "description": "string",
  "vet": "string | null",
  "attachmentUrls": ["string"]
}
```

### `pets/{petId}/appointments/{appointmentId}`

```json
{
  "date": "timestamp",
  "vetName": "string",
  "reason": "string",
  "status": "scheduled | done | canceled"
}
```

## Índices sugeridos

- `pets`: índice composto em `tutorId` (para listar os pets de um tutor rapidamente — a query mais comum do app).
- Subcoleções (`vaccines`, `medicalHistory`, `appointments`): ordenação por `date`/`appliedAt` já é suportada nativamente por serem subcoleções pequenas por pet, sem necessidade de índice composto adicional na maioria dos casos.

## Storage (fotos)

Fotos de pet e do tutor ficam no **Firebase Storage**, não no Firestore (que não é feito para blobs grandes). Caminho sugerido: `pets/{petId}/photo.jpg`, `users/{uid}/photo.jpg`. A URL resultante é o que se salva em `photoUrl` nos documentos acima.

## Pontos a alinhar quando a modelagem existente do usuário for compartilhada

- Nomes de coleções/campos podem já estar definidos diferente do que está aqui.
- Verificar se o usuário já tem uma estratégia própria para a página pública do QR code (campo específico, coleção separada, etc.).
- Verificar se já existem dados de exemplo/seed que precisam ser importados.
