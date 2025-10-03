---
layout: home
title: Semantic Docstrings
---

# Semantic Docstrings

Semantic Docstrings add a semantic layer to Python documentation:
- Reveal why code exists (not just what it does).
- Make responsibility, context, role, and boundaries explicit.
- Improve developer onboarding, code review, refactoring safety.
- Enhance LLM/code assistant reasoning with higher information density.

## Read the Docs

- [Full Specification](./semantic_docstrings.md)
- [Why Semantic Docstrings?](./why_semantic_docstrings.md)

## Quick Start (Claude Code)

Add this to `~/.claude/CLAUDE.md`:

```markdown
# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/docs/semantic_docstrings.md
- **PRECEDENCE**: Project-specific rules override repository defaults
- **FALLBACK**: When no override exists, semantic-docstrings applies
```
