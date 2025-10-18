# Semantic Keys Specification

## Purpose

This specification defines the **normative semantic keys** used in Python docstrings
to express responsibility, context, and architectural intent beyond syntax.

**Core Philosophy**: Syntax says WHAT, Semantics say WHY.

---

## Semantic Keys by Scope

### Module-Level Keys

**Architecture**
- **Definition**: The module's primary role in the system architecture
- **Purpose**: Clarifies the module's architectural position (e.g., orchestrator, adapter, domain layer, infrastructure)
- **Required**: Yes, for all modules
- **Example**: "Orchestrator of conversation flow across agents" or "Domain layer for user authentication"

**Responsibility**
- **Definition**: The module's single overarching responsibility
- **Purpose**: States what the module is fundamentally responsible for (Single Responsibility Principle)
- **Required**: Yes, for all modules
- **Example**: "Coordinate message flow across agents" or "Manage user session lifecycle"

**Should**
- **Definition**: List of positive responsibilities the module fulfills
- **Purpose**: Enumerates concrete actions the module performs
- **Required**: Yes, for non-trivial modules
- **Format**: Bulleted list of actions
- **Example**:
  ```
  Should:
      - Receive and validate incoming messages from external sources
      - Determine conversation state (identified vs unidentified user)
      - Route messages to appropriate agent
  ```

**Boundaries**
- **Definition**: Explicitly states what the module does NOT do (delegated or out of scope)
- **Purpose**: Prevents scope creep and defines conceptual boundaries
- **Required**: Yes, for complex modules with potential ambiguity
- **Format**: Bulleted list of non-responsibilities
- **Example**:
  ```
  Boundaries:
      - Do not create or configure agents (delegated to agent modules)
      - Do not manage MCP connections (delegated to helpers)
      - Do not apply business rules (delegated to domain layer)
  ```

**Entry**
- **Definition**: Public functions that serve as entry points to the module
- **Purpose**: Documents the module's public API
- **Required**: Yes, for modules with public functions
- **Format**: Bulleted list of function names with brief descriptions
- **Example**:
  ```
  Entry:
      - process_message: Main public function called by API routes
      - validate_payload: Validates incoming payloads
  ```

---

### Class-Level Keys

**Responsibility**
- **Definition**: The class's single responsibility
- **Purpose**: States what the class is fundamentally responsible for (SRP)
- **Required**: Yes, for all classes
- **Example**: "Maintain identification state across conversation turns" or "Coordinate payment flow from validation to confirmation"

**Boundaries**
- **Definition**: Explicitly states what the class does NOT handle
- **Purpose**: Defines clear limitations and prevents scope creep
- **Required**: Yes, for complex classes
- **Example**: "Does NOT perform business logic — only manages conversation state persistence"

**Role**
- **Definition**: The class's position or function in the system architecture
- **Purpose**: Clarifies the class's architectural role
- **Required**: Yes, for non-trivial classes
- **Example**: "State manager for user identification journey, bridging stateless API calls and stateful context" or "Adapter between internal payment model and external gateway"

**Attributes**
- **Definition**: Semantic meaning of instance attributes
- **Purpose**: Explains WHY attributes exist, not just their types
- **Required**: Recommended for classes with non-obvious attributes
- **Format**: List of `attribute: meaning`
- **Example**:
  ```
  Attributes:
      identified: Whether the user is identified
      account_uuid: Account identifier if identified, else None
  ```

**Methods**
- **Definition**: Key methods with brief semantic descriptions
- **Purpose**: High-level overview of important methods
- **Required**: Optional, use for classes with many methods
- **Format**: List of `method(): brief description`
- **Example**:
  ```
  Methods:
      identify(): Attempts to identify the user
      get_credentials(): Retrieves CPF and account UUID if identified
  ```

---

### Function-Level Keys

**Responsibility**
- **Definition**: The function's single responsibility
- **Purpose**: States what the function is fundamentally responsible for
- **Required**: Yes, for all public functions
- **Example**: "First line of defense for data validation" or "Compute discount based on user tier and purchase amount"

**Context**
- **Definition**: Why the function exists, when to call it, and assumptions about data origin/trust
- **Purpose**: Provides critical semantic context about the function's role and data handling
- **Required**: Yes, especially for functions handling external data
- **Example**: "Payload comes from EXTERNAL SOURCE (WhatsApp API) and cannot be trusted. Called at API entry point before any business logic."

**Args**
- **Definition**: Semantic meaning of parameters — WHY they exist, not just their types
- **Purpose**: Explains the purpose, constraints, origin, and trust level of parameters
- **Required**: Yes, for all parameters
- **Format**: `param: semantic meaning and constraints`
- **Example**:
  ```
  Args:
      user_tier: Loyalty tier for discount calculation (valid range: 0-3)
      payload: Dictionary from external API (UNTRUSTED)
                Expected: {'text': str, 'session_id'?: str}
  ```

**Returns**
- **Definition**: Semantic meaning of the return value
- **Purpose**: Explains WHAT the return value represents and any constraints
- **Required**: Yes, for all functions with return values
- **Example**: "Final discount amount, capped at maximum allowed discount (25%)" or "True if payment processing initiated successfully, False if validation failed"

**Raises**
- **Definition**: Why exceptions are raised and what the caller must do
- **Purpose**: Documents exception handling contract between function and caller
- **Required**: Yes, for functions that raise exceptions
- **Format**: `ExceptionType: Why raised and caller's responsibility`
- **Example**:
  ```
  Raises:
      ValueError: If 'text' key is missing from payload
                  Caller MUST handle by returning 400 Bad Request
      PaymentError: If processor unavailable - caller retries
  ```

**Note**
- **Definition**: Important details, gotchas, performance considerations, or scope limitations
- **Purpose**: Captures critical information that doesn't fit other keys
- **Required**: Optional, use when there are important caveats
- **Example**: "This function does NOT validate text content or IDs format, only checks for presence. Content validation happens downstream."

---

## Key Selection Guidelines

### When to Use Module Keys

| Key | Use When |
|-----|----------|
| Architecture | Always (all modules must state their architectural role) |
| Responsibility | Always (all modules must have single responsibility) |
| Should | Module has ≥3 concrete responsibilities |
| Boundaries | Module has potential for scope ambiguity or creep |
| Entry | Module has public functions |

### When to Use Class Keys

| Key | Use When |
|-----|----------|
| Responsibility | Always (all classes must state single responsibility) |
| Boundaries | Class responsibility could be ambiguous |
| Role | Class has specific architectural position |
| Attributes | Class has non-trivial instance attributes |
| Methods | Class has ≥4 methods worth documenting |

### When to Use Function Keys

| Key | Use When |
|-----|----------|
| Responsibility | Always (all public functions) |
| Context | Always (especially for external data handling) |
| Args | Always (all parameters) |
| Returns | Function returns a value |
| Raises | Function can raise exceptions |
| Note | There are important caveats or limitations |

---

## Semantic Value Principle

**Every semantic key must add value beyond syntax.**

❌ **Bad** (repeats syntax):
```
Args:
    user: A User object
    amount: A Decimal
```

✅ **Good** (adds semantic meaning):
```
Args:
    user: User account for loyalty tier determination
          Must be authenticated
    amount: Purchase amount for volume-based discount calculation
            Expected range: 0.01 to 10000.00
```

---

## Reference

This specification defines the normative semantic keys. For:
- Templates implementing these keys → @spec/templates-spec.md
- Anti-patterns to avoid → @spec/anti-patterns-spec.md
- Validation checklist → @spec/validation-spec.md
- Applied examples → @context/examples.md
