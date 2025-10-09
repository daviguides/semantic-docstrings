# Semantic Docstrings - Complete Guidelines

## Core Philosophy

**Syntax says WHAT, Semantics say WHY**

Docstrings add a **semantic layer** that pure syntax does not express.
They explain **Responsibility, Context, and Intention** — not just implementation.

> **Critical insight:** Docstrings are not only for the new developer, but add a **semantic layer** that transcends syntax.
> Code without docstrings says *"WHAT"*, code with docstrings says *"WHY"*.

---

## What Syntax DOES NOT Express

### Example: Function

```python
# ❌ ONLY SYNTAX (no meaning)
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    ...
```

**Syntax says:** "Receives User and Decimal, returns Decimal"

```python
# ✅ SYNTAX + SEMANTICS (with meaning)
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

**Semantics add:**
- **WHY** user exists (loyalty tier)
- **WHY** amount exists (volume calculation)
- **WHY** returns Decimal (capped discount)

---

## Semantic Keys by Scope

### 📦 Modules: Architectural Role

**Semantic Keys:**
- **Architecture**: Module's role in system architecture
- **Responsibility**: Overarching single responsibility
- **Should**: Positive responsibilities (what it does)
- **Boundaries**: Delegated tasks / out of scope (what it doesn't do)
- **Entry**: Public functions (entry points)

**Example:**

```python
# ❌ REPEATS SYNTAX
"""Workflow module."""

# ✅ ADDS ARCHITECTURAL MEANING
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

**Semantics explain:**
- **WHY** the module exists ("orchestrator")
- **WHAT** its role in the architecture is
- **Conceptual BOUNDARIES** (Should vs Boundaries)
- **Entry**: public entry points

---

### 🏷️ Classes: Boundaries and Role in the System

**Semantic Keys:**
- **Responsibility**: Single responsibility of the class
- **Boundaries**: What the class does NOT handle
- **Role**: Position of this class in the system
- **Attributes**: Instance attributes with semantic meaning
- **Methods**: Key methods with brief descriptions

**Example:**

```python
# ❌ ONLY SYNTAX
class IdentificationAgent:
    """Agent for user identification."""

# ✅ SEMANTIC LAYER
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

**Semantics explain:**
- **Responsibility**: SRP (identification state)
- **Boundaries**: clear limitations (does not do business logic)
- **Role**: architectural role ("state manager")

---

### ⚙️ Functions: Context and Intention

**Semantic Keys:**
- **Responsibility**: Single responsibility of the function
- **Context**: Why it exists, when to call, assumptions about data origin/trust
- **Args**: Parameter meanings (WHY they exist, not just types)
- **Returns**: Semantic meaning of return value
- **Raises**: Why exceptions are raised and what caller must do
- **Note**: Important details, gotchas, or performance considerations

**Example:**

```python
# ❌ REPEATS SYNTAX
def _validate_and_extract_payload(payload: dict) -> tuple[str, str | None, str | None]:
    """Validates payload and extracts data."""
    ...

# ✅ ADDS CONTEXT AND INTENTION
def _validate_and_extract_payload(
    payload: dict,
) -> tuple[str, str | None, str | None]:
    """
    Validates incoming payload and extracts essential conversation data.

    Responsibility:
        First line of defense for data validation.
        All subsequent processing assumes this contract.

    Context:
        Payload comes from an EXTERNAL SOURCE (WhatsApp API) and cannot
        be trusted. Enforces contract: text is mandatory; session/user
        IDs optional.

    Args:
        payload: Dictionary from external API
                 Expected structure:
                 {'text': str, 'chat_session_id'?: str, 'chat_user_id'?: str}

    Returns:
        (user_message, chat_session_id, chat_user_id)
        - user_message: Always present
        - session_id: None if anonymous
        - user_id: None if anonymous

    Raises:
        ValueError: If 'text' is missing — caller MUST handle to return
                    proper error
    """
    ...
```

**Semantics add:**
- **Responsibility**: architectural contract ("first line of defense")
- **Context**: data origin and trust
- **Returns**: semantic meaning of the return
- **Raises**: intention of exception use

---

## Complete Structure Templates

### Module Template

```python
"""
[MODULE PURPOSE: 1–2 sentences explaining why this module exists]

Architecture:
    [What is this module's primary role in system architecture?]

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
```

### Class Template

```python
class ExampleClass:
    """
    [CLASS PURPOSE: 1–2 sentences]

    Responsibility:
        [What is this class's single responsibility?]

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
```

### Function Template

```python
def public_function(arg1: str, arg2: int) -> bool:
    """
    [One-line summary]

    Responsibility:
        [What is this function's single responsibility?]

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

## Why Does This Matter?

### 1. Syntax → WHAT | Semantics → WHY

```python
# Syntax says WHAT:
user: User, amount: Decimal -> Decimal

# Semantics says WHY:
user: "for loyalty tier determination"
amount: "for volume-based calculation"
return: "final discount with cap"
```

### 2. Code Changes, Meaning Remains

- Refactoring may change implementation
- Docstring preserves **intention** and **responsibility**
- New developer (or LLM) understands **concept**, not just code

### 3. Prevents Semantic Coupling

```python
"""
Boundaries:
    - Manage MCP connections (delegated to execution helpers)
"""
```

→ Defines conceptual boundaries, not just technical ones

### 4. LLMs/Tools Understand Intention

- IDE autocomplete shows **context**, not just type
- Code review focuses on **responsibility violation**
- LLMs generate code aligned with **architecture**

---

## Comparison: Syntax vs Semantics

| Aspect        | Syntax Only          | With Semantic Layer                                  |
|---------------|----------------------|------------------------------------------------------|
| **Module**    | Filename             | WHY it exists, WHAT responsibility                   |
| **Function**  | Signature (types)    | CONTEXT of args, INTENTION of return                 |
| **Class**     | Attributes/methods   | BOUNDARIES, ROLE in system                           |
| **Arguments** | `user: User`         | "User account for loyalty tier determination"        |
| **Return**    | `-> Decimal`         | "Final discount amount, capped at maximum"           |
| **Exception** | `raises ValueError`  | "If text missing - caller MUST handle"               |

---

## Benefits

- ✅ Adds meaning that syntax does not express
- ✅ Preserves intention even with refactoring
- ✅ Defines conceptual boundaries, not just technical ones
- ✅ Self-explanatory code at architectural level
- ✅ Reduces need for external documentation
- ✅ Facilitates onboarding, code review, and use by LLMs

---

## Rules and Best Practices

### 1. Type Hints Belong in Signatures

**Always:**
- ✅ Put type hints in function/method signatures
- ✅ Use modern Python 3.13+ syntax (`list[str]` not `List[str]`)

**Never:**
- ❌ Put type information in docstring body
- ❌ Repeat what signature already says

### 2. Explain WHY, Not WHAT

**Good:**
```python
Args:
    user: User account for loyalty tier determination and discount
          calculation. Must be authenticated.
```

**Bad:**
```python
Args:
    user: A User object
```

### 3. Context for External Data is Critical

For functions handling external data, always state:
- Where data comes from (API, database, user input)
- Trust level (trusted/untrusted)
- Validation responsibility

**Example:**
```python
Context:
    Payload comes from EXTERNAL SOURCE (WhatsApp API) and cannot
    be trusted. This is first validation layer.
```

### 4. Boundaries Prevent Scope Creep

For modules and classes, explicitly state:
- What is out of scope
- What is delegated to other components
- What this component does NOT do

**Example:**
```python
Boundaries:
    - Do not create agents (delegated to agent modules)
    - Do not apply business rules (delegated to domain layer)
```

### 5. Maximum 80 Columns

Maintain maximum 80 columns with line breaks for readability:

**Good:**
```python
"""
Args:
    payload: Dictionary from external API
             Expected structure:
             {'text': str, 'session_id'?: str}
"""
```

**Bad:**
```python
"""
Args:
    payload: Dictionary from external API with expected structure: {'text': str, 'session_id'?: str}
"""
```

---

## Anti-Patterns to Avoid

### ❌ Repeating Signature

**Bad:**
```python
def calculate(x: int, y: int) -> int:
    """
    Calculate x and y.

    Args:
        x: An integer
        y: An integer

    Returns:
        An integer
    """
```

### ❌ Generic Descriptions

**Bad:**
```python
class UserManager:
    """This class handles user data."""
```

### ❌ Missing Context for External Data

**Bad:**
```python
def process_api_data(payload: dict) -> Result:
    """Process payload and return result."""
```

### ❌ Missing Boundaries for Complex Modules

**Bad:**
```python
"""User management module."""
```

### ❌ Type Info in Docstring Body

**Bad:**
```python
"""
Args:
    user (User): The user object
"""
```

---

## Quick Reference

**Module Keys**: Architecture, Responsibility, Should, Boundaries, Entry
**Class Keys**: Responsibility, Boundaries, Role, Attributes, Methods
**Function Keys**: Responsibility, Context, Args, Returns, Raises, Note

**Remember:** Add semantic value, explain WHY, maintain 80 columns, types in signatures only.
