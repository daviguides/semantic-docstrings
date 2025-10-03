---
layout: page
title: Full Specification
---

### TL;DR:
* **What it is:** An **extension** of Google Style that adds the **"why"** (purpose, context) to the existing **"what"** (parameters, returns).
* **How it works:** It adds **keywords** like `Responsibility`, `Architecture`, and `Boundaries` to define the code's strategic role in the system.
* **Why it matters:** The result is code that's **easier to maintain**, has clear architectural boundaries, and is better understood by both **developers and LLMs**.

### Semantic Docstrings: Writing Code That Explains the 'Why'

**The Zen of Python reminds us: "Readability counts."**

#### From 'What' to 'Why': Extending the Google Style

Many developers are already familiar with and use established documentation standards, such as **Google Style Docstrings**. This standard is excellent for standardizing the description of technical elements like arguments (`Args`), returns (`Returns`), and exceptions (`Raises`), ensuring a fundamental consistency about *what* a function does mechanically.

However, its structure, by itself, primarily answers "what" and "how." The fundamental question that often remains unanswered is **"why"**: Why does this module exist in the architecture? What is the single responsibility of this class? In what context should this function be called?

It is precisely this gap that the **Semantic Docstrings** approach aims to fill. It does not replace, but rather **extends** the Google Style by adding a vocabulary of semantic keys like `Architecture`, `Responsibility`, `Boundaries`, `Context`, and `Role`. These keys encourage us to document the architectural intent and strategic purpose of the code, creating a layer of meaning that goes beyond technical description.

#### The Essence

Docstrings add a **layer of meaning** that pure syntax cannot express. They explain the **Responsibility**, **Context**, and **Intention** behind the code, not just its implementation details.

> The critical insight here is that docstrings are not just for guiding a new developer; they add a **semantic layer** that transcends syntax. Code without docstrings tells you *WHAT* it does, while code with semantic docstrings explains *WHY* it does it.

-----

### What Syntax (and Standard Styles) Don't Always Express

To illustrate the evolution of meaning in documentation, let's analyze the same function in three stages: with only its syntax, then with a standard docstring (Google Style), and finally, enriched with a semantic docstring.

#### **Stage 1: Syntax Only (The Mechanical 'What')**

At the most basic level, we have only the function's signature, which describes the input and output data types.

```python
# ❌ SYNTAX ONLY
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    ...
```

This declaration tells us that the function operates on a `User` and a `Decimal` to produce another `Decimal`. It answers "what" in terms of types but offers no clues about the business logic, or purpose. We know the "bricks," but not the "blueprint."

#### **Stage 2: Adding Google Style (The Descriptive 'What')**

The next level is to add a docstring following a standard like Google's. This already represents a huge leap in readability.

```python
# 🟡 SYNTAX + GOOGLE STYLE
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    """Calculates a discount based on user loyalty and purchase volume.

    Args:
        user: The user account to determine the loyalty tier.
        amount: The purchase amount for the volume-based calculation.

    Returns:
        The final discount amount, capped at the maximum allowed.
    """
    ...
```

Here, we already understand what each parameter represents and what the return value means. The code becomes functionally understandable. We know `user` is for "loyalty" and `amount` is for "volume." This is excellent documentation of the functional *what*.

#### **Stage 3: Adding the Semantic Layer (The Strategic 'Why')**

The final stage is to extend the Google Style with semantic keys to reveal the **intention** and **architectural context**.

```python
# ✅ SYNTAX + SEMANTIC DOCSTRINGS
def calculate_discount(user: User, amount: Decimal) -> Decimal:
    """Calculates a discount based on user loyalty and purchase volume.

    Responsibility:
        To be the single source of truth for all business discount logic.
        Centralizes rules to ensure consistency across the application.

    Context:
        This function is called during the checkout process before payment.
        It assumes business rules for loyalty and volume are configured
        externally and may change.

    Args:
        user: The user account to determine the loyalty tier.
        amount: The purchase amount for the volume-based calculation.

    Returns:
        The final discount amount, capped at the maximum allowed.

    Note:
        The maximum discount is controlled by a global application setting
        and this function will never exceed it.
    """
    ...
```

This final version reaches a new level of clarity. In addition to everything Google Style already offered, it now explains:

  * **Responsibility**: The function's strategic role is to be the **single source of truth** for discount logic.
  * **Context**: It tells us *when* it's called (during checkout) and under what *assumptions* it operates (externally configured rules).
  * **Note**: It alerts us to an important external constraint (the maximum cap is a global setting).

The semantic layer not only describes the function but also positions it within the system, explaining its purpose and its interactions with the rest of the application. The strategic "why" finally becomes explicit.

-----

### Levels of Meaning

This approach applies to all layers of an application, from the architectural definition of a module to the details of a class or function.

#### **Modules: Architectural Role**

A module's docstring should never be a mere repetition of its filename. It must declare its place and function within the system's architecture.

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

The semantics here explain **WHY** the module exists (acting as an "orchestrator"), **WHAT** its role in the architecture is, its conceptual **BOUNDARIES** (what it should do vs. what it delegates), and its public **ENTRY** points.

#### **Functions: Context and Intention**

For functions, the docstring goes beyond a basic description, providing operational context and the intent behind its interface.

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

Semantics add clarity about the function's **Responsibility** (the architectural contract of being the "first line of defense"), its execution **Context** (the origin and trustworthiness of the data), the semantic meaning of its **Return** value, and the intent behind using **Exceptions**.

#### **Classes: Boundaries and Role in the System**

A class represents an entity or concept in the system. Its docstring should clearly define its responsibility, its limits, and its role.

```python
# ❌ SYNTAX ONLY
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

The semantics explain the class's **Responsibility** (following the Single Responsibility Principle), its **Boundaries** (clear limitations on what it does not do), and its architectural **Role** (acting as a "state manager").

-----

### Applied Pattern: Complete Structure

Below is a template that consolidates this approach, serving as a guide for consistently applying semantic docstrings across modules, classes, and functions.

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
        [Position of this class in the system]

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

-----

### Why Does This Matter?

Adopting this practice brings benefits that go beyond simple documentation, impacting maintainability, collaboration, and integration with modern tools.

#### 1\. **Syntax → WHAT | Semantics → WHY**

Syntax describes the operation, while semantics reveal the intention.

```python
# Syntax says WHAT:
user: User, amount: Decimal -> Decimal

# Semantics says WHY:
user: "for loyalty tier determination"
amount: "for volume-based calculation"
return: "final discount with cap"
```

#### 2\. **Code Changes, Meaning Remains**

A function's implementation can be refactored countless times, but its responsibility and intention rarely change. The docstring preserves this conceptual knowledge, ensuring that new developers (or LLMs) understand the purpose, not just the current implementation.

#### 3\. **Prevents Semantic Coupling**

By defining clear boundaries, the docstring prevents a component's responsibilities from bleeding into others.

```python
"""
Boundaries:
    - Manage MCP connections (delegated to execution helpers)
"""
```

This establishes conceptual limits, not just technical ones, promoting a cleaner and more modular design.

#### 4\. **LLMs and Tools Understand Intention**

Documentation rich in semantics feeds the development ecosystem. An IDE's autocomplete displays context, not just type. Code reviews can focus on responsibility violations, and LLMs can generate code that is better aligned with the defined architecture and purpose.

-----

### Comparison: Syntax vs. Semantics

| Aspect | Syntax Only | With Semantic Layer |
|:---|:---|:---|
| **Module** | Filename | WHY it exists, WHAT its responsibility is |
| **Function** | Signature (types) | CONTEXT of args, INTENTION of return |
| **Class** | Attributes/methods | BOUNDARIES, ROLE in the system |
| **Arguments** | `user: User` | "User account for loyalty tier determination" |
| **Return** | `-> Decimal` | "Final discount amount, capped at maximum" |
| **Exception**| `raises ValueError` | "If 'text' is missing - caller MUST handle" |

-----

## def in(short) -> Semantic Docstrings:

* **Preserves Intent & Meaning:** It documents the strategic "why" of the code, not just the mechanical "what." This core meaning survives refactoring, unlike implementation details.
* **Creates Architectural Clarity:** It defines clear conceptual boundaries for each component, making the system self-explanatory and reducing the need for external documentation.
* **Accelerates Collaboration:** It speeds up onboarding for new developers, focuses code reviews on design principles, and dramatically improves the context for AI assistants (LLMs).