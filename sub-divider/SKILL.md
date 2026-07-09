---
name: sub-divider
description: Divide um objetivo em subtarefas atômicas num checklist .md e executa cada uma com suas ferramentas nativas, em série ou paralelo.
argument-hint: [objetivo ou caminho .md] [--mode serial|parallel]
---

# Contexto
Você é um orquestrador de tarefas. Recebe um objetivo (texto ou arquivo `.md` de planejamento), o quebra em subtarefas atômicas dentro de um checklist Markdown, e então **executa você mesmo** cada subtarefa com suas ferramentas nativas (Read, Edit, Bash, Grep, etc.).

O **estado vive no arquivo `.md`**: você edita o checklist marcando `- [x]` conforme conclui. Não escreva scripts para gerenciar estado — o próprio arquivo é o estado.

# Entrada
`$ARGUMENTS` contém o objetivo e, opcionalmente, `--mode serial|parallel`.

Determine a natureza da entrada (ignorando a flag `--mode`):
- **Texto em linguagem natural** → você mesmo criará o plano.
- **Caminho para um `.md`** → leia o arquivo com `Read` e use-o como plano.

# Passo 1 — Validação de modo (obrigatório)
Procure `--mode serial` ou `--mode parallel` em `$ARGUMENTS`.

Se o modo **não** estiver explícito, **NÃO deduza**. Pare e pergunte ao usuário (use a ferramenta de perguntar / AskUserQuestion, ou simplesmente encerre o turno com a pergunta e aguarde a resposta):

> "Como você deseja executar estas tarefas? (1) Série - uma após a outra, ou (2) Paralelo - tarefas independentes simultaneamente?"

Aguarde a resposta antes de qualquer outra coisa. Não planeje nem execute até ter o modo definido.

# Passo 2 — Planejamento
Grave o plano em `execution_plan.md` (na raiz do diretório de trabalho, salvo se a entrada já for um `.md` — nesse caso reutilize esse arquivo).

**Se a entrada for texto:** divida o objetivo em subtarefas atômicas (cada uma verificável e concluível de forma independente) e escreva o checklist:

```markdown
# Plano de Execução: <objetivo resumido>
Modo: serial | parallel

- [ ] Tarefa 1
- [ ] Tarefa 2
- [ ] Tarefa 3
```

**Se a entrada for um `.md`:** leia e valide se já está em formato de checklist acionável (`- [ ]` com tarefas atômicas). Se não estiver (texto corrido, tópicos vagos), reestruture para o formato acima, preservando a intenção. Mostre ao usuário o plano final antes de executar.

No modo paralelo, se houver dependências entre tarefas, anote-as: `- [ ] Tarefa 3 (depende de: 1)`.

# Passo 3 — Execução

## Modo SERIAL
Repita até não haver mais `- [ ]`:
1. Leia o `.md` com `Read`.
2. Encontre a **primeira** linha `- [ ]`.
3. Resolva essa subtarefa com suas ferramentas nativas (ler código, editar, rodar testes/comandos).
4. Se concluiu com sucesso, marque a linha como `- [x]` via `Edit` e siga para a próxima.
5. Se **falhar** (erro, ambiguidade, teste vermelho que não consegue resolver), **pare**: deixe a linha como `- [ ]`, registre o motivo abaixo dela (`  > Bloqueado: <motivo>`) e peça ajuda ao usuário. Não continue para as próximas.

## Modo PARALELO
1. Leia o `.md` e identifique as tarefas **independentes** (sem `depende de:` pendente).
2. Dispare-as concorrentemente. Escolha o mecanismo conforme a tarefa:
   - Subtarefas de raciocínio/código isoladas → um subagente por tarefa via a ferramenta `Agent` (subagent_type `general-purpose`), lançados na mesma resposta.
   - Comandos de shell longos e independentes → `Bash` com `run_in_background: true`.
3. Monitore de forma assíncrona até todos terminarem (releia saídas dos agentes / use `Monitor` ou `BashOutput` para os processos em background).
4. Conforme cada tarefa termina com sucesso, marque `- [x]` no `.md`. Tarefas que falharam ficam `- [ ]` com `  > Falhou: <motivo>`.
5. Quando as independentes concluírem, libere as que dependiam delas e repita. Se tudo que resta está bloqueado por uma falha, pare e reporte ao usuário.

# Entrega
O `.md` é o registro final de estado. Ao encerrar, responda com: caminho do `.md`, quantas tarefas concluídas / pendentes, e qualquer bloqueio.

Consulte `sub-divider/EXAMPLE.md` para exemplos de registro e invocação.
