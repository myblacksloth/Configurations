from __future__ import annotations


def calculate_checkout(total: float, is_member: bool) -> dict[str, float]:
    """Calculate discount and shipping for a tiny checkout scenario."""
    if total < 0:
        raise ValueError("total must be >= 0")

    discount_rate = 0.0
    if is_member:
        discount_rate = 0.10 if total >= 20 else 0.05

    discount = round(total * discount_rate, 2)
    subtotal = round(total - discount, 2)
    shipping = 0.0 if subtotal >= 50 else 4.99
    final_total = round(subtotal + shipping, 2)

    return {
        "total": round(total, 2),
        "discount": discount,
        "shipping": shipping,
        "final_total": final_total,
    }
