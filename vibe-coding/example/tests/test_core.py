import pytest

from tinyapp.core import calculate_checkout


def test_non_member_small_order_has_shipping() -> None:
    result = calculate_checkout(total=10, is_member=False)
    assert result == {
        "total": 10.0,
        "discount": 0.0,
        "shipping": 4.99,
        "final_total": 14.99,
    }


def test_member_discount_and_free_shipping() -> None:
    result = calculate_checkout(total=60, is_member=True)
    assert result == {
        "total": 60.0,
        "discount": 6.0,
        "shipping": 0.0,
        "final_total": 54.0,
    }


def test_negative_total_raises() -> None:
    with pytest.raises(ValueError):
        calculate_checkout(total=-1, is_member=True)
