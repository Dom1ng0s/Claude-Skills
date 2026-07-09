# Skills

Minhas skills do Claude Code. Cada skill é uma pasta na raiz deste repositório, com um `SKILL.md` (as instruções que o Claude executa) e um `README.md` (a documentação para quem abre a pasta no GitHub).

A maioria delas não é um programa: é um prompt bem escrito que faz o Claude usar as próprias ferramentas (ler arquivos, buscar padrões, editar código, rodar comandos). A exceção é a `brute-tester`, que roda um script Python isolado por ser um fuzzer ativo.

## As skills

| Skill | O que faz |
|---|---|
| [`audit`](audit/) | Audita frontend ou backend procurando bugs, falhas de segurança e code smells. Reporta com cenário de falha e solução, não corrige. Sem argumento, olha só o diff do git. |
| [`explain`](explain/) | Mapeia a arquitetura do código e gera `ARCHITECTURE.md` (ou `[pasta]_EXPLANATION.md` numa subpasta): resumo, fluxo, rotas e mapa de arquivos críticos. |
| [`sub-divider`](sub-divider/) | Quebra um objetivo (texto ou `.md`) em subtarefas e guia o agente na execução, em série ou paralelo, mantendo o progresso num checklist. Pergunta o modo se você não passar. |
| [`auto-tester`](auto-tester/) | Detecta a stack, gera testes com o runner nativo (pytest, Jest, `go test`), roda e conserta os testes até passarem. Para e avisa se achar bug real no seu código. |
| [`brute-tester`](brute-tester/) | Fuzzer DAST para endpoints locais. Dispara payloads maliciosos e reporta as rotas que quebram. Só aceita alvos em localhost. Gera `BRUTE_TEST_REPORT.md`. |
| [`auto-readme`](auto-readme/) | Read-only: analisa o projeto e gera um `README_GENERATED.md` de qualidade. Nunca lê `.env` reais. |
| [`pre-deploy-check`](pre-deploy-check/) | Read-only e agnóstico de linguagem: checa flags de dev, segredos, dependências não declaradas e estado do git antes do deploy. Gera `PRE_DEPLOY_REPORT.md`. |

Cada pasta tem um README com instalação, uso e exemplos.

## Instalando

Copie ou aponte um link da pasta da skill para `~/.claude/skills/`:

```bash
ln -s "$PWD/audit" ~/.claude/skills/audit
```

Depois é só chamar `/audit` no Claude Code. O mesmo vale para as outras: linke a pasta e use `/nome-da-skill`.

## Criando uma skill nova

Crie a pasta e um `SKILL.md` com frontmatter:

```markdown
---
name: minha-skill
description: O que ela faz. É isso que o Claude lê pra decidir se usa a skill.
argument-hint: [argumento opcional]
---

Instruções aqui. `$ARGUMENTS` recebe o que foi passado na chamada.
```

Adicione um `README.md` na pasta para documentar uso e exemplos, e uma linha na tabela acima.
