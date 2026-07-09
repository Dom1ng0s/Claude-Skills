# Skills

Minhas skills do Claude Code. Uma pasta por skill, cada uma com um `SKILL.md`.

## Skills

- `audit` - audita código de frontend ou backend procurando bugs, falhas de segurança e code smells. Reporta, não corrige. Aceita um diretório como argumento; sem argumento, audita só o que mudou no git.

## Instalando

Copie (ou linke) a pasta da skill para `~/.claude/skills/`:

```bash
ln -s "$PWD/audit" ~/.claude/skills/audit
```

Depois é só chamar `/audit` no Claude Code.

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
