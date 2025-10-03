"""
Debt negotiation conversation orchestrator.

Architecture:
    Orchestrator of conversation flow across agents.

Responsibility:
    Decide WHICH agent to use (identification vs negotiation)
    and WHEN to transition between them.

Should:
    - Receive and validate messages from external sources
    - Determine conversation state (identified vs unidentified)
    - Route messages to appropriate agent

Boundaries:
    - Do not create/configure agents (delegated to agent modules)
    - Do not manage MCP connections/tools (delegated to helpers)
    - Do not apply business rules (delegated to domain layer)

Entry:
    - process_message: Main public function called by API routes
"""

from typing import Optional, Tuple

def process_message(payload: dict) -> Tuple[str, Optional[str], Optional[str]]:
    """
    Responsibility:
        First line of defense for payload validation.

    Context:
        Payload comes from an EXTERNAL SOURCE and cannot be trusted.
        Enforces contract: text is mandatory; session/user IDs optional.

    Args:
        payload: Dictionary received from external API.

    Returns:
        (user_message, chat_session_id, chat_user_id)

    Raises:
        ValueError: If 'text' key is missing.
    """
    text = payload.get("text")
    if not text:
        raise ValueError("Missing 'text'")
    return text, payload.get("chat_session_id"), payload.get("chat_user_id")
