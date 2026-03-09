from __future__ import annotations

import argparse
import json

from .core import calculate_checkout


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Tiny checkout calculator")
    parser.add_argument("--total", type=float, required=True, help="Order total")
    parser.add_argument(
        "--member",
        action="store_true",
        help="Apply member discount rules",
    )
    return parser


def main() -> None:
    args = build_parser().parse_args()
    result = calculate_checkout(total=args.total, is_member=args.member)
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
