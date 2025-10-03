from decimal import Decimal

def calculate_discount(user_tier: int, amount: Decimal) -> Decimal:
    """
    Responsibility:
        Compute discount based on user tier and purchase amount.

    Context:
        Applies a maximum cap to ensure business constraints.

    Args:
        user_tier: Loyalty tier as an integer (e.g., 0..3).
        amount: Purchase amount to calculate discount from.

    Returns:
        Final discount amount (capped).

    Raises:
        ValueError: If amount is negative.
    """
    if amount < 0:
        raise ValueError("Negative amount")
    base = Decimal("0.05") + Decimal(user_tier) * Decimal("0.05")
    discount = amount * base
    cap = amount * Decimal("0.3")
    return min(discount, cap)
