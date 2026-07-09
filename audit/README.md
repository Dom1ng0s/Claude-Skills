# Claude Skills

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Python](https://img.shields.io/badge/python-100%25-3776AB)
![Skills](https://img.shields.io/badge/skills-7-brightgreen)

Skills para o [Claude Code](https://claude.com/claude-code) que automatizam auditoria, testes, documentação e checagem pré-deploy — direto no terminal, sem sair do fluxo.

Cada skill é uma pasta com um `SKILL.md` (as instruções que o Claude executa) e um `README.md` próprio (documentação de uso). A maioria não é um programa: é um prompt bem desenhado que faz o Claude usar as próprias ferramentas — ler arquivos, buscar padrões, editar código, rodar comandos. A exceção é a `brute-tester`, que roda um script Python isolado por ser um fuzzer ativo.

## Por que usar

- **Read-only por padrão.** A maioria das skills audita e reporta, não edita seu código sem você pedir.
- **Zero setup pesado.** É um symlink e pronto — nada de instalar dependências extras ou configurar CI.
- **Feitas pra rotina real:** rodar antes de um PR, antes de um deploy, ou quando você chega num código que não conhece.

## As skills

| Skill | O que faz |
|---|---|
| [`audit`](audit) | Audita frontend ou backend procurando bugs, falhas de segurança e code smells. Reporta cenário de falha e solução, não corrige. Sem argumento, olha só o diff do git. |
| [`explain`](explain) | Mapeia a arquitetura do código e gera `ARCHITECTURE.md` (ou `[pasta]_EXPLANATION.md` numa subpasta): resumo, fluxo, rotas e mapa de arquivos críticos. |
| [`sub-divider`](sub-divider) | Quebra um objetivo (texto ou `.md`) em subtarefas e guia o agente na execução, em série ou paralelo, mantendo o progresso num checklist. Pergunta o modo se você não passar. |
| [`auto-tester`](auto-tester) | Detecta a stack, gera testes com o runner nativo (pytest, Jest, `go test`), roda e conserta os testes até passarem. Para e avisa se achar bug real no seu código. |
| [`brute-tester`](brute-tester) | Fuzzer DAST para endpoints locais. Dispara payloads maliciosos e reporta as rotas que quebram. Só aceita alvos em localhost. Gera `BRUTE_TEST_REPORT.md`. |
| [`auto-readme`](auto-readme) | Read-only: analisa o projeto e gera um `README_GENERATED.md` de qualidade. Nunca lê `.env` reais. |
| [`pre-deploy-check`](pre-deploy-check) | Read-only e agnóstico de linguagem: checa flags de dev, segredos, dependências não declaradas e estado do git antes do deploy. Gera `PRE_DEPLOY_REPORT.md`. |

Cada pasta tem um README com instalação, uso e exemplos específicos.

## Instalando

Copie ou linke a pasta da skill para `~/.claude/skills/`:

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

## Contribuindo

Sugestões de skill, bugs ou melhorias: abra uma issue ou um PR. Se adicionar uma skill nova, siga o padrão de `SKILL.md` + `README.md` descrito acima.

## Licença

[MIT](LICENSE)

## Exemplo

Rodada real contra um app Flask de gestão de rebanho (`sistema_gado`):

```
/audit /home/Dom1ng0s/dev/sistema_gado
```

Trecho literal do relatório gerado (achado de maior severidade):

```markdown
### 1. Vazamento de detalhe de exceção interna na criação de conta
- **Arquivo:** `routes/auth.py:125`
- **Severidade:** ⚠️ Média
- **Problema:** No `except` do `novo_usuario`, a mensagem devolvida ao usuário é
  `mensagem = f"Erro ao criar conta: {e}"` e vai direto para o template. Cenário de
  falha concreto: uma falha de constraint do MySQL ou erro de conexão faz `str(e)`
  conter texto do driver / nomes de tabela/coluna, que é renderizado no formulário
  para um usuário anônimo (rota pública). Information disclosure.
```

O código já estava bem endurecido (SQL sempre parametrizado, isolamento por
`user_id`, CSRF, rate-limit): 3 achados reportados, nada crítico.