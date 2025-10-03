# Semantic Docstrings

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<a href="http://daviguides.github.io"><img src="https://img.shields.io/badge/built%20with-%E2%9D%A4%EF%B8%8F%20by%20Davi%20Guides-orange"></a>

> A semantic documentation standard for Python that clarifies **Responsibility, Context, and Intent** —
> designed both as a **readable specification** and as a **Claude Code plugin**.

---

## What is Semantic Docstrings?

<img src="images/semantic-docstrings-banner.png" alt="Diagram" align="right" style="width: 500px"/>

Semantic Docstrings is a documentation standard that extends traditional Python docstrings with a **semantic layer**.
It introduces one-word keys (e.g., `Responsibility`, `Context`, `Role`, `Boundaries`, `Architecture`, `Should`, `Entry`)
that capture **why code exists**, not just *what it does*.

This repository serves a **dual purpose**:

- 📖 **Specification**: Readable guides and examples for adopting Semantic Docstrings in your projects.
- 🔌 **Claude Code Plugin**: Installable into Claude Code to encourage, enforce and autocomplete this documentation style.

---

## Quick Start

### One-Line Installation (Claude Code Plugin)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/semantic-docstrings/main/install.sh)"
```

The installer will:

1. Clone the latest version from GitHub
2. Copy `semantic-docstrings/` to `~/.claude/semantic-docstrings/`
3. Optionally configure `~/.claude/CLAUDE.md`
4. Clean up temporary files automatically

### Manual Installation

```bash
git clone https://github.com/daviguides/semantic-docstrings.git
cd semantic-docstrings

# Copy plugin files
mkdir -p ~/.claude
cp -r semantic-docstrings ~/.claude/

# Add to ~/.claude/CLAUDE.md
cat >> ~/.claude/CLAUDE.md << 'EOF'

# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/docs/semantic_docstrings.md
- **PRECEDENCE**: Project-specific rules override repository defaults
- **FALLBACK**: When no override exists, semantic-docstrings applies
EOF
```

---

## Usage

### As a Specification

Use the extended keys in your Python docstrings (with type hints in signatures, not inside the docstring body):

```python
def process_message(payload: dict) -> str:
    """
    Responsibility:
        First line of defense for input validation.

    Context:
        Payload comes from an untrusted external API.
        Enforces that `text` is mandatory, IDs optional.

    Args:
        payload: Untrusted API input.

    Returns:
        Extracted user message.

    Raises:
        ValueError: If `text` key is missing.
    """
```

See [docs/semantic_docstrings.md](./docs/semantic_docstrings.md) for the full specification.
See [cheatsheet/semantic_docstrings_cheatsheet.md](./cheatsheet/semantic_docstrings_cheatsheet.md) for quick reference.

### As a Claude Code Plugin

Once installed, you can reference Semantic Docstrings globally in your `CLAUDE.md`:

```markdown
# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/docs/semantic_docstrings.md
- **PRECEDENCE**: Project overrides semantic-docstrings
- **FALLBACK**: Use semantic-docstrings when no overrides exist
```

---

## Structure

```
semantic-docstrings/
├── docs/
│   └── semantic_docstrings.md         # Full specification
├── cheatsheet/
│   └── semantic_docstrings_cheatsheet.md
├── examples/
│   ├── module_example.py
│   ├── class_example.py
│   └── function_example.py
├── images/
│   └── semantic-docstrings-banner.svg
├── install.sh                         # Installer for Claude Code
├── LICENSE
└── README.md
```

---

## Why Semantic Docstrings?

- ✅ Adds meaning that syntax alone cannot express
- ✅ Preserves **intent** even after refactoring
- ✅ Defines **boundaries** and **roles** explicitly
- ✅ Improves onboarding, code review, and LLM/code-assistant comprehension
- ✅ Works seamlessly as a Claude Code plugin

---

## Contributing

Contributions are welcome! You can propose new semantic keys, refine examples, or extend the plugin.

1. Fork the repo
2. Create a feature branch
3. Submit a PR

---

## License

MIT License - See [LICENSE](./LICENSE) for details

---

## Author

Created and maintained by Davi Guides — bridging **readability**, **architecture**, and **LLM-aware coding**.
