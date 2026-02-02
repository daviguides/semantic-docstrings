# Semantic Docstrings - Usage Patterns

This document provides **applied guidance** on when and how to use semantic docstrings
in different scenarios.

**Specifications**: @~/.claude/semantic-docstrings/spec/semantic-keys-spec.md

---

## When to Apply Semantic Docstrings

### Always Apply To

1. **Public APIs**: Any function/class exposed to external callers
2. **Entry points**: Functions called by frameworks, APIs, or external systems
3. **Domain logic**: Business rules, validation, transformation functions
4. **External data handlers**: Functions receiving data from APIs, databases, files
5. **Complex algorithms**: Non-trivial logic requiring context explanation

### Consider Skipping For

1. **Trivial getters/setters**: `def get_name(self) -> str: return self._name`
2. **Obvious private helpers**: `def _increment(x: int) -> int: return x + 1`
3. **Test functions**: Though test docstrings can be valuable
4. **Generated code**: Auto-generated boilerplate

**Guideline**: When in doubt, add semantic docstrings. Over-documentation is better
than under-documentation for maintainability.

---

## Pattern 1: Orchestrator Modules

**Use When**: Module coordinates between multiple components.

**Key Characteristics**:
- Architecture: "Orchestrator", "Coordinator", "Entry point"
- Multiple "Should" items (routing, validation, coordination)
- Clear Boundaries delegating to other modules
- Few Entry points (1-3 main functions)

**Example Structure**:
```python
"""
[System name] flow orchestrator.

Architecture:
    Entry point and orchestrator for [domain] workflow.
    Routes requests to specialized components.

Responsibility:
    Coordinate [process] flow across [components].

Should:
    - Receive and validate requests from [source]
    - Determine [state/condition]
    - Route to appropriate [handler]

Boundaries:
    - Do NOT implement [business logic] (delegated to domain layer)
    - Do NOT manage [resources] (delegated to infrastructure)
    - Do NOT handle [specific concern] (delegated to [module])

Entry:
    - main_function: Primary entry point called by [caller]
"""
```

**When to Use This Pattern**:
- API route handlers
- Main workflow modules
- Message processors
- Request dispatchers

---

## Pattern 2: Domain Logic Modules

**Use When**: Module implements business rules and validations.

**Key Characteristics**:
- Architecture: "Domain layer for [business concept]"
- Responsibility focused on business rules
- Boundaries exclude infrastructure concerns
- Multiple public functions for different rules

**Example Structure**:
```python
"""
[Business concept] domain logic.

Architecture:
    Domain layer implementing [concept] business rules.

Responsibility:
    Enforce [business concept] invariants and transformations.

Should:
    - Validate [business rule 1]
    - Apply [business transformation]
    - Calculate [business metric]

Boundaries:
    - Do NOT persist data (delegated to repository)
    - Do NOT call external services (delegated to adapters)
    - Do NOT handle presentation (delegated to API layer)

Entry:
    - validate_x: Enforce [rule]
    - calculate_y: Compute [metric]
"""
```

**When to Use This Pattern**:
- Business validation modules
- Calculation engines
- Domain model modules
- Rule engines

---

## Pattern 3: Adapter/Infrastructure Modules

**Use When**: Module interfaces with external systems.

**Key Characteristics**:
- Architecture: "Adapter for [external system]"
- Responsibility: Translate between internal and external models
- Boundaries exclude business logic
- Context emphasizes external data handling

**Example Structure**:
```python
"""
[External system] integration adapter.

Architecture:
    Adapter between internal [model] and external [system] API.

Responsibility:
    Translate requests/responses between internal and external formats.

Should:
    - Convert internal model to [system] format
    - Parse [system] responses to internal model
    - Handle [system]-specific errors

Boundaries:
    - Do NOT implement business logic (delegated to domain)
    - Do NOT persist data (delegated to repository)
    - Do NOT validate business rules (delegated to domain)

Entry:
    - send_request: Convert and send to external system
    - parse_response: Parse external response to internal model
"""
```

**When to Use This Pattern**:
- API clients
- Database adapters
- Message queue interfaces
- External service wrappers

---

## Pattern 4: State Management Classes

**Use When**: Class manages state across operations.

**Key Characteristics**:
- Responsibility: "Maintain [state] across [lifecycle]"
- Role: "State manager", "Context holder"
- Boundaries exclude business logic
- Attributes clearly documented

**Example Structure**:
```python
class StateManager:
    """
    Manages [concept] state across [lifecycle].

    Responsibility:
        Maintain [state] and provide interface to query/modify it.

    Boundaries:
        Does NOT implement business logic — only manages state.
        Does NOT validate rules — delegates to domain layer.

    Role:
        State holder bridging [source] and [sink].

    Attributes:
        state_field: [Meaning and lifecycle]
        data_field: [What it represents]

    Methods:
        update_state(): [When to call and effect]
        get_state(): [What it returns]
    """
```

**When to Use This Pattern**:
- Session managers
- Context holders
- Conversation state trackers
- Cache managers

---

## Pattern 5: External Data Handlers

**Use When**: Function receives data from external sources.

**Key Characteristics**:
- Context MUST state data origin and trust level
- Responsibility often "First line of defense" or "Validation entry point"
- Args clearly mark UNTRUSTED sources
- Raises document what caller must do with errors

**Example Structure**:
```python
def handle_external_data(payload: dict) -> ProcessedData:
    """
    Process incoming data from [external source].

    Responsibility:
        First validation layer for external [data type].

    Context:
        Data comes from EXTERNAL [source] (untrusted).
        [Verification] happens in [upstream component].
        This is first business logic after [authentication/validation].

    Args:
        payload: Data from external [source]
                 Expected: {[structure]}
                 Source: UNTRUSTED external [system]

    Returns:
        Processed data ready for [next step]

    Raises:
        ValueError: If required fields missing - caller returns 400
        [Error]: If [condition] - caller [action]

    Note:
        Does NOT validate [specific aspect] - happens in [component]
    """
```

**When to Use This Pattern**:
- Webhook handlers
- API request validators
- File parsers
- Message queue consumers

---

## Pattern 6: Transformation Functions

**Use When**: Function transforms data between representations.

**Key Characteristics**:
- Responsibility: "Transform [A] to [B]"
- Context explains WHY transformation exists
- Args state input format and constraints
- Returns state output format and guarantees

**Example Structure**:
```python
def transform_data(input_data: InputType) -> OutputType:
    """
    Transform [A format] to [B format] for [purpose].

    Responsibility:
        Convert between [source format] and [target format].

    Context:
        Called during [workflow stage] to prepare data for [consumer].
        Transformation is [lossy/lossless] and [assumptions].

    Args:
        input_data: [Source format] with [constraints]
                    Expected: [structure/range]

    Returns:
        [Target format] ready for [usage]
        Guaranteed: [invariants preserved]

    Raises:
        ValueError: If input violates [constraint] - indicates bug
    """
```

**When to Use This Pattern**:
- Format converters
- Data mappers
- Serializers/deserializers
- DTO converters

---

## Pattern Selection Guide

| Your Scenario | Use Pattern |
|---------------|-------------|
| Module coordinates between components | Pattern 1: Orchestrator |
| Module implements business rules | Pattern 2: Domain Logic |
| Module interfaces with external system | Pattern 3: Adapter/Infrastructure |
| Class holds state across operations | Pattern 4: State Management |
| Function receives external data | Pattern 5: External Data Handler |
| Function transforms between formats | Pattern 6: Transformation |

---

## Combining Patterns

**Real modules often combine multiple patterns.**

### Example: API Module

```python
"""
Payment API module.

Architecture:
    API layer entry point for payment operations.          # Pattern 1 (Orchestrator)
    Adapter between HTTP requests and domain logic.        # Pattern 3 (Adapter)

Responsibility:
    Receive payment requests and orchestrate processing.

Should:
    - Validate incoming HTTP requests                      # Pattern 5 (External Data)
    - Transform HTTP payload to domain model               # Pattern 6 (Transformation)
    - Route to appropriate domain handler                  # Pattern 1 (Orchestrator)
    - Convert domain result to HTTP response               # Pattern 6 (Transformation)

Boundaries:
    - Do NOT implement payment logic (delegated to domain)
    - Do NOT persist transactions (delegated to repository)
    - Do NOT call payment gateway (delegated to adapter)

Entry:
    - process_payment: Main endpoint handler
    - validate_payment: Pre-processing validation
"""
```

---

## Context Patterns for Different Data Sources

### Pattern A: Trusted Internal Data

```python
def process_validated_user(user: User) -> Result:
    """
    Context:
        User comes from authenticated session (trusted).
        Validation completed upstream in authentication middleware.
        Assumes user has required permissions.
    """
```

### Pattern B: Untrusted External Data

```python
def process_webhook(payload: dict) -> Response:
    """
    Context:
        Payload comes from EXTERNAL webhook (untrusted source).
        Signature verification happens in middleware.
        This is first business validation layer.
    """
```

### Pattern C: Partially Validated Data

```python
def apply_discount(request: DiscountRequest) -> Decimal:
    """
    Context:
        Request validated for schema but NOT for business rules.
        Amount format verified, but amount validity not checked.
        Business validation happens here.
    """
```

### Pattern D: Database Data

```python
def enrich_user_profile(user_id: str) -> EnrichedProfile:
    """
    Context:
        User ID comes from trusted database (authenticated source).
        Assumes user exists (caller checks via try/except).
        Profile data fetched from verified internal storage.
    """
```

---

## Semantic Value Progression

### Level 1: Basic (Minimal Compliance)

```python
def calculate(amount: Decimal) -> Decimal:
    """
    Calculate discount.

    Args:
        amount: Purchase amount

    Returns:
        Discount amount
    """
```
**Semantic value**: ~30% (adds minimal context)

---

### Level 2: Good (Standard)

```python
def calculate_discount(amount: Decimal) -> Decimal:
    """
    Calculate loyalty discount with maximum cap.

    Args:
        amount: Purchase amount for discount calculation
                Must be positive (validated upstream)

    Returns:
        Discount amount, capped at 30% of purchase
    """
```
**Semantic value**: ~70% (explains purpose and constraints)

---

### Level 3: Excellent (Exemplary)

```python
def calculate_discount(amount: Decimal) -> Decimal:
    """
    Calculate loyalty discount based on purchase volume.

    Responsibility:
        Apply tiered discount rules with maximum business cap.

    Context:
        Called during checkout after amount validation.
        Discount rate increases with purchase volume.
        Cap prevents excessive discounts on large purchases.

    Args:
        amount: Purchase amount for volume-based discount calculation
                Expected range: 0.01 to 10000.00
                Already validated for format and range

    Returns:
        Final discount amount, capped at 30% of purchase amount
        Never exceeds 3000.00 (30% of max purchase)

    Note:
        Formula: 5% + (0.5% per $100 purchased)
        Example: $500 purchase = 5% + 2.5% = 7.5% = $37.50
    """
```
**Semantic value**: ~90% (comprehensive context and examples)

---

## When to Use Which Keys

### Always Use

| Scope | Keys |
|-------|------|
| Module | Architecture, Responsibility |
| Class | Responsibility, Role |
| Function | Responsibility, Args (if params exist), Returns (if return value) |

### Use When Applicable

| Scope | Key | When to Use |
|-------|-----|-------------|
| Module | Should | ≥3 concrete responsibilities |
| Module | Boundaries | Potential scope ambiguity |
| Module | Entry | Has public functions |
| Class | Boundaries | Could have scope confusion |
| Class | Attributes | Has non-trivial instance attributes |
| Class | Methods | Has ≥4 methods |
| Function | Context | Handles external data OR complex workflow |
| Function | Raises | Can raise exceptions |
| Function | Note | Has caveats, gotchas, or performance notes |

---

## Reference

This document provides applied patterns. For:
- Semantic key definitions → @~/.claude/semantic-docstrings/spec/semantic-keys-spec.md
- Normative templates → @~/.claude/semantic-docstrings/spec/templates-spec.md
- Anti-patterns to avoid → @~/.claude/semantic-docstrings/spec/anti-patterns-spec.md
- Concrete examples → @~/.claude/semantic-docstrings/context/examples.md
- Quick reference → @~/.claude/semantic-docstrings/context/quick-reference.md
