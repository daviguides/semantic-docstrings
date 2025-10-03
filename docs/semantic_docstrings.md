# 6. DOCUMENTAÇÃO COMO CAMADA SEMÂNTICA
**Zen: "Readability counts"**

### Essência
Docstrings adicionam **camada de significado** que a sintaxe pura não expressa. Explicam **Responsibility, Context e Intention** — não apenas implementação.

> **Insight crítico:** Docstrings não servem apenas ao novo desenvolvedor, mas adicionam uma **camada semântica** que transcende a sintaxe.  
> Código sem docstrings diz *"O QUÊ"*, código com docstrings diz *"POR QUÊ"*.

---

### O que a Sintaxe NÃO Expressa

#### Exemplo: Função
```python
# ❌ APENAS SINTAXE (sem significado)
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    ...
```
**Sintaxe diz:** "Recebe User e Decimal, retorna Decimal"

```python
# ✅ SINTAXE + SEMÂNTICA (com significado)
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    """Calculate discount based on user loyalty and purchase volume.

    Args:
        user: User account for loyalty tier determination
        amount: Purchase amount for volume-based discount calculation

    Returns:
        Final discount amount, capped at maximum allowed discount
    """
    ...
```

**Semântica adiciona:**
- **POR QUÊ** user existe (loyalty tier)  
- **POR QUÊ** amount existe (volume calculation)  
- **POR QUÊ** retorna Decimal (capped discount)  

---

### Níveis de Significado

#### **Módulos: Papel Arquitetural**
```python
# ❌ REPETE SINTAXE
"""Workflow module."""

# ✅ ADICIONA SIGNIFICADO ARQUITETURAL
"""
This module orchestrates the conversational flow for debt negotiation.

Architecture:
    Acts as the ORCHESTRATOR of the conversation flow.
    Decides WHICH agent to use (identification vs negotiation)
    and WHEN to transition between them.

Responsibility:
    Coordinate message flow across agents.

Should:
    - Receive and validate incoming messages from external sources
    - Determine conversation state (identified vs unidentified user)
    - Route messages to appropriate agent

Boundaries:
    - Do not create or configure agents (delegated to agent modules)
    - Do not manage MCP connections or tools (delegated to helpers)
    - Do not apply business rules (delegated to domain layer)

Entry:
    - process_message: Main public function called by API routes
"""
```

**Semântica explica:**
- **POR QUÊ** módulo existe ("orchestrator")  
- **QUAL** seu papel na arquitetura  
- **FRONTEIRAS** conceituais (Should vs Boundaries)  
- **Entry**: pontos de entrada públicos  

---

#### **Funções: Contexto e Intenção**
```python
# ❌ REPETE SINTAXE
def _validate_and_extract_payload(payload: dict) -> tuple[str, str | None, str | None]:
    """Validates payload and extracts data."""
    ...

# ✅ ADICIONA CONTEXTO E INTENÇÃO
def _validate_and_extract_payload(
    payload: dict,
) -> tuple[str, str | None, str | None]:
    """
    Validates incoming payload and extracts essential conversation data.

    Responsibility:
        First line of defense for data validation.
        All subsequent processing assumes this contract.

    Context:
        Payload comes from an EXTERNAL SOURCE (WhatsApp API) and cannot be trusted.
        Enforces contract: text is mandatory; session/user IDs optional.

    Args:
        payload: Dictionary from external API
                 Expected structure: {'text': str, 'chat_session_id'?: str, 'chat_user_id'?: str}

    Returns:
        (user_message, chat_session_id, chat_user_id)
        - user_message: Always present
        - session_id: None if anonymous
        - user_id: None if anonymous

    Raises:
        ValueError: If 'text' is missing — caller MUST handle to return proper error
    """
    ...
```

**Semântica adiciona:**
- **Responsibility**: contrato arquitetural ("first line of defense")  
- **Context**: origem e confiança dos dados  
- **Returns**: significado semântico do retorno  
- **Raises**: intenção de uso das exceções  

---

#### **Classes: Fronteiras e Papel no Sistema**
```python
# ❌ APENAS SINTAXE
class IdentificationAgent:
    """Agent for user identification."""

# ✅ CAMADA SEMÂNTICA
class IdentificationAgent:
    """
    Manages user identification state and conversation flow.

    Responsibility:
        Maintain identification state across conversation turns.
        Provide clear interface to check if user is identified and
        retrieve credentials (CPF, account_uuid).

    Boundaries:
        Does NOT perform business logic — only manages conversation
        state persistence.

    Role:
        State manager for user identification journey,
        bridging stateless API calls and stateful context.
    """
```

**Semântica explica:**
- **Responsibility**: SRP (estado de identificação)  
- **Boundaries**: limitações claras (não faz lógica de negócio)  
- **Role**: papel arquitetural ("state manager")  

---

### Padrão Aplicado: Estrutura Completa

```python
"""
[MODULE PURPOSE: 1–2 sentences explaining why this module exists]

Architecture:
    [What is this module’s primary role in system architecture?]

Responsibility:
    [Single overarching responsibility]

Should:
    - [Responsibility 1]
    - [Responsibility 2]

Boundaries:
    - [Delegated responsibility]
    - [Out of scope]

Entry:
    - [public_function: Brief description]
"""

class ExampleClass:
    """
    [CLASS PURPOSE: 1–2 sentences]

    Responsibility:
        [What is this class’s single responsibility?]

    Boundaries:
        [What this class does NOT handle]

    Role:
        [Position of this class in system]

    Attributes:
        attr1: [Meaning]
        attr2: [Meaning]

    Methods:
        method1(): [What it does]
    """

def public_function(arg1: str, arg2: int) -> bool:
    """
    [One-line summary]

    Responsibility:
        [What is this function’s single responsibility?]

    Context:
        [Why it exists, when to call, assumptions]

    Args:
        arg1: [Why it exists / constraints]
        arg2: [Why it exists / constraints]

    Returns:
        [Meaning of return value]

    Raises:
        ValueError: [Why it may be raised / what caller must do]

    Note:
        [Important details or gotchas]
    """
```

---

### Por Quê Isso Importa?

#### 1. **Sintaxe → O QUÊ | Semântica → POR QUÊ**
```python
# Sintaxe diz O QUÊ:
user: User, amount: Decimal -> Decimal

# Semântica diz POR QUÊ:
user: "for loyalty tier determination"
amount: "for volume-based calculation"
return: "final discount with cap"
```

#### 2. **Código Muda, Significado Permanece**
- Refatoração pode mudar implementação  
- Docstring preserva **intenção** e **responsabilidade**  
- Novo desenvolvedor (ou LLM) entende **conceito**, não apenas código  

#### 3. **Previne Acoplamento Semântico**
```python
"""
Boundaries:
    - Manage MCP connections (delegated to execution helpers)
"""
```
→ Define fronteiras conceituais, não apenas técnicas  

#### 4. **LLMs/Ferramentas Entendem Intenção**
- IDE autocomplete mostra **contexto**, não apenas tipo  
- Code review foca em **violação de responsabilidade**  
- LLMs geram código alinhado com **arquitetura**  

---

### Comparação: Sintaxe vs Semântica

| Aspecto       | Apenas Sintaxe | Com Camada Semântica |
|---------------|----------------|----------------------|
| **Módulo**    | Nome do arquivo | POR QUÊ existe, QUAL responsabilidade |
| **Função**    | Assinatura (tipos) | CONTEXTO dos args, INTENÇÃO do retorno |
| **Classe**    | Atributos/métodos | FRONTEIRAS, PAPEL no sistema |
| **Argumentos**| `user: User` | "User account for loyalty tier determination" |
| **Retorno**   | `-> Decimal` | "Final discount amount, capped at maximum" |
| **Exceção**   | `raises ValueError` | "If text missing - caller MUST handle" |

---

### Por Quê?
- ✅ Adiciona significado que sintaxe não expressa  
- ✅ Preserva intenção mesmo com refatoração  
- ✅ Define fronteiras conceituais, não apenas técnicas  
- ✅ Código auto-explicativo em nível arquitetural  
- ✅ Reduz necessidade de documentação externa  
- ✅ Facilita onboarding, code review e uso por LLMs  
