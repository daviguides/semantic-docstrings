# Claude Code Plugin - Structure Guide

## 📋 Quick Reference

Este guia contém todas as informações necessárias para transformar um repositório em um Claude Code Plugin válido.

---

## ✅ Estrutura Mínima Obrigatória

```
your-plugin-repo/
└── .claude-plugin/
    └── plugin.json          # OBRIGATÓRIO
```

---

## 📦 Estrutura Completa Recomendada

```
your-plugin-repo/
├── .claude-plugin/
│   └── plugin.json          # OBRIGATÓRIO: Metadata do plugin
├── commands/                 # OPCIONAL: Custom slash commands
│   └── my-command.md
├── agents/                   # OPCIONAL: Custom agents
│   └── my-agent.md
├── hooks/                    # OPCIONAL: Event handlers
│   └── hooks.json
├── .mcp.json                # OPCIONAL: MCP servers
├── README.md                # RECOMENDADO: Documentação
├── CHANGELOG.md             # RECOMENDADO: Histórico de mudanças
└── LICENSE                  # RECOMENDADO: Licença
```

---

## ⚡ IMPORTANTE: Plugins vs CLAUDE.md (Contexto Automático)

### Diferença Fundamental

**Plugins NÃO injetam contexto automaticamente como `CLAUDE.md` faz.**

| Característica | CLAUDE.md | Plugin Commands |
|----------------|-----------|-----------------|
| **Automático** | ✅ Sempre ativo | ❌ Requer ativação manual |
| **Global** | ✅ Todas as sessões | ❌ Por sessão |
| **Hierárquico** | ✅ Global → Projeto | ❌ Manual |
| **Distribuível** | ❌ Usuário configura | ✅ Via plugin |
| **Versionável** | ⚠️ Com repo | ✅ Com plugin |

### O Que Plugins PODEM Fazer

1. **Slash Commands** - Prompts ativados manualmente (`/command`)
2. **Agents** - Contexto especializado para tarefas específicas
3. **Hooks** - Executar scripts em eventos (não injeta contexto)
4. **MCP Servers** - Conectar ferramentas externas

### O Que Plugins NÃO PODEM Fazer

- ❌ Injetar contexto global automaticamente
- ❌ Modificar `~/.claude/CLAUDE.md` automaticamente
- ❌ Estar "sempre ativos" como CLAUDE.md

---

## 🔄 Estratégias para Distribuir Contexto via Plugin

### **Estratégia 1: Context Loader Commands (Recomendado)**

Use slash commands que carregam contexto quando executados pelo usuário.

**Estrutura:**
```
your-plugin-repo/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── load-context.md         # "Context loader"
├── context/
│   └── full-guidelines.md      # Documentação completa
└── README.md
```

**Exemplo: `commands/load-zen-context.md`**
```markdown
---
description: Load Zen of Python context for this session
---

Apply Zen of Python principles throughout this session:

## Coding Standards
- All code in English
- PEP 8 compliance mandatory
- Type hints always required
- Maximum 80 columns

## Decision Matrix
| Context | Primary Principles | Verification |
|---------|-------------------|--------------|
| Function | Readability, Simple > Complex | "Can explain in 1 sentence?" |
| Class | Explicit > Implicit | "Single responsibility?" |

## Pre-Code Checklist
- [ ] Beautiful: Follows PEP 8?
- [ ] Explicit: Clear intentions?
- [ ] Readable: Easy to understand?

[Incluir todo o conteúdo necessário aqui]
```

**Uso:**
```bash
# Usuário executa uma vez por sessão
/load-zen-context
```

---

### **Estratégia 2: Documentar Integração com CLAUDE.md**

Instrua usuários a adicionarem referências ao plugin em seu `CLAUDE.md`.

**No README.md do plugin:**
```markdown
## Installation

1. Install the plugin:
   ```bash
   /plugin install code-zen@daviguides-marketplace
   ```

2. For automatic context loading, add to your `.claude/CLAUDE.md`:
   ```markdown
   # Code Zen Plugin Context

   @./path/to/code-zen/context/zen-guidelines.md
   ```

## Quick Start (Alternative)

If you don't want to modify CLAUDE.md, use the context loader command once per session:
```bash
/load-zen-context
```
```

---

### **Estratégia 3: Agents Especializados**

Agents são ativados automaticamente para tarefas relacionadas.

**Exemplo: `agents/zen-reviewer.md`**
```markdown
---
description: Code reviewer following Zen of Python principles
---

You are a code review specialist focused on Zen of Python.

Always check:
- PEP 8 compliance
- Explicit naming conventions
- Simple solutions over complex
- Flat structure over nested
- No silent errors

Provide specific feedback with line references.
```

Claude ativa este agent automaticamente quando apropriado.

---

## 📦 Estrutura Completa Recomendada (Atualizada)

```
your-plugin-repo/
├── .claude-plugin/
│   └── plugin.json              # OBRIGATÓRIO: Metadata
├── commands/
│   ├── load-context.md          # Context loader command
│   └── specific-action.md       # Action commands
├── agents/
│   └── specialized-agent.md     # Specialized agents
├── hooks/
│   └── hooks.json               # Event handlers
├── context/
│   └── full-guidelines.md       # Full documentation for reference
├── .mcp.json                    # OPCIONAL: MCP servers
├── README.md                    # OBRIGATÓRIO: Como usar
├── CHANGELOG.md                 # RECOMENDADO: Histórico
└── LICENSE                      # RECOMENDADO: Licença
```

**Nova pasta `context/`:**
- Contém documentação completa e guidelines
- Usuários podem referenciar em `.claude/CLAUDE.md`
- Também usada pelos context loader commands

---

## 📄 plugin.json - Configuração Obrigatória

### Campos Obrigatórios

```json
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "Brief description of what this plugin does"
}
```

### Exemplo Completo

```json
{
  "name": "my-awesome-plugin",
  "version": "1.0.0",
  "description": "Enhanced development workflow for Python projects",
  "author": "Your Name",
  "repository": "https://github.com/username/plugin-repo",
  "license": "MIT"
}
```

### Regras de Nomenclatura

- **name**: kebab-case (lowercase, hífens)
  - ✅ `semantic-docstrings`
  - ✅ `code-zen`
  - ❌ `semantic_docstrings`
  - ❌ `SemanticDocstrings`

- **version**: Semantic versioning (MAJOR.MINOR.PATCH)
  - ✅ `1.0.0`
  - ✅ `0.1.0`
  - ❌ `v1.0`
  - ❌ `1.0`

---

## 🎯 Componentes Opcionais

### 1. Commands (Slash Commands)

**Localização:** `commands/`

**Estrutura:**
```
commands/
├── my-command.md
└── another-command.md
```

**Exemplo: `commands/format-code.md`**
```markdown
---
description: Format code according to project standards
---

Format the current file following these standards:
- PEP 8 for Python
- Use ruff for formatting
- Maximum line length: 80 characters
```

**Uso pelo usuário:**
```bash
/format-code
```

---

### 2. Agents (Specialized Agents)

**Localização:** `agents/`

**Estrutura:**
```
agents/
├── code-reviewer.md
└── test-generator.md
```

**Exemplo: `agents/code-reviewer.md`**
```markdown
---
description: Review code for quality and best practices
---

You are a code review specialist. Analyze the code and provide:
1. Code quality assessment
2. Best practices violations
3. Improvement suggestions
4. Security concerns
```

---

### 3. Hooks (Event Handlers)

**Localização:** `hooks/hooks.json`

**Exemplo:**
```json
{
  "hooks": [
    {
      "name": "pre-commit-check",
      "event": "user-prompt-submit",
      "command": "ruff check ."
    }
  ]
}
```

---

### 4. MCP Servers

**Localização:** `.mcp.json`

**Exemplo:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/files"]
    }
  }
}
```

---

## 🚀 Passos para Criar um Plugin

### Passo 1: Criar Estrutura Mínima

```bash
# Na raiz do seu repo
mkdir -p .claude-plugin
```

### Passo 2: Criar plugin.json

```bash
# Criar arquivo com configuração mínima
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "your-plugin-name",
  "version": "0.1.0",
  "description": "Your plugin description"
}
EOF
```

### Passo 3: (Opcional) Adicionar Componentes

```bash
# Adicionar commands (opcional)
mkdir -p commands

# Adicionar agents (opcional)
mkdir -p agents

# Adicionar hooks (opcional)
mkdir -p hooks
touch hooks/hooks.json
```

### Passo 4: Commit e Push

```bash
git add .claude-plugin/
git commit -m "Add Claude Code plugin structure"
git push
```

---

## 📝 Templates para seus Plugins

### Para: semantic-docstrings

**Estrutura Completa:**
```
semantic-docstrings/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── load-semantic-context.md      # Context loader
│   ├── add-docstring.md              # Add docstring to function
│   └── validate-docstrings.md        # Validate existing docstrings
├── agents/
│   └── documentation-helper.md       # Documentation specialist
├── context/
│   └── semantic-guidelines.md        # Full semantic docstring guidelines
└── README.md
```

**`.claude-plugin/plugin.json`**
```json
{
  "name": "semantic-docstrings",
  "version": "0.1.0",
  "description": "Enhanced code documentation with semantic docstring support for Python projects",
  "author": "Davi Luiz de Andrade Guides",
  "repository": "https://github.com/daviguides/semantic-docstrings",
  "license": "MIT"
}
```

**`commands/load-semantic-context.md`** (Context Loader)
```markdown
---
description: Load semantic docstring context for this session
---

Apply semantic docstring principles throughout this session:

## Docstring Standards
- All public functions, classes, and modules must have docstrings
- Use Google-style or NumPy-style docstrings
- Include Args, Returns, Raises sections
- Maximum 80 columns

## Semantic Meaning
- Describe WHAT the function does (not HOW)
- Explain WHY design decisions were made
- Document expected behavior and edge cases

## Examples Required
- Include usage examples for complex functions
- Show both success and error cases

Always validate docstrings before committing.
```

**`agents/documentation-helper.md`**
```markdown
---
description: Specialist in semantic docstrings and documentation
---

You are a documentation specialist focused on semantic docstrings.

When helping with documentation:
1. Generate clear, semantic docstrings
2. Follow project docstring style (Google/NumPy)
3. Include comprehensive Args, Returns, Raises
4. Add usage examples for complex functions
5. Explain edge cases and design decisions

Ensure all docstrings add semantic value, not just repeat the code.
```

---

### Para: code-zen

**Estrutura Completa:**
```
code-zen/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── load-zen-context.md           # Context loader
│   ├── zen-check.md                  # Verify compliance
│   └── zen-refactor.md               # Refactor with Zen
├── agents/
│   └── zen-reviewer.md               # Zen-focused code reviewer
├── hooks/
│   └── hooks.json                    # Pre-commit checks
├── context/
│   ├── zen-guidelines.md             # Full Zen guidelines
│   └── zen-quick-reference.md        # Quick reference card
└── README.md
```

**`.claude-plugin/plugin.json`**
```json
{
  "name": "code-zen",
  "version": "0.1.0",
  "description": "Python development following Zen of Python principles and best practices",
  "author": "Davi Luiz de Andrade Guides",
  "repository": "https://github.com/daviguides/code-zen",
  "license": "MIT"
}
```

**`commands/load-zen-context.md`** (Context Loader)
```markdown
---
description: Load Zen of Python context for this session
---

Apply Zen of Python principles throughout this session:

## Fundamental Principles
- **Beautiful is better than ugly** - Follow PEP 8
- **Explicit is better than implicit** - Clear intentions
- **Simple is better than complex** - Simplest solution first
- **Flat is better than nested** - Use guard clauses
- **Readability counts** - ALWAYS prioritize readability

## Pre-Code Checklist (MANDATORY)
- [ ] Beautiful: Follows PEP 8?
- [ ] Explicit: Intentions clear?
- [ ] Readable: Easy to understand?
- [ ] Simple: Simplest approach?
- [ ] Flat: Avoids nesting?

## Decision Matrix
| Context | Primary Principles | Verification |
|---------|-------------------|--------------|
| Function | Readability, Simple > Complex | "Explain in 1 sentence?" |
| Class | Explicit > Implicit | "Single responsibility?" |
| Module | Namespaces, One way | "Clear imports?" |
| Error | Never silent | "Failure is obvious?" |

## Red Flags - STOP if found
🚨 "This is too clever" → Violates Simple > Complex
🚨 "Only works if you know X" → Violates Explicit > Implicit
🚨 "5+ levels of if/for" → Violates Flat > Nested
🚨 "Can't explain how it works" → Violates Readability

Apply these principles to ALL code generated in this session.
```

**`commands/zen-check.md`**
```markdown
---
description: Check code compliance with Zen of Python
---

Analyze the current code for Zen of Python compliance:

1. **Beautiful**: PEP 8 compliance check
2. **Explicit**: Look for implicit behavior
3. **Simple vs Complex**: Identify over-engineering
4. **Flat vs Nested**: Count nesting levels
5. **Readability**: Assess clarity

Provide specific violations with line numbers and suggested fixes.
```

**`agents/zen-reviewer.md`**
```markdown
---
description: Code reviewer following Zen of Python principles
---

You are a code review specialist focused on Zen of Python.

Review code against these principles:

## Mandatory Checks
- [ ] PEP 8 compliance (Beautiful is better than ugly)
- [ ] Explicit naming and behavior (Explicit > Implicit)
- [ ] Simple solutions (Simple > Complex)
- [ ] Flat structure with guard clauses (Flat > Nested)
- [ ] Readable code with clear intent (Readability counts)
- [ ] No silent errors (Errors never pass silently)

## Review Output Format
For each issue found:
- **Line(s)**: X-Y
- **Principle**: Which Zen principle is violated
- **Issue**: What's wrong
- **Suggestion**: How to fix

Be specific, direct, and provide code examples.
```

**`hooks/hooks.json`**
```json
{
  "hooks": [
    {
      "name": "zen-pre-commit",
      "event": "user-prompt-submit",
      "command": "ruff check . --select=E,W,F --max-line-length=80"
    }
  ]
}
```

---

## ✅ Checklist de Verificação

Antes de publicar seu plugin, verifique:

- [ ] `.claude-plugin/` directory exists
- [ ] `plugin.json` exists e é válido JSON
- [ ] `name` está em kebab-case
- [ ] `version` segue semantic versioning
- [ ] `description` é clara e concisa
- [ ] README.md documenta o uso do plugin
- [ ] LICENSE file existe
- [ ] Commits foram feitos e pushed para GitHub

---

## 🔗 Referência ao Marketplace

Após criar a estrutura nos plugins, o marketplace já está configurado para referenciá-los:

**`claude-marketplace/.claude-plugin/marketplace.json`**
```json
{
  "plugins": [
    {
      "name": "semantic-docstrings",
      "source": {
        "source": "github",
        "repo": "daviguides/semantic-docstrings"
      }
    },
    {
      "name": "code-zen",
      "source": {
        "source": "github",
        "repo": "daviguides/code-zen"
      }
    }
  ]
}
```

---

## 🧪 Testando Localmente

### Antes de publicar no GitHub

```bash
# Adicionar marketplace local
/plugin marketplace add ./path/to/claude-marketplace

# Instalar plugin local para teste
/plugin install plugin-name@marketplace-name
```

### Depois de publicar no GitHub

```bash
# Adicionar marketplace do GitHub
/plugin marketplace add daviguides/claude-marketplace

# Instalar plugin
/plugin install semantic-docstrings@daviguides-marketplace
/plugin install code-zen@daviguides-marketplace
```

---

## 📚 Documentação Oficial

- **Plugins:** https://docs.claude.com/en/docs/claude-code/plugins
- **Plugin Reference:** https://docs.claude.com/en/docs/claude-code/plugins-reference
- **Marketplaces:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces

---

## 🎯 Próximos Passos

1. Abrir nova sessão em cada repo (`semantic-docstrings` e `code-zen`)
2. Criar estrutura `.claude-plugin/plugin.json` em cada um
3. Adicionar componentes opcionais (commands, agents, hooks)
4. Commit e push
5. Testar instalação via marketplace
6. Publicar marketplace no GitHub

---

## 📋 Exemplo de Sessão de Setup

```bash
# Em cada repo de plugin:
cd /path/to/plugin-repo

# Criar estrutura
mkdir -p .claude-plugin

# Criar plugin.json (ajustar nome e descrição)
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "Plugin description"
}
EOF

# Verificar
cat .claude-plugin/plugin.json

# Commit
git add .claude-plugin/
git commit -m "Add Claude Code plugin structure"
git push
```

---

## ⚠️ Notas Importantes

### Paths Relativos
- Todos os paths em configurações devem começar com `./`
- Exemplo: `"./commands/my-command.md"`

### Environment Variable
- `${CLAUDE_PLUGIN_ROOT}` - Caminho absoluto para o diretório do plugin

### Debugging
```bash
# Ver logs detalhados de carregamento de plugins
claude --debug
```

### Nome do Plugin vs Nome do Repo
- **Nome do plugin** (em `plugin.json`): pode ser diferente do nome do repo
- **Nome do repo**: usado na referência do marketplace
- Recomendado: manter consistência entre ambos

---

## 💡 Dicas Adicionais

1. **Versionamento:** Use semantic versioning para facilitar updates
2. **Documentação:** README.md detalhado ajuda usuários
3. **Changelog:** Mantenha CHANGELOG.md atualizado
4. **Testes:** Teste localmente antes de publicar
5. **Exemplos:** Inclua exemplos de uso no README

---

## 🎓 Melhores Práticas para Context Loading

### **1. Context Loader Commands**

✅ **Faça:**
- Inclua TODO o contexto necessário no comando
- Seja explícito e detalhado
- Adicione checklists e tabelas
- Use formatação clara (headers, listas, tabelas)

❌ **Não faça:**
- Referenciar arquivos externos (usuário não os tem)
- Assumir conhecimento prévio
- Ser vago ou genérico

### **2. Naming Conventions**

**Context Loaders:**
- `load-[context-name]-context.md`
- Exemplo: `load-zen-context.md`, `load-semantic-context.md`

**Action Commands:**
- `[verb]-[noun].md`
- Exemplo: `add-docstring.md`, `check-compliance.md`

### **3. README Documentation**

Sempre documente no README.md:

```markdown
## Quick Start

### Option 1: One-time Context Loading (Recommended)
```bash
/load-zen-context
```

### Option 2: Automatic Context (Advanced)
Add to your `.claude/CLAUDE.md`:
```markdown
@/path/to/code-zen/context/zen-guidelines.md
```

## Available Commands

- `/load-zen-context` - Load Zen principles for this session
- `/zen-check` - Verify code compliance with Zen
- `/zen-refactor` - Refactor code following Zen principles
```

### **4. Context Directory Usage**

Pasta `context/` serve para:
- ✅ Documentação completa para referência
- ✅ Ser incluída em CLAUDE.md (usuário escolhe)
- ✅ Fonte para context loader commands
- ❌ NÃO é carregada automaticamente pelo plugin

### **5. Agents vs Commands**

**Use Agents quando:**
- Contexto especializado para tarefas específicas
- Claude deve ativar automaticamente quando apropriado
- Exemplo: code reviewer, test generator

**Use Commands quando:**
- Usuário precisa ativar explicitamente
- Loading de contexto para a sessão
- Ações específicas (format, check, etc)

---

## 📊 Comparação de Abordagens

### Context Loading Strategies

| Abordagem | Automático | Persistente | Distribuível | Complexidade |
|-----------|------------|-------------|--------------|--------------|
| **CLAUDE.md (global)** | ✅ Sempre | ✅ Todas sessões | ❌ Manual | Baixa |
| **CLAUDE.md (projeto)** | ✅ No projeto | ✅ Projeto | ✅ Com repo | Baixa |
| **Context Loader Command** | ❌ Manual | ❌ Por sessão | ✅ Plugin | Média |
| **Agent** | ⚡ Auto em tarefas | ❌ Por tarefa | ✅ Plugin | Média |
| **Hook** | ✅ Em eventos | ❌ Por evento | ✅ Plugin | Alta |

### Recomendação por Caso de Uso

**Para guidelines/standards gerais:**
→ Context Loader Command + documentar integração com CLAUDE.md

**Para code review/analysis:**
→ Agent especializado

**Para validações/checks:**
→ Hook + Command para manual trigger

**Para ações específicas:**
→ Action Commands

---

## 🔍 Exemplo Completo: Workflow do Usuário

### Instalação e Setup

```bash
# 1. Adicionar marketplace
/plugin marketplace add daviguides/claude-marketplace

# 2. Instalar plugins
/plugin install code-zen@daviguides-marketplace
/plugin install semantic-docstrings@daviguides-marketplace

# 3. Carregar contexto para a sessão
/load-zen-context
/load-semantic-context

# Agora todo código gerado seguirá os princípios carregados
```

### Uso Durante Desenvolvimento

```bash
# Verificar compliance
/zen-check

# Adicionar docstring
/add-docstring

# Agent ativa automaticamente em code reviews
# (usuário não precisa chamar explicitamente)
```

### Setup Automático (Opcional)

Usuário pode adicionar ao `.claude/CLAUDE.md`:

```markdown
# My Development Environment

## Code Zen Principles
@./path/to/code-zen/context/zen-guidelines.md

## Semantic Docstrings
@./path/to/semantic-docstrings/context/semantic-guidelines.md
```

Agora o contexto é sempre carregado automaticamente.
