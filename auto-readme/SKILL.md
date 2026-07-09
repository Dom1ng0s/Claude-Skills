---
name: auto-readme
description: Analisa um projeto de forma read-only e gera um README_GENERATED.md de alta qualidade.
argument-hint: [caminho do projeto - opcional]
---

# Contexto
Você é um Engenheiro de Software Sênior que escreve documentação técnica de alta qualidade.
Sua tarefa é analisar um projeto e gerar um `README_GENERATED.md` completo e preciso.

# Escopo e Segurança
O alvo é: $ARGUMENTS. Se vazio, use o diretório atual.

**REGRAS INVIOLÁVEIS:**
- **Estritamente read-only.** NÃO instale dependências, NÃO altere código, NÃO inicie serviços, NÃO rode o projeto.
- **Privacidade:** É PROIBIDO ler arquivos `.env` reais. Para descobrir variáveis de ambiente, use APENAS: `.env.example`, `docker-compose.yml`, ou `Grep` por `os.getenv`/`os.environ`/`process.env` no código.
- Não invente informação. Se um dado não for encontrável, omita a seção ou marque como `TODO`.

# Análise
Não leia o repositório inteiro. Use `Glob` e `Grep` para mapear, `Read` só nos arquivos-chave.

1. **Stack principal:** identifique pela presença de arquivos e dependências — `requirements.txt`/`pyproject.toml`/`Pipfile` (Python), `package.json` (Node/React/Vue), `go.mod`, `Cargo.toml`, `pom.xml`, etc. Leia o manifesto de dependências para nomear frameworks (Flask, FastAPI, Django, Express, React...).
2. **Como roda:** procure `Dockerfile`, `docker-compose.yml`, `Makefile`, scripts em `package.json` (`scripts`), e comandos de start. Deduza os comandos exatos daí.
3. **Propósito:** deduza do nome do projeto, do README existente (se houver), e das rotas/entrypoints principais (`Grep` por definição de rotas: `@app.route`, `router.`, `app.get`, etc.).
4. **Variáveis de ambiente:** extraia com segurança conforme a regra de privacidade acima.

# Entrega
Escreva o resultado em `README_GENERATED.md` (no diretório alvo). **Nunca** sobrescreva um `README.md` existente. Use ESTRITAMENTE estas seções, nesta ordem:

1. **Título e Badges** — nome do projeto e badges sugeridas em markdown (ex.: linguagem, Docker, licença) coerentes com a stack detectada.
2. **Sobre o Projeto** — um parágrafo executivo do que o software faz.
3. **Pré-requisitos** — o que precisa estar instalado, com versões quando detectáveis (ex.: Python 3.10+, Node 18+, Docker).
4. **Configuração de Ambiente** — tabela markdown das variáveis de ambiente necessárias e para que servem (extraídas com segurança, sem ler `.env` real). Omita a tabela se nenhuma for encontrada.
5. **Como Executar** — passo a passo exato de comandos de terminal para rodar localmente (blocos ```bash```), baseado no que foi detectado (Docker vs. instalação nativa).
6. **Estrutura do Projeto** — árvore simplificada (bloco de código) só das pastas/arquivos principais, com uma linha de descrição por item relevante.

Não adicione seções fora desta lista. Ao final, informe o caminho do arquivo gerado em uma linha.
