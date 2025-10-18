# Validation Specification

## Purpose

This specification defines **normative criteria** for validating semantic docstrings
and ensuring compliance with the semantic docstrings standard.

---

## Validation Categories

### Category A: ✅ Compliant

Docstrings that fully meet the semantic docstrings standard.

**Criteria**:
- ✅ Possesses module docstring with Architecture/Responsibility/Should/Boundaries
- ✅ Functions/classes have Responsibility and Context
- ✅ Args explain WHY (not just types)
- ✅ Returns explain semantic meaning (not just types)
- ✅ Docstrings are synchronized with current code
- ✅ Follows all rules in @spec/anti-patterns-spec.md
- ✅ Maximum 80 columns maintained
- ✅ Type hints in signatures only

---

### Category B: ⚠️ Needs Adjustments

Docstrings exist but don't fully meet the standard.

**Criteria**:
- ⚠️ Has docstrings but they are generic/superficial
- ⚠️ Missing Architecture/Responsibility in module
- ⚠️ Missing Context in functions
- ⚠️ Docstrings desynchronized (parameters changed)
- ⚠️ Violates 80 column rule
- ⚠️ Types in docstring body instead of signature
- ⚠️ Repeats syntax without adding semantic value

---

### Category C: ❌ Non-Compliant

No semantic docstrings or fundamental violations.

**Criteria**:
- ❌ No module docstring
- ❌ Functions without docstrings
- ❌ Docstrings that merely repeat syntax
- ❌ No semantic keys used (Architecture, Responsibility, etc.)
- ❌ Generic descriptions ("This function processes data")

---

## Validation Checklists

### Module-Level Validation

**Required Elements**:
- [ ] Module has opening docstring
- [ ] **Architecture** key present and meaningful
- [ ] **Responsibility** key states single clear responsibility
- [ ] **Should** key lists ≥2 concrete responsibilities
- [ ] **Boundaries** key states ≥2 delegated/out-of-scope items
- [ ] **Entry** key lists all public functions

**Quality Checks**:
- [ ] Architecture states architectural role (not just description)
- [ ] Responsibility is single and clear (SRP)
- [ ] Should items are specific (not generic)
- [ ] Boundaries prevent scope creep
- [ ] Entry points match actual public functions

**Anti-Pattern Checks**:
- [ ] Does NOT repeat module name ("User module")
- [ ] Does NOT use vague descriptions ("Handles users")
- [ ] Does NOT duplicate information across keys

---

### Class-Level Validation

**Required Elements**:
- [ ] Class has docstring
- [ ] **Responsibility** key states single clear responsibility
- [ ] **Boundaries** key states what class does NOT do
- [ ] **Role** key describes architectural position
- [ ] **Attributes** key explains semantic meaning (if applicable)

**Quality Checks**:
- [ ] Responsibility is focused and specific (SRP)
- [ ] Boundaries clarify scope limits
- [ ] Role states architectural function
- [ ] Attributes explain WHY they exist (not just types)

**Anti-Pattern Checks**:
- [ ] Does NOT repeat class name
- [ ] Does NOT use generic descriptions ("Manages things")
- [ ] Does NOT include implementation details

---

### Function-Level Validation

**Required Elements**:
- [ ] Function has docstring with one-line summary
- [ ] **Responsibility** key states single clear responsibility
- [ ] **Context** key explains WHY function exists
- [ ] **Args** key documents all parameters with semantic meaning
- [ ] **Returns** key explains semantic meaning of return value
- [ ] **Raises** key documents exceptions with intention

**Quality Checks**:
- [ ] Responsibility is clear and specific
- [ ] Context states data origin for external data
- [ ] Context states trust level (trusted/untrusted)
- [ ] Args explain WHY each parameter exists
- [ ] Returns explain WHAT value represents
- [ ] Raises explain WHY exceptions occur and caller's duty

**Anti-Pattern Checks**:
- [ ] Does NOT repeat function signature
- [ ] Does NOT say "Args: x (int): An integer"
- [ ] Does NOT include types in docstring body
- [ ] Does NOT omit context for external data
- [ ] Does NOT use vague descriptions

---

## Synchronization Validation

**Purpose**: Ensure docstrings accurately reflect current code.

### Function Signature Synchronization

**Checks**:
1. [ ] All parameters in signature are documented in Args
2. [ ] No documented parameters that don't exist in signature
3. [ ] Parameter order matches between signature and docstring
4. [ ] Return type documented if function returns value
5. [ ] Exceptions documented if function raises them

### Class Attributes Synchronization

**Checks**:
1. [ ] All instance attributes documented in Attributes key
2. [ ] No documented attributes that don't exist
3. [ ] Attribute meanings match actual usage

### Module Entry Points Synchronization

**Checks**:
1. [ ] All public functions listed in Entry key
2. [ ] No private functions (starting with _) in Entry
3. [ ] Entry descriptions match function responsibilities

---

## Quality Metrics

### Semantic Value Score

**Formula**: (semantic_lines / total_lines) × 100

**Measurement**:
- **semantic_lines**: Lines explaining WHY, context, boundaries
- **total_lines**: All lines in docstring

**Threshold**:
- ✅ ≥70%: Good semantic value
- ⚠️ 40-69%: Acceptable but could improve
- ❌ <40%: Insufficient semantic value

### Example

❌ **Low semantic value** (20%):
```python
def process(x: int) -> int:
    """
    Process x.

    Args:
        x: An integer

    Returns:
        An integer
    """
    # 1/5 lines add semantic value = 20%
```

✅ **High semantic value** (85%):
```python
def calculate_discount(tier: int, amount: Decimal) -> Decimal:
    """
    Calculate loyalty discount based on tier and volume.

    Responsibility:
        Apply tiered discount rules with maximum cap.

    Context:
        Called during checkout after amount validation.

    Args:
        tier: Loyalty tier (0-3) for discount rate
        amount: Purchase amount for calculation

    Returns:
        Discount amount, capped at 30% of purchase
    """
    # 17/20 lines add semantic value = 85%
```

---

## Context Compliance for External Data

**Requirement**: Functions handling external data MUST score 100% on context checklist.

**Context Checklist**:
- [ ] States data origin (API, database, file, user input)
- [ ] States trust level (trusted/untrusted/validated)
- [ ] States validation responsibility
- [ ] States expected structure (if dict/json)
- [ ] States what caller must do with errors

### Example

❌ **Non-compliant** (0/5 checks):
```python
def handle_webhook(data: dict) -> Response:
    """Handle webhook data."""
```

✅ **Fully compliant** (5/5 checks):
```python
def handle_webhook(data: dict) -> Response:
    """
    Process incoming webhook from payment gateway.

    Context:
        Data comes from EXTERNAL payment gateway (untrusted).     # ✓ Origin
        Signature verified in middleware upstream.                 # ✓ Trust
        This is first business logic validation.                   # ✓ Validation
        Expected: {'event': str, 'amount': float}                  # ✓ Structure

    Returns:
        Response with status code (200 if processed, 400 if invalid)

    Raises:
        ValueError: If required fields missing - caller returns 400  # ✓ Caller duty
```

---

## Boundaries Compliance for Modules/Classes

**Requirement**: Complex modules/classes MUST define boundaries when scope could be ambiguous.

**Boundaries Checklist**:
- [ ] States ≥2 things the component does NOT do
- [ ] Each boundary item identifies where responsibility is delegated
- [ ] Boundaries prevent common scope creep scenarios

### Example

❌ **Non-compliant**:
```python
"""User management module."""
```

✅ **Fully compliant**:
```python
"""
User authentication and session management.

Boundaries:
    - Do NOT handle user registration (delegated to registration module)
    - Do NOT manage permissions (delegated to authorization module)
    - Do NOT store profile data (delegated to profile module)
"""
```

---

## Formatting Compliance

**80 Column Rule**:
- [ ] All lines ≤80 columns
- [ ] Long lines properly broken with indentation
- [ ] Continuation lines aligned with opening text

**Indentation**:
- [ ] 4 spaces for all keys
- [ ] 4 spaces for key content
- [ ] Proper alignment for multi-line content

**Blank Lines**:
- [ ] One blank line after opening sentence
- [ ] No blank lines between keys
- [ ] One blank line before closing `"""`

---

## Validation Levels

### Level 1: Minimal (Category B threshold)

**Requirements**:
- Module has docstring with Architecture and Responsibility
- Classes have docstring with Responsibility
- Functions have docstring with Args and Returns
- No type info in docstring body

**Use**: Minimum bar for legacy code

---

### Level 2: Standard (Category A threshold)

**Requirements**:
- All Level 1 requirements
- Module has Should and Boundaries
- Classes have Role and Boundaries
- Functions have Context for external data
- ≥70% semantic value score
- Maximum 80 columns maintained

**Use**: Standard for new code

---

### Level 3: Exemplary (Best Practice)

**Requirements**:
- All Level 2 requirements
- ≥85% semantic value score
- Context checklist 100% for external data functions
- Boundaries checklist 100% for complex modules
- Comprehensive Note sections where relevant
- Perfect synchronization with code

**Use**: Reference examples and critical modules

---

## Validation Workflow

### Step 1: Categorize Files

Analyze all Python files and categorize:
- **Category A**: ✅ Compliant
- **Category B**: ⚠️ Needs adjustments
- **Category C**: ❌ Non-compliant

### Step 2: Generate Report

For each Category B and C file, list:
- **Problems identified**: Specific checklist items failed
- **Severity**: Critical (Category C) vs Warning (Category B)
- **Recommendations**: Specific actions to become compliant

### Step 3: Validate Synchronization

For all files, check:
- Parameters match signatures
- Attributes match actual class attributes
- Entry points match public functions
- Exceptions match actual raises

### Step 4: Measure Metrics

Calculate:
- Semantic value score per file
- Context compliance for external data functions
- Boundaries compliance for modules/classes
- Formatting compliance

### Step 5: Pass/Fail Determination

**PASS Criteria**:
- All files in Category A or B (no Category C)
- ≥80% of files in Category A
- All external data functions meet context checklist
- All complex modules have boundaries
- 100% synchronization with code

**FAIL Criteria**:
- Any files in Category C
- <80% of files in Category A
- Any external data function missing context
- Complex modules without boundaries
- Synchronization errors

---

## Reference

This specification defines validation criteria. For:
- Semantic key definitions → @spec/semantic-keys-spec.md
- Normative templates → @spec/templates-spec.md
- Anti-patterns to avoid → @spec/anti-patterns-spec.md
- Applied examples → @context/examples.md
