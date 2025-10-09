---
description: Validate semantic docstrings in current project
---

Validate all Python docstrings in the current project against semantic
docstring standards.

## Validation Process

Scan all Python files in the project and check docstrings for:

### 1. Completeness Check

- [ ] **All public modules** have docstrings
- [ ] **All public classes** have docstrings
- [ ] **All public functions** have docstrings
- [ ] **Private functions** (with complex logic) have docstrings

Public = not starting with underscore

### 2. Semantic Quality Check

- [ ] Docstrings explain **WHY**, not just WHAT
- [ ] **Context** is provided for functions handling external data
- [ ] **Boundaries** are clearly stated for modules/classes
- [ ] **Responsibilities** are single and clear
- [ ] Args explain semantic meaning, not just types

### 3. Structure Check

- [ ] Appropriate semantic keys used:
  - Modules: Architecture, Responsibility, Should, Boundaries, Entry
  - Classes: Responsibility, Boundaries, Role, Attributes, Methods
  - Functions: Responsibility, Context, Args, Returns, Raises
- [ ] Type hints in **signatures**, not in docstring body
- [ ] Maximum **80 columns** maintained (with line breaks if needed)

### 4. Anti-Pattern Detection

Flag these common issues:

❌ **Repeats signature without adding value**
```python
def calculate(x: int, y: int) -> int:
    """Calculate x and y and return int."""
```

❌ **Generic descriptions**
```python
"""This class handles user data."""
```

❌ **Missing Context for external data**
```python
def process_api_data(payload: dict) -> Result:
    """Process payload."""  # Missing: where does payload come from?
```

❌ **Missing Boundaries for complex modules**
```python
"""User management module."""  # Missing: what's in/out of scope?
```

❌ **Type information in docstring body**
```python
"""
Args:
    user (User): The user object  # Type already in signature!
"""
```

## Output Format

Provide validation results organized by severity:

### Critical Issues (Missing Docstrings)
```
File: src/payment.py:15
Issue: Public function 'process_payment' has no docstring
Action: Add docstring with Responsibility and Context
```

### Quality Issues (Poor Semantic Value)
```
File: src/payment.py:42
Issue: Docstring repeats signature without adding semantic value
Current: "Process payment data and return result"
Suggestion: Add Context explaining data comes from external API and
            is untrusted. Add Responsibility explaining this is the
            first validation layer.
```

### Structure Issues (Missing Keys)
```
File: src/workflow.py:1
Issue: Module docstring missing Architecture and Boundaries keys
Suggestion: Add Architecture to explain this is an orchestrator
            Add Boundaries to clarify what's delegated to other modules
```

### Style Issues (Formatting)
```
File: src/models.py:78
Issue: Docstring line exceeds 80 columns
Line: "This attribute stores the user's authentication credentials and session tokens for API access"
Suggestion: Break into multiple lines at 80 columns
```

## Statistics Summary

Provide a summary at the end:

```
Docstring Coverage:
  Modules: 8/10 (80%)
  Classes: 15/15 (100%)
  Functions: 42/50 (84%)

Semantic Quality:
  High quality: 35 (70%)
  Needs improvement: 15 (30%)

Common Issues:
  1. Missing Context for external data: 8 occurrences
  2. Generic descriptions: 5 occurrences
  3. Missing Boundaries: 3 occurrences
  4. Line length violations: 2 occurrences
```

## Prioritization

List issues by priority:

**Priority 1 - Critical** (No docstring)
- src/payment.py:15 - process_payment
- src/auth.py:42 - validate_token

**Priority 2 - High** (Missing critical semantic info)
- src/api.py:23 - handle_webhook (missing Context for external data)
- src/workflow.py:1 - Module missing Architecture

**Priority 3 - Medium** (Quality improvements)
- src/models.py:56 - Generic description, needs better Responsibility
- src/utils.py:12 - Args don't explain semantic meaning

**Priority 4 - Low** (Style/formatting)
- src/payment.py:78 - Line too long
- src/models.py:34 - Inconsistent formatting

Be specific, constructive, and provide actionable feedback with line references.
