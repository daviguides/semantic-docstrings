# Anti-Patterns and Rules Specification

## Purpose

This specification defines **normative rules** and **anti-patterns to avoid**
when writing semantic docstrings.

**Core Principle**: Docstrings must add semantic value beyond what syntax expresses.

---

## Fundamental Rules

### Rule 1: Type Hints Belong in Signatures

**Always:**
- ✅ Put type hints in function/method/variable signatures
- ✅ Use modern Python 3.10+ syntax (`list[str]`, `dict[str, int]`)
- ✅ Use `| None` instead of `Optional[T]`

**Never:**
- ❌ Put type information in docstring body
- ❌ Repeat what the signature already says

#### Examples

❌ **Bad** (types in docstring):
```python
def process(user: User, amount: Decimal) -> bool:
    """
    Args:
        user (User): The user object
        amount (Decimal): A decimal amount

    Returns:
        bool: True or False
    """
```

✅ **Good** (types in signature only):
```python
def process(user: User, amount: Decimal) -> bool:
    """
    Args:
        user: User account for loyalty tier determination
        amount: Purchase amount for discount calculation

    Returns:
        True if discount applied successfully, False otherwise
    """
```

---

### Rule 2: Explain WHY, Not WHAT

**Purpose**: Docstrings must explain semantic meaning, not repeat syntax.

**What to explain:**
- WHY a parameter exists (its purpose)
- WHY a function exists (its responsibility)
- WHY exceptions are raised (their intention)
- WHERE data comes from (origin and trust level)
- WHAT the return value represents (semantic meaning)

**What NOT to explain:**
- Types (already in signature)
- Basic syntax (obvious from code)
- Implementation details (changes frequently)

#### Examples

❌ **Bad** (repeats WHAT):
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

✅ **Good** (explains WHY):
```python
def calculate_discount(user_tier: int, purchase_amount: Decimal) -> Decimal:
    """
    Calculate discount based on user loyalty and purchase volume.

    Args:
        user_tier: Loyalty tier (0-3) for discount rate determination
        purchase_amount: Total purchase for volume-based calculation

    Returns:
        Final discount amount, capped at 30% of purchase
    """
```

---

### Rule 3: Context for External Data is Critical

**Requirement**: Functions handling external data MUST state:
1. Data origin (API, database, user input, file system)
2. Trust level (trusted/untrusted/validated/unvalidated)
3. Validation responsibility (who validates what)

#### Examples

❌ **Bad** (no context):
```python
def process_webhook(data: dict) -> Response:
    """Process webhook data."""
```

✅ **Good** (explicit context):
```python
def process_webhook(data: dict) -> Response:
    """
    Process incoming webhook from external payment gateway.

    Context:
        Data comes from EXTERNAL webhook (untrusted source).
        First validation layer before any business logic.
        Signature verification happens upstream in middleware.

    Args:
        data: Webhook payload from payment gateway
              Expected: {'event': str, 'amount': float}
              Source: UNTRUSTED external API
    """
```

---

### Rule 4: Boundaries Prevent Scope Creep

**Requirement**: Modules and classes MUST state what they do NOT do when scope could be ambiguous.

**Purpose**: Prevents future scope creep and clarifies architectural boundaries.

#### Examples

❌ **Bad** (no boundaries):
```python
"""User management module."""
```

✅ **Good** (explicit boundaries):
```python
"""
User authentication and session management.

Architecture:
    Domain layer for user authentication lifecycle.

Responsibility:
    Manage user authentication state and session tokens.

Should:
    - Validate user credentials against database
    - Create and revoke session tokens
    - Track active user sessions

Boundaries:
    - Do NOT manage user registration (delegated to registration module)
    - Do NOT handle authorization/permissions (delegated to authz module)
    - Do NOT store user profile data (delegated to profile module)

Entry:
    - authenticate: Validate credentials and create session
    - revoke_session: Invalidate user session token
"""
```

---

### Rule 5: Maximum 80 Columns

**Requirement**: All docstring lines must be ≤80 columns for readability.

**How to comply:**
- Break long lines with proper indentation
- Align continuation lines with opening text
- Use multi-line format for complex structures

#### Examples

❌ **Bad** (exceeds 80 columns):
```python
"""
Args:
    payload: Dictionary from external API with expected structure: {'text': str, 'session_id'?: str, 'user_id'?: str}
"""
```

✅ **Good** (respects 80 column limit):
```python
"""
Args:
    payload: Dictionary from external API
             Expected structure:
             {'text': str, 'session_id'?: str, 'user_id'?: str}
             Source: UNTRUSTED external API
"""
```

---

## Anti-Patterns

### Anti-Pattern 1: Repeating Signature

**Problem**: Docstring adds no value beyond what signature already says.

❌ **Bad**:
```python
def send_email(to: str, subject: str, body: str) -> bool:
    """
    Send email.

    Args:
        to: A string
        subject: A string
        body: A string

    Returns:
        A boolean
    """
```

✅ **Good**:
```python
def send_email(to: str, subject: str, body: str) -> bool:
    """
    Send notification email via external SMTP server.

    Responsibility:
        Queue email for delivery through external service.

    Context:
        Email service is external and may be unavailable.
        Caller should handle delivery failures gracefully.

    Args:
        to: Recipient email address (must be validated upstream)
        subject: Email subject line (maximum 200 characters)
        body: Email body content (plain text or HTML)

    Returns:
        True if email queued successfully, False if service unavailable

    Raises:
        ValueError: If recipient email format invalid (defensive check)
        SMTPError: If SMTP server connection fails - caller retries
    """
```

---

### Anti-Pattern 2: Generic Descriptions

**Problem**: Vague descriptions that could apply to any code.

❌ **Bad**:
```python
class Manager:
    """This class manages things."""

def process_data(data: dict) -> Result:
    """Process data and return result."""

"""Utility module."""
```

✅ **Good**:
```python
class PaymentProcessor:
    """
    Manages payment lifecycle from validation to settlement.

    Responsibility:
        Coordinate payment flow through external gateway and
        internal accounting system.

    Role:
        Adapter between internal payment model and external
        payment gateway API.
    """

def validate_payment_data(data: dict) -> ValidationResult:
    """
    Validate payment request data before processing.

    Responsibility:
        First line of defense for payment data validation.

    Context:
        Data comes from EXTERNAL payment form (untrusted).
        Enforces: amount > 0, currency valid, source token present.

    Returns:
        ValidationResult with errors list if validation failed
    """

"""
Payment domain module.

Architecture:
    Domain layer for payment business logic.

Responsibility:
    Implement payment validation rules and workflow orchestration.

Boundaries:
    - Do NOT interact with payment gateway (delegated to adapter)
    - Do NOT persist transactions (delegated to repository)
"""
```

---

### Anti-Pattern 3: Missing Context for External Data

**Problem**: No indication of data origin or trust level.

❌ **Bad**:
```python
def handle_request(payload: dict) -> Response:
    """Handle incoming request."""
```

✅ **Good**:
```python
def handle_request(payload: dict) -> Response:
    """
    Handle incoming webhook request from external service.

    Context:
        Payload comes from EXTERNAL webhook (untrusted source).
        Signature verification happens in middleware.
        This is first business logic layer after authentication.

    Args:
        payload: Webhook payload from external service
                 Expected: {'event': str, 'data': dict}
                 Source: UNTRUSTED (authenticated but not validated)
    """
```

---

### Anti-Pattern 4: Missing Boundaries for Complex Modules

**Problem**: No clear indication of what module does NOT do.

❌ **Bad**:
```python
"""User module."""
```

✅ **Good**:
```python
"""
User authentication and session management.

Architecture:
    Domain layer for authentication lifecycle.

Responsibility:
    Manage user authentication state and session tokens.

Should:
    - Validate credentials
    - Create session tokens
    - Track active sessions

Boundaries:
    - Do NOT handle registration (delegated to registration module)
    - Do NOT manage permissions (delegated to authorization module)
    - Do NOT store profile data (delegated to profile module)
"""
```

---

### Anti-Pattern 5: Implementation Details in Docstrings

**Problem**: Documenting HOW instead of WHY, coupling docs to implementation.

❌ **Bad**:
```python
def sort_users(users: list[User]) -> list[User]:
    """
    Sort users using quicksort algorithm with O(n log n) complexity.
    Uses two pointers and pivot selection strategy.
    """
```

✅ **Good**:
```python
def sort_users(users: list[User]) -> list[User]:
    """
    Sort users by registration date (newest first) for display.

    Responsibility:
        Order users for presentation in dashboard.

    Context:
        Called when rendering user list in admin panel.
        Sorting is in-memory; assumes user list fits in memory.

    Args:
        users: User list to sort (typically <10,000 users)

    Returns:
        Sorted list with newest registered users first

    Note:
        For large datasets (>10,000 users), consider database sorting
        instead to avoid memory issues.
    """
```

---

### Anti-Pattern 6: Inconsistent Semantic Keys

**Problem**: Using verbose keys instead of one-word semantic keys.

❌ **Bad**:
```python
"""
ARCHITECTURAL RESPONSIBILITY:
    This module is responsible for...

WHAT IT SHOULD DO:
    - Thing 1
    - Thing 2

WHAT IT SHOULD NOT DO:
    - Thing 3
"""
```

✅ **Good**:
```python
"""
Architecture:
    Domain layer for payment processing.

Responsibility:
    Coordinate payment validation and settlement.

Should:
    - Validate payment requests
    - Coordinate with external gateway

Boundaries:
    - Do NOT persist transactions (delegated to repository)
"""
```

---

## Quality Checklist

Before considering a docstring complete, verify:

- [ ] **Adds semantic value** beyond syntax
- [ ] **Explains WHY**, not just WHAT
- [ ] **Type hints in signature only** (not in docstring body)
- [ ] **Uses appropriate semantic keys** for scope (module/class/function)
- [ ] **Context provided** for external data sources
- [ ] **Trust level stated** (trusted/untrusted) for external inputs
- [ ] **Boundaries clearly stated** for modules and classes
- [ ] **Maximum 80 columns** maintained with line breaks
- [ ] **Consistent semantic keys** (Architecture, not "ARCHITECTURAL ROLE:")
- [ ] **No implementation details** (focuses on WHY, not HOW)

---

## Reference

This specification defines anti-patterns to avoid. For:
- Semantic key definitions → @spec/semantic-keys-spec.md
- Normative templates → @spec/templates-spec.md
- Validation checklist → @spec/validation-spec.md
- Applied examples → @context/examples.md
