---
name: brute-tester
description: DAST fuzzer defensivo AUTORIZADO — dispara payloads maliciosos contra um endpoint em localhost e reporta rotas que quebram (500/stack trace vazado).
argument-hint: [url localhost/endpoint] [--intensity light|heavy]
---

# Contexto
Você opera o `brute-tester`, uma ferramenta de teste de segurança dinâmico (DAST) **defensiva e autorizada**. Ela envia payloads maliciosos gerados em memória contra um endpoint HTTP e identifica quais quebram o servidor (HTTP 500) ou vazam stack trace, para que o dono do código corrija.

**Regra inviolável:** o alvo deve ser `localhost`, `127.0.0.1` ou `0.0.0.0`. O script já aborta contra qualquer outro host — não tente contorná-la. Se o usuário pedir alvo externo, recuse.

# Alvo
$ARGUMENTS

O primeiro argumento é a URL do endpoint (ex: `http://localhost:5000/webhook`). O opcional `--intensity light|heavy` controla o volume de disparos (default: `light`).

# Execução
1. Confirme que a URL é de localhost. Se não for, pare e explique que a ferramenta só testa alvos locais autorizados.
2. Rode o script a partir do diretório da skill:
   ```
   python brute-tester/brute_tester.py <URL> [--intensity light|heavy]
   ```
   Ele dispara o arsenal (JSONs gigantes, tipos invertidos, XML, SQLi, XSS, caracteres de controle, prompt injection), trata erros de conexão sem crashar, e escreve `BRUTE_TEST_REPORT.md` no diretório de trabalho.
3. Se o servidor estiver offline (erros de conexão em todos os disparos), avise o usuário para subir o app alvo e não interprete isso como "seguro".

# Relatório ao usuário
Leia `BRUTE_TEST_REPORT.md` e resuma:
- Quantos disparos, quantos payloads críticos (500 ou stack trace vazado).
- Quais payloads quebraram o servidor.
- Para cada rota vulnerável, sugestões concretas de correção Flask (validação de `request.get_json`, checagem de tipo, `MAX_CONTENT_LENGTH`, `errorhandler(500)`, desligar `debug` em produção, queries parametrizadas). O relatório já traz um bloco de sugestões — use-o e aponte a linha/rota provável no código do usuário se você tiver acesso a ele.

Se nada quebrou, diga isso em uma linha — não invente vulnerabilidades.

# Self-check
`python brute-tester/brute_tester.py --demo` valida a trava de segurança e a classificação sem disparar contra rede.
