# auto-tester

Detecta a stack do projeto, gera testes com o test runner que ele já usa, roda a suíte e corrige sozinho os testes que ele mesmo escreveu quando falham por erro de escrita. Se um teste expõe um bug de verdade no seu código, a skill para e avisa, sem mexer no código.

Foca em web-apps e webhooks (Flask, FastAPI, Express), mas funciona em qualquer projeto onde dê para identificar o runner.

## Instalação

```bash
ln -s /home/Dom1ng0s/dev/Skills/auto-tester ~/.claude/skills/auto-tester
```

Chame com `/auto-tester` no Claude Code.

## Uso

```
/auto-tester src/routes.py
/auto-tester src/routes.py --focus security
/auto-tester src/bot/webhook.py --focus bot-edge-cases
/auto-tester src/
```

O alvo pode ser um arquivo ou um diretório. Quando é um diretório, a skill prioriza os arquivos de maior risco (rotas, handlers de webhook, validação de entrada) em vez de testar tudo.

O `--focus` é opcional e define o tipo de teste:

- **standard:** caminho feliz e casos de borda (nulos, tipos errados, limites).
- **security:** payloads maliciosos para estressar a validação (injeção SQL, XSS simples, JSON malformado). O teste verifica que a API rejeita ou sanitiza, sem quebrar com 500.
- **bot-edge-cases:** resiliência do webhook (prompt injection, mensagens vazias, payloads gigantes, unicode). O teste verifica que o webhook não estoura.

Sem `--focus`, a skill aplica um mix de `standard` e `security`.

## Detecção de stack

Antes de escrever qualquer teste, a skill descobre a linguagem e o runner olhando o manifesto e a convenção de testes que o projeto já usa:

| Sinal no projeto | Runner | Convenção de arquivo |
|---|---|---|
| `requirements.txt`, `pyproject.toml`, `.py` | pytest | `tests/test_<alvo>.py` |
| `package.json` com jest | Jest | `<alvo>.test.js` |
| `package.json` com vitest | Vitest | `<alvo>.test.ts` |
| `go.mod`, `.go` | go test | `<alvo>_test.go` |
| `Cargo.toml`, `.rs` | cargo test | módulo `#[cfg(test)]` |
| `pom.xml` / `build.gradle` | mvn / gradle | `src/test/java/...` |

A regra principal: preferir o que o projeto já usa. Se houver um script `test` no `package.json` ou um alvo `test` no Makefile, a skill segue esse comando. Quando não dá para identificar a stack com confiança, ela pergunta em vez de chutar.

## Loop de execução

1. Escreve ou atualiza o arquivo de teste na convenção do runner detectado.
2. Roda a suíte do alvo.
3. Se passar, gera um relatório curto de sucesso.
4. Se falhar por teste mal escrito (import errado, fixture errada, asserção incorreta), corrige e roda de novo, até três tentativas.
5. Se a falha revelar um bug real no seu código, para e emite um alerta detalhado. Não altera seu código nem relaxa a asserção para "passar".

## Exemplo de saída (bug real encontrado)

```
BUG REAL encontrado, código NÃO alterado.
Arquivo: src/routes.py:42 (POST /users)
Entrada: {"email": "' OR '1'='1"}
Observado: 500 Internal Server Error
Esperado: 400 (a validação deveria rejeitar)
Teste que expõe: test_create_user_sql_injection
Sugestão: validar e parametrizar a query antes de executá-la.
```

## Exemplo

Rodada real contra a camada de validação de entrada do `sistema_gado`
(stack detectada: Python + pytest), foco standard + security:

```
/auto-tester routes/validators.py --focus security
```

Saída literal da suíte gerada e executada (12 testes, 0 correções necessárias):

```
test_validators.py::test_campo_obrigatorio_ausente_gera_erro PASSED      [  8%]
test_validators.py::test_max_len_excedido PASSED                         [ 25%]
test_validators.py::test_float_com_virgula_e_range PASSED                [ 41%]
test_validators.py::test_sql_injection_em_str_nao_quebra PASSED          [ 75%]
test_validators.py::test_payload_gigante_rejeitado_por_tamanho_sem_crash PASSED [ 91%]
test_validators.py::test_valor_nao_string_nao_quebra PASSED              [100%]

============================== 12 passed in 0.02s ==============================
```

Nenhum bug real encontrado: a `validate()` rejeita por tamanho/tipo e não estoura
com SQLi/XSS/payload gigante (o conteúdo é neutralizado depois, pelo `%s` no repo).
