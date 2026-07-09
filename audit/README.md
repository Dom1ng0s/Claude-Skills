# audit

Audita código de frontend ou backend procurando bugs, falhas de segurança e code smells. Reporta os achados com o cenário de falha concreto e uma solução, mas não altera nada a menos que você peça.

## Instalação

```bash
ln -s /home/Dom1ng0s/dev/Skills/audit ~/.claude/skills/audit
```

Chame com `/audit` no Claude Code.

## Uso

```
/audit
```

Sem argumento, audita só o que mudou no git (o diff contra o upstream, ou contra o commit anterior). Para auditar um diretório específico:

```
/audit src/services/
```

A skill nunca lê o repositório inteiro. Ela usa busca para localizar padrões suspeitos e lê só os arquivos que os contêm.

## O que ela procura

- **Backend:** injeção, gestão fraca de JWT ou sessão, falta de sanitização, queries ineficientes (N+1, ausência de índice), tratamento de erro ausente e violações de arquitetura.
- **Frontend:** renderizações desnecessárias, estado acoplado à UI, requisições assíncronas sem tratamento de erro ou loading, componentes complexos demais.
- **Clean code:** funções longas, duplicação, nomes ruins, código difícil de testar.

## Verificação antes de reportar

Cada achado passa por um filtro antes de entrar no relatório. A skill lê a função inteira, checa os callers para descartar falso positivo (se já existe uma proteção upstream, não é achado) e escreve o cenário de falha concreto (entrada X leva a comportamento errado Y). Achado sem cenário de falha não entra.

## Formato do relatório

No máximo dez achados, ordenados por severidade (Crítica, Alta, Média, Baixa). Cada um traz o arquivo e a linha, a severidade, o problema com o cenário de falha, e a solução recomendada com um bloco de código. Se não houver nada relevante, a skill diz isso em uma linha em vez de inventar achados para preencher.

## Demo

![Demo do /audit](demo.gif)

> Rodando `/audit` contra um app Flask real (`sistema_gado`): 3 achados, nada crítico, nada alterado.
