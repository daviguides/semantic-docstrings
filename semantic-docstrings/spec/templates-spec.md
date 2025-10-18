# Docstring Templates Specification

## Purpose

This specification defines the **normative templates** for semantic docstrings
at module, class, and function levels.

**Reference**: Semantic keys are defined in @spec/semantic-keys-spec.md

---

## Module Template

```python
"""
[MODULE PURPOSE: 1-2 sentences explaining why this module exists]

Architecture:
    [What is this module's primary role in system architecture?]

Responsibility:
    [Single overarching responsibility]

Should:
    - [Responsibility 1]
    - [Responsibility 2]
    - [Responsibility 3]

Boundaries:
    - [Delegated responsibility 1]
    - [Out of scope 1]
    - [Out of scope 2]

Entry:
    - [public_function: Brief description]
    - [another_function: Brief description]
"""
```

### Module Template Notes

1. **Opening sentence**: 1-2 sentences maximum, states module's purpose
2. **Architecture**: Clarify architectural role (orchestrator, adapter, domain, etc.)
3. **Responsibility**: Single clear statement (SRP)
4. **Should**: ≥2 concrete positive responsibilities
5. **Boundaries**: ≥2 delegated or out-of-scope items
6. **Entry**: List all public functions with brief descriptions

### Module Template Example

```python
"""
Debt negotiation conversation orchestrator.

Architecture:
    Orchestrator of conversation flow across agents.
    Acts as the entry point for external messages.

Responsibility:
    Decide WHICH agent to use (identification vs negotiation)
    and WHEN to transition between them.

Should:
    - Receive and validate messages from external sources
    - Determine conversation state (identified vs unidentified)
    - Route messages to appropriate agent based on state

Boundaries:
    - Do not create/configure agents (delegated to agent modules)
    - Do not manage MCP connections/tools (delegated to helpers)
    - Do not apply business rules (delegated to domain layer)

Entry:
    - process_message: Main public function called by API routes
"""
```

---

## Class Template

```python
class ExampleClass:
    """
    [CLASS PURPOSE: 1-2 sentences]

    Responsibility:
        [What is this class's single responsibility?]

    Boundaries:
        [What this class does NOT handle]

    Role:
        [Position of this class in the system]

    Attributes:
        attr1: [Semantic meaning]
        attr2: [Semantic meaning]

    Methods:
        method1(): [What it does]
        method2(): [What it does]
    """
```

### Class Template Notes

1. **Opening sentence**: 1-2 sentences maximum, states class purpose
2. **Responsibility**: Single clear responsibility (SRP)
3. **Boundaries**: What the class explicitly does NOT do
4. **Role**: Architectural position (adapter, manager, state holder, etc.)
5. **Attributes**: Semantic meaning of each attribute (not types)
6. **Methods**: Optional, for classes with ≥4 methods

### Class Template Example

```python
class IdentificationAgent:
    """
    Manages user identification state and conversation flow.

    Responsibility:
        Maintain identification state across conversation turns.
        Provide clear interface to check if user is identified
        and retrieve credentials (CPF, account_uuid).

    Boundaries:
        Does NOT perform business logic — only manages conversation
        state persistence.

    Role:
        State manager for user identification journey,
        bridging stateless API calls and stateful context.

    Attributes:
        identified: Whether the user is identified
        account_uuid: Account identifier if identified, else None

    Methods:
        is_identified(): Check if user has completed identification
        get_credentials(): Retrieve CPF and account_uuid if identified
        process_message(): Handle incoming message and update state
    """
```

---

## Function Template

```python
def example_function(arg1: str, arg2: int) -> bool:
    """
    [One-line summary of function purpose]

    Responsibility:
        [What is this function's single responsibility?]

    Context:
        [Why it exists, when to call, assumptions about data]

    Args:
        arg1: [Why it exists / semantic meaning / constraints]
        arg2: [Why it exists / semantic meaning / constraints]

    Returns:
        [Semantic meaning of return value]

    Raises:
        ExceptionType: [Why raised and what caller must do]

    Note:
        [Important details, gotchas, or performance considerations]
    """
```

### Function Template Notes

1. **Opening line**: Single sentence summary of purpose
2. **Responsibility**: Single clear responsibility statement
3. **Context**: WHY function exists, data origin, trust level
4. **Args**: Semantic meaning (NOT just types), constraints, origin
5. **Returns**: WHAT the value represents semantically
6. **Raises**: WHY each exception occurs and caller's duty
7. **Note**: Optional, for important caveats

### Function Template Example (Standard)

```python
from decimal import Decimal

def calculate_discount(user_tier: int, amount: Decimal) -> Decimal:
    """
    Calculate discount based on user loyalty tier and purchase volume.

    Responsibility:
        Compute final discount amount applying tier and volume rules.

    Context:
        Applies maximum cap to ensure business constraints are met.
        Called during checkout process after amount validation.

    Args:
        user_tier: Loyalty tier as integer (valid range: 0-3)
                   Higher tier = higher discount
        amount: Purchase amount for discount calculation
                Must be positive, already validated

    Returns:
        Final discount amount, capped at 30% of purchase amount

    Raises:
        ValueError: If amount is negative (should not happen if
                    validation passed, but defensive check)

    Note:
        Discount formula: base (5%) + tier * 5% per tier level
        Maximum cap: 30% regardless of tier
    """
```

### Function Template Example (External Data)

```python
def validate_and_extract_payload(
    payload: dict,
) -> tuple[str, str | None, str | None]:
    """
    Validates incoming payload and extracts essential conversation data.

    Responsibility:
        First line of defense for data validation.
        All subsequent processing assumes this contract is met.

    Context:
        Payload comes from EXTERNAL SOURCE (WhatsApp API) and cannot
        be trusted. Called at API entry point before any business logic.
        Enforces contract: text is mandatory; session/user IDs optional.

    Args:
        payload: Dictionary from external API
                 Expected structure:
                 {'text': str, 'chat_session_id'?: str, 'chat_user_id'?: str}
                 Source: UNTRUSTED external API

    Returns:
        (user_message, chat_session_id, chat_user_id)
        - user_message: Always present, extracted text content
        - chat_session_id: None if anonymous conversation
        - chat_user_id: None if anonymous conversation

    Raises:
        ValueError: If 'text' key is missing from payload
                    Caller MUST handle by returning 400 Bad Request

    Note:
        This function does NOT validate text content or IDs format,
        only checks for presence. Content validation happens downstream.
    """
```

---

## Template Selection Guide

### Choose Module Template When
- Documenting a Python module (.py file)
- Module contains multiple functions/classes
- Module has clear architectural role

### Choose Class Template When
- Documenting a Python class
- Class has clear single responsibility
- Class has instance attributes or multiple methods

### Choose Function Template When
- Documenting a function (module-level or method)
- Function is public (part of API)
- Function has parameters or return value

---

## Required vs Optional Keys

### Module Docstrings

| Key | Required? | When Optional |
|-----|-----------|---------------|
| Architecture | **Required** | Never |
| Responsibility | **Required** | Never |
| Should | **Required** | Only if module has <3 responsibilities |
| Boundaries | Recommended | Simple modules with no ambiguity |
| Entry | **Required** | Only if module has no public functions |

### Class Docstrings

| Key | Required? | When Optional |
|-----|-----------|---------------|
| Responsibility | **Required** | Never |
| Boundaries | Recommended | Simple classes with obvious scope |
| Role | **Required** | Never |
| Attributes | Recommended | Trivial attributes (e.g., simple flags) |
| Methods | Optional | Classes with <4 methods |

### Function Docstrings

| Key | Required? | When Optional |
|-----|-----------|---------------|
| Responsibility | **Required** | Never |
| Context | **Required** | Internal helper functions (but still recommended) |
| Args | **Required** | Functions with no parameters |
| Returns | **Required** | Functions with no return value |
| Raises | **Required** | Functions that don't raise exceptions |
| Note | Optional | No special caveats to document |

---

## Formatting Rules

### Maximum Width
- **80 columns maximum** for all docstring content
- Break long lines with proper indentation

### Indentation
- 4 spaces for all keys and content
- Align continuation lines with opening text

### Blank Lines
- One blank line between opening sentence and first key
- No blank lines between keys
- One blank line before closing `"""`

### Example of Proper Formatting

```python
def example(long_parameter_name: dict) -> bool:
    """
    Process incoming request with extensive validation.

    Responsibility:
        Validate and transform external request data into internal
        format for downstream processing.

    Context:
        Data comes from EXTERNAL API (untrusted source).
        First validation layer before any business logic.

    Args:
        long_parameter_name: Dictionary from external API containing
                             user request data in format:
                             {'action': str, 'params': dict}

    Returns:
        True if validation passed and transformation succeeded,
        False if data was invalid or transformation failed

    Raises:
        ValueError: If required fields missing - caller returns 400
        TransformError: If data format invalid - caller returns 422
    """
```

---

## Reference

This specification defines normative templates. For:
- Semantic key definitions → @spec/semantic-keys-spec.md
- Anti-patterns to avoid → @spec/anti-patterns-spec.md
- Validation checklist → @spec/validation-spec.md
- Applied examples → @context/examples.md
