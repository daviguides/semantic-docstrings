---
description: Add semantic docstring to a Python function
---

Add semantic docstring to the selected or specified function.

## Process

1. Identify the function's single responsibility
2. Understand the context (why it exists, when to call it)
3. Determine data origin and trust level for parameters
4. Document what each parameter represents semantically
5. Explain the meaning of the return value
6. Document exceptions and what callers must do
7. Generate docstring using the template below

## Function Docstring Template

```python
def function_name(arg1: Type1, arg2: Type2) -> ReturnType:
    """
    [One-line summary - what this function does]

    Responsibility:
        [Single responsibility - one clear statement about
         what this function is responsible for]

    Context:
        [Why it exists, when to call it, assumptions about
         data origin/trust level, preconditions]

    Args:
        arg1: [WHY it exists, constraints, semantic meaning
               - not just the type]
        arg2: [WHY it exists, constraints, semantic meaning
               - not just the type]

    Returns:
        [Semantic meaning of return value - what it represents,
         not just the type]

    Raises:
        ExceptionType: [Why it may be raised and what the caller
                        MUST do to handle it]

    Note:
        [Important gotchas, performance considerations, or
         special behavior that developers need to know]
    """
```

## Example Output

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

## Guidelines

### Responsibility
- Should be ONE clear statement
- Explains what this function is accountable for

### Context
- **Data origin**: Where does data come from? (external API, database, internal)
- **Trust level**: Is data trusted or untrusted?
- **When to call**: What triggers calling this function?
- **Assumptions**: What preconditions must be met?

### Args
- **WHY it exists**: Not just "user ID" but "user ID for authentication lookup"
- **Constraints**: Valid ranges, formats, required vs optional
- **Trust level**: Especially important for external data

### Returns
- **Semantic meaning**: What does the return value represent?
- **Structure details**: For complex returns, explain each component
- **None cases**: When/why is None returned?

### Raises
- **Why raised**: What condition triggers this exception?
- **Caller's responsibility**: What must the caller do?

### Note
- **Gotchas**: Non-obvious behavior
- **Performance**: If it's slow or resource-intensive
- **Side effects**: If it modifies state

## Anti-Patterns to Avoid

❌ **Repeating the signature**:
```python
Args:
    user: A User object
```

✅ **Adding semantic value**:
```python
Args:
    user: User account for loyalty tier determination and
          discount calculation. Must be authenticated.
```

❌ **Generic descriptions**:
```python
"""This function processes data"""
```

✅ **Specific responsibility**:
```python
"""
Responsibility:
    Validate external API payload before forwarding to
    business logic layer.
```

Explain WHY parameters exist and WHAT ROLE the function plays in the system.
