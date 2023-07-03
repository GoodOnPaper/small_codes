import typing # noqa


def erastotenes_sieve(n: int):
    if n < 1:
        return []
    primes: list[int] = [2]
    curr_int: int = 2
    while len(primes) < n:
        curr_int += 1
        do_add: bool = True
        for div in primes:
            if curr_int % div == 0:
                do_add = False
                break
        if do_add:
            primes.append(curr_int)
    return primes


def main():
    x: int = int(input("give amount of primes:"))
    print(erastotenes_sieve(x))


if __name__ == "__main__":
    main()
