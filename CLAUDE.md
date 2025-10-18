# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**Semantic Docstrings** is a documentation standard and Claude Code plugin that extends traditional Python docstrings with semantic meaning. It clarifies **Responsibility, Context, and Intent** through one-word keys (e.g., `Responsibility`, `Context`, `Role`, `Boundaries`, `Architecture`, `Should`, `Entry`).

This repository serves dual purposes:
1. **Specification**: Readable documentation standard for Python projects
2. **Claude Code Plugin**: Installable plugin that encourages this documentation style

---

## Development Commands

### Installation Testing

```bash
# Test the installer script locally (creates temp directory automatically)
bash install.sh

# Verify installation
ls ~/.claude/semantic-docstrings/
cat ~/.claude/CLAUDE.md
```

### Documentation Site

The documentation site is built with Jekyll and hosted at daviguides.github.io:

```bash
# Navigate to docs directory
cd docs

# Serve locally (requires Jekyll)
bundle exec jekyll serve

# Access at http://localhost:4000
```

### File Structure Validation

```bash
# Check plugin structure is valid
ls -la .claude-plugin/
cat .claude-plugin/plugin.json

# Verify semantic docstrings directory
ls -la semantic-docstrings/
```

---

## Repository Architecture

### Core Components

**semantic-docstrings/** - The plugin content directory organized using Gradient architecture:

**semantic-docstrings/spec/** - Normative specifications (single source of truth)
- `semantic-keys-spec.md` - Definitions of all semantic keys (Architecture, Responsibility, etc.)
- `templates-spec.md` - Normative templates for module/class/function docstrings
- `anti-patterns-spec.md` - Rules and anti-patterns to avoid
- `validation-spec.md` - Quality checklists and validation criteria
- This is the **primary source of truth** for the standard

**semantic-docstrings/context/** - Applied guidance and examples
- `patterns.md` - Usage patterns for different scenarios (orchestrators, adapters, etc.)
- `examples.md` - Complete concrete examples demonstrating best practices
- `quick-reference.md` - Condensed quick reference for developers

**semantic-docstrings/prompts/** - Validation and application workflows
- `validate.md` - Orchestrates validation workflow across Python files

**commands/** - Thin wrappers (≤10 lines each) that reference specs
- `load-semantic-context.md` - Load semantic docstring standards for session
- `add-module-docstring.md` - Generate module docstring
- `add-class-docstring.md` - Generate class docstring
- `add-function-docstring.md` - Generate function docstring
- `validate-docstrings.md` - Validate project docstrings
- `resume.md` - Summarize concept with example

**agents/** - Specialized documentation agents
- `documentation-specialist.md` - Agent for generating semantic docstrings
- `docstring-reviewer.md` - Agent for reviewing docstring quality

**examples/** - Python code examples demonstrating the standard
- `module_example.py` - Module-level semantic docstrings
- `function_example.py` - Function-level semantic docstrings
- `class_example.py` - Class-level semantic docstrings
- These show **practical application** of the standard

**docs/** - Jekyll documentation site
- `_pages/semantic_docstrings.md` - Main specification page
- `_pages/why_semantic_docstrings.md` - Rationale and philosophy
- `index.md` - Landing page
- Site configuration: `_config.yml`, `Gemfile`

**install.sh** - One-line installation script
- Clones the repository to `/tmp`
- Copies `semantic-docstrings/` directory to `~/.claude/`
- Optionally configures `~/.claude/CLAUDE.md`
- Handles existing installations with prompts
- Cleans up temporary files automatically

**PLUGIN_STRUCTURE_GUIDE.md** - Comprehensive guide for plugin architecture
- Documents Claude Code plugin structure requirements
- Explains context loading strategies (commands, agents, hooks)
- Contains templates for creating plugins
- Critical reference for plugin development

### Key Architectural Principles

**Separation of Concerns:**
- **Specifications** (`semantic-docstrings/spec/`) define the normative standard
- **Context** (`semantic-docstrings/context/`) provides applied guidance and examples
- **Prompts** (`semantic-docstrings/prompts/`) orchestrate workflows
- **Commands** (`commands/`) provide thin wrappers referencing specs
- **Agents** (`agents/`) specialize in documentation generation
- **Examples** (`examples/`) demonstrate practical usage in Python
- **Documentation** (`docs/`) explains rationale and guides adoption
- **Installation** (`install.sh`) handles distribution

**Distribution Strategy:**
The plugin uses a **copy-based installation model** rather than direct repository reference:
- Users install via `install.sh` which copies `semantic-docstrings/` directory to `~/.claude/`
- Projects reference installed specs via `@~/.claude/semantic-docstrings/spec/semantic-keys-spec.md`
- Commands use thin wrappers (≤10 lines) that reference specs instead of duplicating content
- This ensures version stability, offline availability, and follows Gradient anti-duplication principles

**Semantic Keys Philosophy:**
The standard adds a **semantic layer** over Python's syntactic layer:
- Syntax says **WHAT** (types, signatures)
- Semantics says **WHY** (responsibility, context, boundaries)
- Keys like `Responsibility`, `Context`, and `Boundaries` capture architectural intent

---

## Semantic Docstring Standard

When creating or modifying examples, documentation, or the specification itself, adhere to these keys:

### Module Level
- **Architecture**: Module's role in system architecture
- **Responsibility**: Overarching single responsibility
- **Should**: Positive responsibilities (what it does)
- **Boundaries**: Delegated tasks / out of scope (what it doesn't do)
- **Entry**: Public functions (entry points)

### Class Level
- **Responsibility**: Single responsibility of the class
- **Boundaries**: What the class does NOT handle
- **Role**: Position of this class in the system
- **Attributes**: Instance attributes with semantic meaning
- **Methods**: Key methods with brief descriptions

### Function Level
- **Responsibility**: Single responsibility of the function
- **Context**: Why it exists, when to call, assumptions about data origin/trust
- **Args**: Parameter meanings (not just types - explain WHY they exist)
- **Returns**: Semantic meaning of return value
- **Raises**: Why exceptions are raised and what caller must do
- **Note**: Important details, gotchas, or performance considerations

---

## Documentation Guidelines

### When Creating Examples

- Examples in `examples/` MUST demonstrate the full semantic docstring pattern
- Use realistic scenarios (not trivial "hello world" examples)
- Show domain context (e.g., "debt negotiation", "user identification")
- Demonstrate **why** semantic keys add value over basic docstrings

### When Updating Specification

- Primary spec: `semantic-docstrings/semantic_docstrings.md`
- Keep examples consistent across all documentation files
- Update the cheatsheet if adding new semantic keys
- Ensure Jekyll docs (`docs/_pages/`) stay synchronized

### Writing Philosophy

Documentation should explain:
1. **What** the semantic key represents
2. **Why** it matters (architectural/maintenance value)
3. **How** to apply it (concrete examples)
4. **When** to use it (appropriate contexts)

Avoid:
- Repeating what syntax already expresses
- Generic descriptions that apply to any function
- Over-explaining obvious implementation details

---

## Installation Script Maintenance

When modifying `install.sh`:

- Test both fresh installation and upgrade scenarios
- Verify cleanup function runs on all exit paths (success, error, interrupt)
- Maintain POSIX compatibility (avoid bash-only features where possible)
- Preserve color-coded output for user feedback
- Test with existing `~/.claude/CLAUDE.md` files (append vs create)
- Verify rsync fallback to `cp -R` works correctly

The script copies `semantic-docstrings/` subdirectory (not entire repo):
```bash
# Copies from: /tmp/semantic-docstrings-$$/semantic-docstrings/
# To: ~/.claude/semantic-docstrings/
```

---

## Plugin Structure

This repository follows Claude Code plugin conventions documented in `PLUGIN_STRUCTURE_GUIDE.md`.

**Important**: Plugins do NOT inject context automatically like `CLAUDE.md`. The semantic docstrings standard becomes active when:

1. Users run the installer which configures `~/.claude/CLAUDE.md`, OR
2. Projects explicitly reference it in their project-level `CLAUDE.md`

**Future plugin enhancements** could include:
- Custom slash commands (e.g., `/add-semantic-docstring`)
- Specialized agents for documentation review
- Validation hooks to check docstring completeness

---

## Git Workflow

Current branch: **main**

Untracked file: `PLUGIN_STRUCTURE_GUIDE.md` (documentation, should be committed)

When making commits:
- Use descriptive commit messages explaining WHY changes were made
- Group related changes (e.g., "Update specification and examples together")
- Tag releases using semantic versioning (e.g., `v0.1.0`, `v1.0.0`)

---

## Design Philosophy: Syntax vs Semantics

Core insight: **Code without docstrings says "WHAT", code with semantic docstrings says "WHY"**

Python's type system expresses:
```python
def calculate_discount(user: User, amount: Decimal) -> Decimal
```

This tells us: "receives User and Decimal, returns Decimal"

Semantic docstrings add meaning:
```python
"""
Responsibility:
    Calculate discount based on user loyalty and purchase volume.

Context:
    Part of pricing engine. Called during checkout process.
    Assumes user is authenticated and amount is pre-validated.

Args:
    user: User account for loyalty tier determination
    amount: Purchase amount for volume-based discount calculation

Returns:
    Final discount amount, capped at maximum allowed discount
"""
```

Now we know **WHY** each parameter exists and **WHAT ROLE** the function plays architecturally.

This semantic layer:
- Preserves intent even after refactoring
- Defines conceptual boundaries, not just technical ones
- Self-documents architecture
- Helps LLMs and developers understand context
- Reduces need for external documentation

---

## Contributing to This Repository

When proposing changes:

1. **Specification changes**: Update `semantic-docstrings/semantic_docstrings.md` first
2. **Example changes**: Ensure examples clearly demonstrate the value of semantic keys
3. **Documentation**: Keep `docs/` synchronized with specification
4. **Installation**: Test `install.sh` on clean systems before committing
5. **Cheatsheet**: Update if adding/modifying semantic keys

Maintain consistency across all representations of the standard.
