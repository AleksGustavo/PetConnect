# PetConnect

App mobile para localização de pets desaparecidos. Cada tutor cadastra seus pets; cada pet tem um perfil com carteira de vacina, histórico médico e agendamento de consultas, além de um QR code que abre uma página pública com informações básicas do pet — para ajudar quem o encontrar a devolvê-lo ao tutor.

## Stack

- Flutter (Android + iOS)
- Firebase: Authentication, Firestore, Storage, Cloud Functions
- Riverpod (estado) + go_router (navegação)

## Documentação

Toda a documentação do projeto está em [`docs/`](docs/):

- [Requisitos funcionais](docs/requisitos-funcionais.md)
- [Requisitos não funcionais](docs/requisitos-nao-funcionais.md)
- [Casos de teste](docs/casos-de-teste.md)
- [Segurança](docs/seguranca.md)
- [Arquitetura](docs/arquitetura.md)
- [Modelo de dados (Firestore)](docs/modelo-dados-firestore.md)
- Diagramas: [caso de uso](docs/diagramas/caso-de-uso.md) · [sequência](docs/diagramas/sequencia.md) · [classes](docs/diagramas/classes.md)

Fluxo de contribuição (branches, commits, PRs): [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Como rodar

Pré-requisitos: [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado e configurado (`flutter doctor` sem erros bloqueantes).

```bash
flutter pub get
flutter run
```

Configuração do Firebase (arquivos de credenciais e `firebase_options.dart`) via [`flutterfire configure`](https://firebase.flutter.dev/docs/cli) — ainda não incluída neste repositório, pois depende do projeto Firebase ser criado.

## Status

Projeto em fase inicial: estrutura de pastas e documentação definidas, aguardando modelagem de dados Firestore existente do time e o layout visual para começar a implementação das telas.
