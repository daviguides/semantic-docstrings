---
layout: home
title: Home
---

<img src="./assets/images/semantic-docstrings-banner.png" alt="Principles Diagram" align="right" style="width: 400px;background-color:#f2f0e9;border-radius: 1rem;margin-left:10px;"/>

Semantic Docstrings add a semantic layer to Python documentation:
- Reveal why code exists (not just what it does).
- Make responsibility, context, role, and boundaries explicit.
- Improve developer onboarding, code review, refactoring safety.
- Enhance LLM/code assistant reasoning with higher information density.

## Quick Start

### One-Line Installation (Claude Code Plugin)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/semantic-docstrings/main/install.sh)"
```

## Read the Docs

- [Full Specification](/semantic-docstrings/semantic_docstrings.html)
- [Why Semantic Docstrings?](/semantic-docstrings/why_semantic_docstrings.html)

## Quick Start (Claude Code)

Add this to `~/.claude/CLAUDE.md`:

```markdown
# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/docs/semantic_docstrings.md
- **PRECEDENCE**: Project-specific rules override repository defaults
- **FALLBACK**: When no override exists, semantic-docstrings applies
```
