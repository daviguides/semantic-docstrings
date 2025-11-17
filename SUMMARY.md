# Semantic Docstrings - Resumo do Projeto

## O que é esse projeto?

**Semantic Docstrings** é um padrão de documentação Python que adiciona significado semântico às docstrings tradicionais através de chaves estruturadas.

### Objetivo Principal

Capturar **intenção arquitetural** e **contexto de negócio** que a sintaxe Python não expressa:
- **Responsibility** - Por que este código existe?
- **Context** - Quando chamar? De onde vêm os dados?
- **Boundaries** - O que este código NÃO faz?
- **Architecture** - Qual o papel no sistema?

### Princípio Fundamental

**"Syntax says WHAT, Semantics say WHY"**:
- Sintaxe Python diz **O QUE**: tipos, assinaturas, estrutura
- Semantic Docstrings dizem **POR QUÊ**: responsabilidade, contexto, limites conceituais
- Código com tipos + docstrings semânticas = Auto-documentação arquitetural
- Preserva intenção mesmo após refatoração

### Conceito Visual

Duas camadas complementares:

```
┌─────────────────────────────────────────┐
│  def calculate_discount(user: User,    │  ← SYNTAX
│                         amount: Decimal)│    (WHAT)
│      -> Decimal                         │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Responsibility:                        │  ← SEMANTICS
│    Calculate loyalty discount           │    (WHY)
│  Context:                               │
│    Called during checkout after         │
│    amount validation                    │
│  Args:                                  │
│    user: For loyalty tier determination │
│    amount: For volume discount calc    │
└─────────────────────────────────────────┘
```

A camada semântica adiciona o **POR QUÊ** que a sintaxe não captura.

### Natureza Dual

Este projeto é **auto-demonstrativo**:
- 📋 Define um padrão de documentação (especificação)
- 🔌 Fornece ferramentas para aplicar o padrão (plugin Claude Code)
- 🏗️ Segue Gradient Architecture que ele documenta

> "Semantic Docstrings ensina através da especificação e facilita através do plugin."

---

## O que ele define? (Three-in-One Bundle)

O repositório Semantic Docstrings integra três componentes:

```
┌─────────────────────────────────────────────────────────┐
│ 1. SPECIFICATION BUNDLE (semantic-docstrings/)          │
│    - spec/      : Normative definitions (WHAT)          │
│                   • semantic-keys-spec.md               │
│                   • templates-spec.md                   │
│                   • anti-patterns-spec.md               │
│                   • validation-spec.md                  │
│    - context/   : Applied examples (HOW)                │
│                   • patterns.md (6 usage patterns)      │
│                   • examples.md (concrete code)         │
│                   • quick-reference.md                  │
│    - prompts/   : Validation workflows (ACTION)         │
│                   • validate.md                         │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ 2. CLAUDE CODE PLUGIN                                   │
│    - commands/         : User commands (≤10 lines)      │
│                         • /add-module-docstring         │
│                         • /add-class-docstring          │
│                         • /add-function-docstring       │
│                         • /validate-docstrings          │
│                         • /load-semantic-context        │
│    - agents/           : Specialized agents             │
│                         • documentation-specialist      │
│                         • docstring-reviewer            │
│    - .claude-plugin/   : Plugin metadata                │
│    - install.sh        : One-line installer             │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ 3. DOCUMENTATION SITE (docs/)                           │
│    - Jekyll-based GitHub Pages                          │
│    - Human-friendly rationale and philosophy            │
│    - Visual examples demonstrating value                │
│    - Adoption guides for teams                          │
└─────────────────────────────────────────────────────────┘
```

**Benefícios da integração**:
- Especificação é utilizável via plugin imediatamente
- Plugin demonstra o padrão na prática
- Documentação explica o "porquê" para humanos
- Mudanças no padrão validadas no próprio uso

---

## O que ele especifica?

### Chaves Semânticas por Escopo

```
MODULE → CLASS → FUNCTION
```

**Module-Level Keys**:
- `Architecture` - Papel arquitetural no sistema (orchestrator, adapter, domain)
- `Responsibility` - Responsabilidade única do módulo (SRP)
- `Should` - Lista de responsabilidades positivas (≥2 itens)
- `Boundaries` - O que o módulo NÃO faz (delegações)
- `Entry` - Funções públicas (pontos de entrada)

**Class-Level Keys**:
- `Responsibility` - Responsabilidade única da classe (SRP)
- `Boundaries` - O que a classe NÃO gerencia
- `Role` - Posição arquitetural da classe
- `Attributes` - Significado semântico dos atributos
- `Methods` - Métodos principais com descrições breves

**Function-Level Keys**:
- `Responsibility` - Responsabilidade única da função
- `Context` - Por que existe, quando chamar, origem dos dados, nível de confiança
- `Args` - Significado semântico dos parâmetros (não apenas tipos)
- `Returns` - O que o valor retornado representa
- `Raises` - Por que exceções ocorrem e o que o caller deve fazer
- `Note` - Detalhes importantes, gotchas, considerações de performance

### Templates Normativos

**3 templates oficiais**:

1. **Module Template** - Para arquivos Python (.py)
   - Opening sentence (1-2 linhas)
   - Architecture, Responsibility, Should, Boundaries, Entry
   - Formato: 80 colunas max, indentação 4 espaços

2. **Class Template** - Para classes Python
   - Opening sentence (1-2 linhas)
   - Responsibility, Boundaries, Role, Attributes, Methods
   - Focus em single responsibility

3. **Function Template** - Para funções e métodos
   - One-line summary
   - Responsibility, Context, Args, Returns, Raises, Note
   - Ênfase em Context para dados externos

### 6 Padrões de Uso

**Pattern 1: Orchestrator Modules**
- Coordena múltiplos componentes
- Exemplo: API route handlers, message processors

**Pattern 2: Domain Logic Modules**
- Implementa regras de negócio
- Exemplo: Validation engines, calculation modules

**Pattern 3: Adapter/Infrastructure Modules**
- Interface com sistemas externos
- Exemplo: API clients, database adapters

**Pattern 4: State Management Classes**
- Gerencia estado através de operações
- Exemplo: Session managers, context holders

**Pattern 5: External Data Handlers**
- Processa dados de fontes externas
- Exemplo: Webhook handlers, file parsers
- **MUST mark data as UNTRUSTED**

**Pattern 6: Transformation Functions**
- Transforma dados entre representações
- Exemplo: Format converters, serializers

### Context Patterns para Fontes de Dados

**Pattern A**: Trusted internal data
```python
Context:
    User comes from authenticated session (trusted).
    Validation completed upstream.
```

**Pattern B**: Untrusted external data
```python
Context:
    Payload comes from EXTERNAL webhook (untrusted source).
    This is first validation layer.
```

**Pattern C**: Partially validated data
```python
Context:
    Request validated for schema but NOT for business rules.
    Business validation happens here.
```

**Pattern D**: Database data
```python
Context:
    User ID comes from trusted database (authenticated source).
    Assumes user exists.
```

### Princípio de Valor Semântico

**Cada chave semântica deve adicionar valor além da sintaxe.**

❌ **Bad** (repete sintaxe):
```python
Args:
    user: A User object
    amount: A Decimal
```

✅ **Good** (adiciona significado):
```python
Args:
    user: User account for loyalty tier determination
          Must be authenticated
    amount: Purchase amount for volume-based discount calculation
            Expected range: 0.01 to 10000.00
```

### Regras de Obrigatoriedade

**Module Docstrings**:
- ✅ Required: Architecture, Responsibility, Entry
- ⚠️  Recommended: Should (if ≥3 responsibilities), Boundaries

**Class Docstrings**:
- ✅ Required: Responsibility, Role
- ⚠️  Recommended: Boundaries, Attributes, Methods

**Function Docstrings**:
- ✅ Required: Responsibility, Context, Args (if params), Returns (if return value)
- ⚠️  Recommended: Raises (if exceptions), Note (if caveats)

### Filosofia Anti-Duplicação (Gradient)

**Single Source of Truth (SSOT)**:
- Cada conceito existe em exatamente UM lugar
- Specs definem as chaves (WHAT)
- Context mostra exemplos (HOW)
- Prompts orquestram workflows (ACTION)
- Commands são thin wrappers (≤10 lines)

**Densidade de referências**:
- PROMPTS: >50% referências via `@`
- CONTEXT: >30% referências a SPECS
- COMMANDS: 100% delegação (ultra-thin)

---

## Resumo em Uma Frase

> **Semantic Docstrings**: Padrão de documentação Python que adiciona camada semântica sobre sintaxe através de chaves estruturadas (Responsibility, Context, Boundaries), capturando POR QUÊ o código existe e preservando intenção arquitetural através de refatorações.

---

## Status

✅ **Specifications**: Completas (4 specs normativas)
✅ **Context**: Padrões e exemplos documentados
✅ **Templates**: 3 templates oficiais (module, class, function)
✅ **Plugin**: Comandos e agentes funcionais
✅ **Installation**: One-line installer (`install.sh`)
✅ **Documentation Site**: Jekyll GitHub Pages
🚀 **Em uso**: Aplicável a projetos Python imediatamente

---

## Links Rápidos

### Carregar Contexto
```bash
/semantic-docstrings:load-semantic-context   # Load semantic keys + templates + patterns
```

### Adicionar Docstrings
```bash
/semantic-docstrings:add-module-docstring    # Generate module docstring
/semantic-docstrings:add-class-docstring     # Generate class docstring
/semantic-docstrings:add-function-docstring  # Generate function docstring
```

### Validar Qualidade
```bash
/semantic-docstrings:validate-docstrings     # Quick validation
/semantic-docstrings:validate-all            # Comprehensive validation workflow
```

### Resumo do Conceito
```bash
/semantic-docstrings:resume                  # Quick concept summary with example
```

### Documentação
- 📋 **Especificações**: `semantic-docstrings/spec/`
  - `semantic-keys-spec.md` - Definições de todas as chaves
  - `templates-spec.md` - Templates normativos
  - `anti-patterns-spec.md` - O que evitar
  - `validation-spec.md` - Checklists de qualidade
- 🎯 **Padrões e Exemplos**: `semantic-docstrings/context/`
  - `patterns.md` - 6 padrões de uso
  - `examples.md` - Exemplos concretos
  - `quick-reference.md` - Referência rápida
- 📚 **Arquitetura**: `CLAUDE.md`, `PLUGIN_STRUCTURE_GUIDE.md`
- 🌐 **Site**: https://daviguides.github.io/semantic-docstrings/
- 🔧 **Instalação**: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/semantic-docstrings/main/install.sh)"`

---

**Semantic Docstrings** - Onde sintaxe encontra significado, e código expressa intenção.
