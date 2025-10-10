# Semantic Docstrings - Complete Examples

This document contains comprehensive examples demonstrating semantic docstrings
at module, class, and function levels.

---

## Module Example

```python
"""
Debt negotiation conversation orchestrator.

Architecture:
    Orchestrator of conversation flow across agents.
    Acts as the entry point for external messages and routes them
    to appropriate domain-specific agents.

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

from typing import Optional, Tuple

def process_message(payload: dict) -> Tuple[str, Optional[str], Optional[str]]:
    """
    Responsibility:
        First line of defense for payload validation.

    Context:
        Payload comes from an EXTERNAL SOURCE and cannot be trusted.
        Enforces contract: text is mandatory; session/user IDs optional.

    Args:
        payload: Dictionary received from external API.

    Returns:
        (user_message, chat_session_id, chat_user_id)

    Raises:
        ValueError: If 'text' key is missing.
    """
    text = payload.get("text")
    if not text:
        raise ValueError("Missing 'text'")
    return text, payload.get("chat_session_id"), payload.get("chat_user_id")
```

### Key Points

- **Architecture**: Clearly states this is an "orchestrator"
- **Responsibility**: Single clear responsibility (routing between agents)
- **Should**: Lists positive responsibilities
- **Boundaries**: Explicitly states what's delegated or out of scope
- **Entry**: Documents public entry points
- **Function Context**: States data comes from external, untrusted source

---

## Class Example

```python
class IdentificationAgent:
    """
    Manages user identification state and conversation flow.

    Responsibility:
        Maintain identification state across conversation turns.
        Provide interface to check identification and retrieve credentials.

    Boundaries:
        Does NOT perform business logic — only manages conversation state.

    Role:
        State manager bridging stateless API calls and stateful context.

    Attributes:
        identified: Whether the user is identified.
        account_uuid: Account identifier if identified, else None.

    Methods:
        identify(): Attempts to identify the user.
    """

    def __init__(self) -> None:
        self.identified: bool = False
        self.account_uuid: str | None = None

    def identify(self, token: str) -> bool:
        """
        Responsibility:
            Toggle identification based on a token.

        Context:
            Token comes from an external provider and must be
            validated elsewhere.

        Args:
            token: Opaque token used to verify identity.

        Returns:
            Whether identification succeeded.
        """
        if token and token.startswith("valid-"):
            self.identified = True
            self.account_uuid = "uuid-1234"
        return self.identified
```

### Key Points

- **Responsibility**: Clear single responsibility (manage identification state)
- **Boundaries**: Explicitly states it does NOT do business logic
- **Role**: Describes architectural position ("state manager")
- **Attributes**: Semantic meaning of each attribute
- **Methods**: Brief semantic descriptions
- **Method Context**: States token comes from external source

---

## Function Example

```python
from decimal import Decimal

def calculate_discount(user_tier: int, amount: Decimal) -> Decimal:
    """
    Responsibility:
        Compute discount based on user tier and purchase amount.

    Context:
        Applies a maximum cap to ensure business constraints.

    Args:
        user_tier: Loyalty tier as an integer (e.g., 0..3).
        amount: Purchase amount to calculate discount from.

    Returns:
        Final discount amount (capped).

    Raises:
        ValueError: If amount is negative.
    """
    if amount < 0:
        raise ValueError("Negative amount")
    base = Decimal("0.05") + Decimal(user_tier) * Decimal("0.05")
    discount = amount * base
    cap = amount * Decimal("0.3")
    return min(discount, cap)
```

### Key Points

- **Responsibility**: Single responsibility statement
- **Context**: Explains business constraint (cap)
- **Args**: Explains semantic meaning and valid ranges
- **Returns**: States it's capped (semantic meaning)
- **Raises**: Documents when and why exception is raised

---

## Advanced Function Example (External Data)

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
    text = payload.get("text")
    if not text:
        raise ValueError("Missing 'text' in payload")

    return (
        text,
        payload.get("chat_session_id"),
        payload.get("chat_user_id"),
    )
```

### Key Points

- **Responsibility**: Clearly states this is "first line of defense"
- **Context**: Emphasizes data from EXTERNAL, UNTRUSTED source
- **Args**: Explicitly states expected structure and trust level
- **Returns**: Detailed breakdown of tuple components
- **Raises**: States what caller MUST do
- **Note**: Important clarification about validation scope

---

## Comparison: Before vs After

### ❌ Without Semantic Docstrings

```python
def process_payment(data: dict) -> bool:
    """Process payment."""
    # What data? From where? What does True mean?
    ...

class PaymentProcessor:
    """Handles payments."""
    # What's its responsibility? What doesn't it do?
    ...
```

### ✅ With Semantic Docstrings

```python
def process_payment(data: dict) -> bool:
    """
    Process payment request from external payment gateway.

    Responsibility:
        Validate payment data and forward to payment processor.

    Context:
        Data comes from EXTERNAL payment gateway (untrusted).
        This is first validation layer before charging.

    Args:
        data: Payment request from external gateway
              Expected: {'amount': float, 'currency': str, 'source': str}

    Returns:
        True if payment processing initiated successfully,
        False if validation failed or insufficient funds

    Raises:
        ValueError: If required fields missing - caller returns 400
        PaymentError: If processor unavailable - caller retries
    """
    ...

class PaymentProcessor:
    """
    Manages payment lifecycle and external gateway integration.

    Responsibility:
        Coordinate payment flow from validation to confirmation.

    Boundaries:
        Does NOT store payment data (delegated to database layer)
        Does NOT apply business rules (delegated to domain layer)

    Role:
        Adapter between internal payment model and external gateway.
    """
    ...
```

---

## Key Takeaways

### For Modules

1. **Always** state architectural role (orchestrator, adapter, domain, etc.)
2. **Always** define boundaries (what's delegated or out of scope)
3. **Always** list entry points (public functions)

### For Classes

1. **Always** state single responsibility
2. **Always** define boundaries (what it doesn't do)
3. **Always** describe architectural role
4. **Always** explain semantic meaning of attributes

### For Functions

1. **Always** explain WHY parameters exist (not just types)
2. **Always** state data origin and trust level for external data
3. **Always** explain semantic meaning of return values
4. **Always** document what caller must do with exceptions

### General Rules

1. **Type hints in signatures** - never in docstring body
2. **Explain WHY, not WHAT** - avoid repeating syntax
3. **Context is critical** - especially for external data
4. **Boundaries prevent scope creep** - state what's out of scope
5. **80 columns maximum** - maintain readability

---

## Anti-Pattern Examples

### ❌ Bad: Repeats Signature

```python
def calculate(x: int, y: int) -> int:
    """
    Args:
        x: An integer
        y: An integer

    Returns:
        An integer
    """
```

### ✅ Good: Adds Semantic Value

```python
def calculate_discount(user_tier: int, amount: Decimal) -> Decimal:
    """
    Args:
        user_tier: Loyalty tier for discount calculation (0-3)
        amount: Purchase amount to apply discount to

    Returns:
        Final discount amount, capped at 30% of purchase
    """
```

### ❌ Bad: Generic Description

```python
class Manager:
    """This class manages things."""
```

### ✅ Good: Specific Responsibility

```python
class PaymentManager:
    """
    Responsibility:
        Coordinate payment flow from validation to confirmation.

    Role:
        Adapter between internal payment model and external gateway.
    """
```

### ❌ Bad: Missing Context for External Data

```python
def handle_webhook(data: dict) -> Response:
    """Handle webhook data."""
```

### ✅ Good: States Data Origin and Trust

```python
def handle_webhook(data: dict) -> Response:
    """
    Process incoming webhook from external service.

    Context:
        Data comes from EXTERNAL webhook (untrusted source).
        First validation layer before processing.
    """
```

---

## Summary

Semantic docstrings transform code from **syntax-only** to **semantically rich**:

- **Syntax** tells you WHAT (types, structure)
- **Semantics** tells you WHY (purpose, context, boundaries)

This semantic layer:
- Preserves architectural intent
- Documents data origin and trust
- Defines clear boundaries
- Helps developers and LLMs understand the big picture
