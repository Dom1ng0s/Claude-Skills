# pre-deploy-check

Analisa o repositório local antes de um deploy e aponta erros comuns e más práticas, independente da linguagem. É read-only: não altera código, não faz commit e não dispara deploy. Só lê e reporta.

O resultado sai em `PRE_DEPLOY_REPORT.md`.

## Instalação

```bash
ln -s /home/Dom1ng0s/dev/Skills/pre-deploy-check ~/.claude/skills/pre-deploy-check
```

Chame com `/pre-deploy-check` no Claude Code.

## Uso

```
/pre-deploy-check
```

Analisa o diretório atual. Para um subdiretório específico:

```
/pre-deploy-check ./services/api
```

## O que ela verifica

- **Stack:** detecta a linguagem e o framework pelos manifestos (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `pom.xml`).
- **Segurança e estado:** procura flags de dev ligadas no código (`DEBUG=true`, `NODE_ENV=development`, `FLASK_ENV=development`), servidores de teste e senhas em texto claro.
- **Dependências:** compara os imports do código com o manifesto da linguagem e avisa sobre dependências usadas mas não declaradas.
- **Scripts de produção:** confere se existe comando de build ou start de produção, e avisa quando a configuração aponta só para comandos de desenvolvimento como `npm run dev`.
- **Git:** roda `git status` para achar arquivos não rastreados ou mudanças não commitadas.

## Estrutura do relatório

O `PRE_DEPLOY_REPORT.md` tem três partes:

- **Resumo do Status:** "Pronto para Deploy" ou "Requer Atenção", com a linguagem principal detectada.
- **Checklist Detalhado:** tabela dos itens verificados, marcados com PASSOU, AVISO ou FALHOU.
- **Ações Recomendadas:** para cada falha, qual comando rodar ou o que mudar, adaptado à stack detectada.

## Exemplo

Rodada real contra um app Flask de gestão de rebanho (`sistema_gado`):

```
/pre-deploy-check /home/Dom1ng0s/dev/sistema_gado
```

Trecho literal do `PRE_DEPLOY_REPORT.md` gerado:

```markdown
## Resumo do Status
**Pronto para Deploy** — linguagem principal: **Python / Flask**. Nenhum item FALHOU;
1 AVISO (working tree com alterações não commitadas).

| Item | Status | Detalhe |
|------|--------|---------|
| Identificação da Stack | ✅ PASSOU | Python 3.10+ / Flask 3.1 (Dockerfile). Deploy Gunicorn. |
| Segurança e Estado | ✅ PASSOU | `app.run(debug=...)` é gated por env e só roda em `__main__`. |
| Verificação de Dependências | ✅ PASSOU | Todos os imports declarados em `requirements.txt`. |
| Estado do Git | ⚠️ AVISO | ` M .gitignore` e `?? DOCUMENTATION.md` não commitados. |
```
