# Validate Semantic Docstrings

Validate and apply semantic docstrings standard to all Python files in current project.

**Specifications**:
- @~/.claude/semantic-docstrings/spec/validation-spec.md
- @~/.claude/semantic-docstrings/spec/semantic-keys-spec.md
- @~/.claude/semantic-docstrings/spec/templates-spec.md

---

## Workflow

### Step 1: Analyze and Categorize

Scan all Python files (`glob **/*.py`) and categorize using criteria from @spec/validation-spec.md:

- **Category A** (✅ Compliant): Fully meets semantic docstrings standard
- **Category B** (⚠️ Needs Adjustments): Has docstrings but needs improvements
- **Category C** (❌ Non-Compliant): Missing or inadequate docstrings

### Step 2: Generate Report

Create structured report:

```markdown
## Semantic Docstrings Validation Report

### ✅ Category A: Compliant (X files)
- [List files]

### ⚠️ Category B: Needs Adjustments (Y files)
[For each file:]
- **File**: path/to/file.py
- **Issues**: [List specific checklist failures from @spec/validation-spec.md]
- **Recommendations**: [Specific actions to fix]

### ❌ Category C: Non-Compliant (Z files)
- [List files with severity and required actions]
```

### Step 3: Validate Synchronization

For Category B and C files, check synchronization:
- Parameters match function signatures
- Attributes match class implementation
- Entry points match actual public functions
- Exceptions match code

Mark desynchronized docstrings as CRITICAL priority.

### Step 4: Await Confirmation

**Present report to user and await confirmation before making changes.**

### Step 5: Apply Corrections

For each file in Category B and C:
1. Load templates from @spec/templates-spec.md
2. Apply appropriate template (module/class/function)
3. Follow semantic keys from @spec/semantic-keys-spec.md
4. Ensure anti-patterns from @spec/anti-patterns-spec.md are avoided

### Step 6: Quality Validation

After applying corrections:
1. Run validation checklist from @spec/validation-spec.md
2. Execute tests (`pytest` or `make test`) to ensure nothing broke
3. Generate final report with all modified files

---

## Success Criteria

Per @spec/validation-spec.md:
- All files in Category A or B (no Category C)
- ≥80% of files in Category A
- 100% synchronization with code
- All tests passing

---

## Important Rules

1. **NEVER modify code logic** - only docstrings
2. **NEVER break backward compatibility**
3. **ALWAYS validate with tests**
4. **ALWAYS preserve type hints in signatures**
5. **USE one-word semantic keys** (Architecture, Responsibility, etc.)

---

## Output

1. Initial validation report (Step 2)
2. Await user confirmation
3. Apply corrections if confirmed
4. Final report with:
   - Files modified
   - Category improvements (A/B/C distribution before/after)
   - Test results
