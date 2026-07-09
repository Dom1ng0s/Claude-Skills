# sub-divider

Recebe um objetivo complexo (texto ou um arquivo de planejamento) e quebra em subtarefas atômicas, depois guia o agente na execução de cada uma, mantendo o progresso num checklist Markdown.

O estado vive no próprio arquivo `.md`: cada tarefa concluída vira `- [x]`, então dá para parar no meio e retomar depois sem perder o fio.

## Instalação

```bash
ln -s /home/Dom1ng0s/dev/Skills/sub-divider ~/.claude/skills/sub-divider
```

Chame com `/sub-divider` no Claude Code.

## Uso

A entrada pode ser um objetivo em texto ou o caminho de um plano `.md` já existente.

```
/sub-divider Adicionar autenticação JWT ao backend --mode serial
```

```
/sub-divider ./roadmap.md --mode parallel
```

O `--mode` aceita `serial` (uma tarefa após a outra) ou `parallel` (tarefas independentes ao mesmo tempo).

## O modo é obrigatório

Se você não passar `--mode`, a skill não adivinha. Ela para e pergunta antes de fazer qualquer coisa:

```
/sub-divider Migrar os testes para vitest
> "Como você deseja executar estas tarefas? (1) Série, uma após a outra,
>  ou (2) Paralelo, tarefas independentes simultaneamente?"
```

## Como funciona cada modo

**Serial:** o agente lê o `.md`, pega a primeira tarefa `- [ ]`, resolve com as ferramentas nativas (ler, editar código, rodar testes), marca `- [x]` e segue para a próxima. Se uma tarefa falhar, ele para e pede ajuda em vez de seguir por cima do erro.

**Paralelo:** o agente identifica quais tarefas não dependem umas das outras, dispara essas em background, acompanha até todas terminarem e só então atualiza o `.md`.

## Exemplo de checklist durante a execução (serial)

```markdown
# Plano de Execução: Adicionar autenticação JWT
Modo: serial

- [x] Instalar dependência jsonwebtoken
- [x] Criar middleware de verificação de token
- [ ] Proteger rotas /api/admin
  > Bloqueado: não encontrei o arquivo de rotas admin. Onde ficam?
- [ ] Adicionar testes do fluxo de login
```

## Exemplo com dependências (paralelo)

```markdown
# Plano de Execução: Preparar release
Modo: parallel

- [ ] Rodar linter
- [ ] Rodar suíte de testes
- [ ] Gerar build (depende de: 1, 2)
```

## Exemplo

Rodada real com um objetivo curto de verificação, em modo serial:

```
/sub-divider "Validar integridade das 7 skills do repositório" --mode serial
```

Trecho literal do `execution_plan.md` ao final da execução (todas concluídas):

```markdown
# Plano de Execução: Validar integridade das 7 skills do repositório
Modo: serial

- [x] Tarefa 1 — Confirmar que as 7 subpastas de skill existem
- [x] Tarefa 2 — Confirmar que cada subpasta tem `SKILL.md`
- [x] Tarefa 3 — Confirmar que cada `SKILL.md` tem frontmatter com `name:` e `description:`
- [x] Tarefa 4 — Confirmar que cada subpasta tem `README.md`

## Resultado
Todas as 4 subtarefas concluídas (7/7 skills íntegras). Nenhum bloqueio.
```
