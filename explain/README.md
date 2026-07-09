# explain

Analisa o código-fonte e gera um documento Markdown com a arquitetura do projeto: o que ele faz, como os módulos se conectam, quais rotas expõe e quais arquivos concentram a lógica de negócio.

Serve para entrar rápido num projeto desconhecido ou para deixar uma visão geral versionada no repositório. Roda na raiz ou numa subpasta específica.

## Instalação

Skills deste repositório são pastas com um `SKILL.md`. O Claude Code descobre a skill pelo `name` do frontmatter. Para deixá-la disponível em qualquer projeto, aponte um link em `~/.claude/skills/`:

```bash
ln -s /home/Dom1ng0s/dev/Skills/explain ~/.claude/skills/explain
```

Depois é só chamar `/explain` no Claude Code.

## Uso

```
/explain
```

Analisa a raiz do projeto atual e escreve `ARCHITECTURE.md`.

```
/explain src/services/
```

Analisa apenas `src/services/` e escreve `services_EXPLANATION.md`.

Se o caminho passado não existir, a skill avisa e para sem gerar nada.

## O que fica de fora

Pastas e arquivos que só gastam contexto são ignorados: `venv/`, `.venv/`, `env/`, `node_modules/`, `.git/`, `__pycache__/`, `.pytest_cache/`, `.pyc`, bancos (`.sqlite`, `.db`) e estáticos (imagens, vídeos).

## Estrutura do arquivo gerado

O documento tem quatro seções fixas:

- **Resumo do Projeto:** um parágrafo dizendo o que o código faz.
- **Arquitetura e Fluxo:** como os módulos principais interagem.
- **Rotas e Endpoints Principais:** tabela das rotas detectadas, com método HTTP (útil em Flask e APIs).
- **Mapa de Arquivos Críticos:** tabela "Arquivo | Propósito", só com a lógica de negócio, sem boilerplate.

## Exemplo de saída

```markdown
## Resumo do Projeto
API REST em Flask para gestão de tarefas. Expõe endpoints CRUD sobre tarefas
persistidas em SQLite via SQLAlchemy, com autenticação por token JWT.

## Arquitetura e Fluxo
O ponto de entrada `app.py` cria a aplicação Flask e registra os blueprints.
Uma requisição passa por `routes/tasks.py` (valida entrada e token), depois
`services/task_service.py` (regra de negócio) e por fim `models/task.py` (ORM/DB).

## Rotas e Endpoints Principais
| Método | Rota          | Descrição                |
|--------|---------------|--------------------------|
| POST   | /auth/login   | Autentica e retorna JWT  |
| GET    | /tasks        | Lista tarefas do usuário |
| POST   | /tasks        | Cria uma tarefa          |
| PUT    | /tasks/<id>   | Atualiza uma tarefa      |
| DELETE | /tasks/<id>   | Remove uma tarefa        |

## Mapa de Arquivos Críticos
| Arquivo                    | Propósito                          |
|----------------------------|------------------------------------|
| `app.py`                   | Cria a app e registra blueprints   |
| `routes/tasks.py`          | Endpoints, validação e auth        |
| `services/task_service.py` | Regras de negócio das tarefas      |
| `models/task.py`           | Modelo ORM da tarefa               |
| `auth/jwt.py`              | Geração e verificação de tokens    |
```
