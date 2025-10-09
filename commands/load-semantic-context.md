---
description: Load semantic docstring standards for this session
---

Apply Semantic Docstrings standard throughout this session.

## Core Philosophy

**Syntax says WHAT, Semantics say WHY**

Docstrings add a **semantic layer** that pure syntax cannot express.
They explain Responsibility, Context, and Intention — not just implementation.

## Semantic Keys by Scope

### 📦 Module Level
- **Architecture**: Module's role in system architecture
- **Responsibility**: Overarching single responsibility
- **Should**: Positive responsibilities (what it does)
- **Boundaries**: Delegated tasks / out of scope (what it doesn't do)
- **Entry**: Public functions (entry points)

### 🏷️ Class Level
- **Responsibility**: Single responsibility of the class
- **Boundaries**: What the class does NOT handle
- **Role**: Position of this class in the system
- **Attributes**: Instance attributes with semantic meaning
- **Methods**: Key methods with brief descriptions

### ⚙️ Function Level
- **Responsibility**: Single responsibility of the function
- **Context**: Why it exists, when to call, assumptions about data origin/trust
- **Args**: Parameter meanings (WHY they exist, not just types)
- **Returns**: Semantic meaning of return value
- **Raises**: Why exceptions are raised and what caller must do
- **Note**: Important details, gotchas, or performance considerations

## Templates

### Module Template
```python
"""
[MODULE PURPOSE: 1–2 sentences]

Architecture:
    [Module's primary role in system architecture]

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
        [Single responsibility]

    Boundaries:
        [What this class does NOT handle]

    Role:
        [Position in the system]

    Attributes:
        attr1: [Meaning]
        attr2: [Meaning]

    Methods:
        method1(): [What it does]
    """
```

### Function Template
```python
def example_function(arg1: str, arg2: int) -> bool:
    """
    [One-line summary]

    Responsibility:
        [Single responsibility]

    Context:
        [Why it exists / assumptions]

    Args:
        arg1: [Why it exists / constraints]
        arg2: [Why it exists / constraints]

    Returns:
        [Meaning of return value]

    Raises:
        ValueError: [Why raised / caller's duty]

    Note:
        [Important details or gotchas]
    """
```

## Rules

1. **Always include type hints in signatures** (not in docstring body)
2. **Explain WHY, not WHAT** - avoid repeating what syntax already says
3. **Context over mechanics** - explain data origin, trust, assumptions
4. **Boundaries matter** - clearly state what's out of scope
5. **Maximum 80 columns** for docstrings with line breaks

## Examples

### Good Example (Semantic)
```python
def validate_payload(payload: dict) -> tuple[str, str | None]:
    """
    Validates incoming payload and extracts conversation data.

    Responsibility:
        First line of defense for data validation.

    Context:
        Payload comes from EXTERNAL SOURCE (WhatsApp API) and cannot
        be trusted. Enforces contract: text is mandatory; session_id
        optional.

    Args:
        payload: Dictionary from external API
                 Expected: {'text': str, 'session_id'?: str}

    Returns:
        (user_message, session_id)
        - user_message: Always present
        - session_id: None if anonymous

    Raises:
        ValueError: If 'text' missing — caller MUST handle
    """
```

### Bad Example (Repeats Syntax)
```python
def validate_payload(payload: dict) -> tuple[str, str | None]:
    """
    Validates payload and returns data.

    Args:
        payload: A dictionary

    Returns:
        A tuple with two values
    """
```

## Anti-Patterns to Avoid

❌ **Repeating syntax**: "Returns a string" when signature already says `-> str`
❌ **Generic descriptions**: "This function processes data"
❌ **Missing context**: Not explaining where data comes from or trust level
❌ **Missing boundaries**: Not stating what's delegated or out of scope
❌ **Type info in docstring**: Put types in signature, not docstring body

## Quality Checklist

Before considering a docstring complete:
- [ ] Adds semantic value beyond syntax
- [ ] Explains WHY, not just WHAT
- [ ] Uses appropriate semantic keys for scope (module/class/function)
- [ ] Context provided for external data sources
- [ ] Boundaries clearly stated for complex modules
- [ ] Maximum 80 columns maintained
- [ ] Type hints in signature only

Apply these standards to ALL Python code in this session.
