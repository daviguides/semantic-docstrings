---
description: Add semantic docstring to current Python module
---

Add a semantic docstring to the current module following this template:

## Process

1. Read the module code to understand its purpose
2. Identify its architectural role in the system
3. Determine responsibilities and boundaries
4. Generate docstring using the structure below

## Module Docstring Template

```python
"""
[Brief 1-2 sentence module purpose - explain WHY it exists]

Architecture:
    [What is this module's primary role in system architecture?
     Examples: "Orchestrator", "Adapter", "Domain layer", etc.]

Responsibility:
    [Single overarching responsibility - one clear sentence]

Should:
    - [What it does - positive responsibility 1]
    - [What it does - positive responsibility 2]
    - [What it does - positive responsibility 3]

Boundaries:
    - [What it delegates to other modules]
    - [What is explicitly out of scope]
    - [What it does NOT handle]

Entry:
    - [public_function_1: Brief description of what it does]
    - [public_function_2: Brief description of what it does]
"""
```

## Example Output

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
```

## Guidelines

- **Architecture**: Think about the module's role in the big picture
- **Responsibility**: Should be a single, clear statement
- **Should**: List 3-5 positive responsibilities
- **Boundaries**: Explicitly state what's delegated or out of scope
- **Entry**: List public functions that serve as entry points

Ensure the docstring adds semantic value and explains WHY the module exists,
not just WHAT code it contains.
