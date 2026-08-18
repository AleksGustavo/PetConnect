# Como contribuir — PetConnect

Fluxo de trabalho para times/múltiplas pessoas colaborando no mesmo repositório.

## Branches

- `main` — sempre estável, reflete o que está (ou pode ir) para produção. **Nunca commitar direto nela.**
- `feature/<nome-curto>` — nova funcionalidade (ex: `feature/cadastro-vacina`).
- `fix/<nome-curto>` — correção de bug (ex: `fix/qrcode-pet-excluido`).
- `docs/<nome-curto>` — mudanças só de documentação.
- `chore/<nome-curto>` — manutenção (deps, configuração, CI).

Toda branch nasce de `main` atualizada:

```bash
git checkout main
git pull
git checkout -b feature/nome-da-sua-feature
```

## Commits — Conventional Commits

Formato: `tipo: descrição breve no imperativo`.

| Tipo | Quando usar |
|---|---|
| `feat` | nova funcionalidade |
| `fix` | correção de bug |
| `docs` | documentação |
| `test` | testes (adicionar/ajustar) |
| `refactor` | mudança de código sem alterar comportamento |
| `chore` | build, dependências, configuração |

Exemplos:
```
feat: adiciona geração de QR code no perfil do pet
fix: corrige alerta de vacina vencida com fuso horário errado
docs: documenta modelo de dados do Firestore
```

## Pull Requests

1. Toda mudança em `main` passa por PR — sem exceção, mesmo para quem tem permissão de push direto.
2. Título do PR segue a mesma convenção dos commits.
3. Descrição do PR deve referenciar o(s) `RFxx`/`RNFxx` relacionados (ver `docs/requisitos-funcionais.md`) e, se aplicável, os casos de teste (`CTxx`) cobertos.
4. **Pelo menos 1 aprovação** de outra pessoa antes do merge (configurar em Settings → Branches → Branch protection rules no GitHub).
5. CI (quando configurado) deve passar: `flutter analyze` + `flutter test` sem falhas.
6. Preferência por **squash merge**, mantendo o histórico de `main` limpo (um commit por PR).

### Checklist antes de abrir o PR

- [ ] `flutter analyze` sem warnings novos
- [ ] `flutter test` passando
- [ ] Segue a estrutura de pastas de `docs/arquitetura.md` (feature-first)
- [ ] Se mudou regra de negócio, tem teste correspondente
- [ ] Se tocou em regras de acesso a dados, revisado contra `docs/seguranca.md`

## Configuração recomendada no GitHub (a fazer nas configurações do repositório)

- **Branch protection** em `main`: exigir PR, exigir pelo menos 1 review, exigir que a branch esteja atualizada antes do merge.
- **Templates de Issue/PR** (podem ser adicionados depois em `.github/`).
- Rodar `flutter analyze`/`flutter test` como GitHub Actions em cada PR (a configurar quando o projeto tiver testes suficientes para valer a pena).
