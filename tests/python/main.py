import os
import time


def get_value(key: str) -> int:
    return int(os.getenv(key, 1))


def leibniz(n: int) -> float:
    pi = 0
    for i in range(1 - 2 * n, 2 * n + 1, 4):
        pi += 1 / i
    return pi * 4


def main() -> None:
    limit = get_value("LIMIT")
    runs = get_value("RUNS")
    pi = 3.1415926535897932

    start = time.perf_counter()
    for _ in range(runs):
        pi = leibniz(limit)
    end = time.perf_counter()

    elapsed = (end - start) * 1000 / runs
    print(f"Elapsed: {elapsed:.2f}ms\t| π: {pi:.16f}")


if __name__ == "__main__":
    main()
