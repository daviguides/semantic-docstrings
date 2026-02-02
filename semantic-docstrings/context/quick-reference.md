# Semantic Docstrings — Quick Reference

Minimal one-word keys for context-enriched docstrings.
Aligned with Google Style, but adds semantic anchors for LLMs and developers.

**Specifications**: @~/.claude/semantic-docstrings/spec/semantic-keys-spec.md

---

## 📦 Modules

```python
"""
Architecture:
    [Module's role in system architecture]

Responsibility:
    [Overarching responsibility]

Should:
    - [Positive responsibilities]

Boundaries:
    - [Delegated tasks / out of scope]

Entry:
    - [Public function: brief description]
"""
```

---

## 🏷️ Classes

```python
class ExampleClass:
    """
    Responsibility:
        [Single responsibility]

    Boundaries:
        [What this class does NOT handle]

    Role:
        [Position in the system]

    Attributes:
        attr1: [Meaning]

    Methods:
        method1(): [What it does]
    """
```

---

## ⚙️ Functions

```python
def example_function(arg1: str, arg2: int) -> bool:
    """
    Responsibility:
        [Single responsibility]

    Context:
        [Why it exists / assumptions]

    Args:
        arg1: [Why it exists]
        arg2: [Constraints / origin]

    Returns:
        [Meaning]

    Raises:
        ValueError: [Why raised / caller's duty]

    Note:
        [Gotchas / performance notes]
    """
```

---

## ✅ Quick Reference of Keys

- `Architecture` → Papel arquitetural do módulo
- `Responsibility` → Responsabilidade única
- `Should` → O que deve fazer
- `Boundaries` → O que não deve fazer / escopo negado
- `Entry` → Pontos de entrada públicos
- `Context` → Contexto semântico / origem dos dados
- `Role` → Papel da classe no sistema
- `Args` → Parâmetros e porquê existem
- `Returns` → Valor de retorno (com significado)
- `Raises` → Exceções (com intenção)
- `Attributes` → Atributos de instância
- `Methods` → Métodos relevantes
- `Note` → Observações adicionais

---

## 🎯 Rules

1. **Type hints in signatures** (not in docstring body)
2. **Explain WHY, not WHAT** (avoid repeating syntax)
3. **Context over mechanics** (data origin, trust, assumptions)
4. **Boundaries matter** (state what's out of scope)
5. **Maximum 80 columns** with line breaks

---

## 💡 Remember

**Syntax says WHAT, Semantics say WHY**

- Docstrings add a semantic layer beyond syntax
- Explain architectural role, not just implementation
- State data origin and trust level for external sources
- Define conceptual boundaries clearly
