import typing # noqa


def erastotenes_sieve(n: int) -> list[int]:
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


#  doing some math for myself
def tempfun(n: int) -> list[int]:
    primes = erastotenes_sieve(n + 2)
    primes = primes[2:]
    result: list[int] = []
    for iter in range(len(primes)):
        for idx in range(0, iter+1):
            result.append((primes[iter]*primes[idx]))
    return sorted(result)


# input is sorted list of numbers where atleast one is higher than one
# hundred, result is list that says how many numbers were there for each
# hundred. (sorry for bad english)
def count_hundreds(list: list[int]) -> list[int]:
    result = [0 for _ in range((list[-1] // 100)+1)]
    for num in list:
        result[num // 100] += 1
    return result


def main():
    nums = tempfun(30)
    print(count_hundreds(nums))
    print(nums)


if __name__ == "__main__":
    main()
