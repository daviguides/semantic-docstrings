---
description: Add semantic docstring to a Python class
---

Add semantic docstring to the selected or specified class.

## Process

1. Identify the class's single responsibility
2. Determine what the class does NOT handle (boundaries)
3. Understand its role in the system architecture
4. Document key attributes and methods
5. Generate docstring using the template below

## Class Docstring Template

```python
class ClassName:
    """
    [Brief class purpose - 1-2 sentences explaining WHY it exists]

    Responsibility:
        [What is this class's single responsibility?
         Should be one clear statement]

    Boundaries:
        [What this class does NOT handle - be explicit about
         what's delegated or out of scope]

    Role:
        [Position/role of this class in the system architecture.
         Examples: "State manager", "Adapter", "Strategy", etc.]

    Attributes:
        attr1: [Semantic meaning - WHY it exists, not just its type]
        attr2: [Semantic meaning - WHY it exists, not just its type]

    Methods:
        method1(): [What it does - brief semantic description]
        method2(): [What it does - brief semantic description]
    """
```

## Example Output

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
        Does NOT validate credentials — delegated to external services.

    Role:
        State manager for user identification journey,
        bridging stateless API calls and stateful context.

    Attributes:
        context: Conversation context with identification state
        mcp_client: Client for external MCP tool interactions

    Methods:
        is_identified(): Check if user has completed identification
        get_credentials(): Retrieve CPF and account_uuid if identified
        process_message(): Handle incoming message and update state
    """
```

## Guidelines

- **Responsibility**: Focus on the ONE thing this class does
- **Boundaries**: Be explicit about what it doesn't do (helps prevent scope creep)
- **Role**: Explain its architectural position (adapter, manager, strategy, etc.)
- **Attributes**: Explain WHY each attribute exists, not just its type
- **Methods**: Brief semantic descriptions, not implementation details

Focus on WHY the class exists and its architectural role, not just listing
its structure.
