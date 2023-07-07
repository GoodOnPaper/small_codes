# just a ordinary brainfuck parser and executor i felt like making.
# its not special in any shape or form from something you can find in seconds
# online.
# unfinished, will return to this later.

class Brainfuck:
    def __init__(self) -> None:
        self.state: dict[int, int] = {}
        self.index: int = 0
        self.loopstack: list[str] = []

    def show_state(self) -> None:
        for key in self.state:
            val = self.state[key]
            print("[", key, ":", val, "]", end="")
        print("idx:", self.index)

    def exec(self, code: str):
        ins_idx: int = -1
        for instruction in code:
            ins_idx += 1
            match instruction:
                case ">":
                    self.indexinc()
                    continue
                case "<":
                    self.indexdec()
                    continue
                case "-":
                    self.dec()
                    continue
                case "+":
                    self.inc()
                    continue
                case "[":
                    self.loopstart(code, ins_idx)
                    continue
                case "]":
                    code = self.loopend()
                    self.exec(code)
                    break
                case ".":
                    self.out()
                    continue
                case ",":
                    self.inp()
                    continue

    def indexinc(self) -> None:
        self.index += 1

    def indexdec(self) -> None:
        self.index -= 1

    def inc(self) -> None:
        self.state[self.index] = self.state.get(self.index, 0) + 1

    def dec(self) -> None:
        self.state[self.index] = self.state.get(self.index, 0) - 1

    def out(self) -> None:
        give = self.state.get(self.index, 0)
        print(chr(give), give, end="")

    def inp(self) -> None:
        pass  # TODO

    def loopstart(self, code: str, idx: int) -> None:
        self.loopstack.append(code[idx:])  # TODO

    def loopend(self) -> str:
        if self.state.get(self.index, 0) != 0:
            code = self.loopstack.pop()
            return code  # TODO


def main() -> None:
    machine = Brainfuck()
    machine.exec("++>++>---<+")
    machine.show_state()
    machine1 = Brainfuck()
    machine1.exec("++       Cell c0 = 2\
                   > +++++  Cell c1 = 5\
                   \
                   [        Start your loops with your cell pointer on the loop counter (c1 in our case)\
                   < +      Add 1 to c0\
                   > -      Subtract 1 from c1\
                   ]        End your loops with the cell pointer on the loop counter\
                   \
                   At this point our program has added 5 to 2 leaving 7 in c0 and 0 in c1\
                   but we cannot output this value to the terminal since it is not ASCII encoded\
                   \
                   To display the ASCII character \"7\" we must add 48 to the value 7\
                   We use a loop to compute 48 = 6 * 8\
                   \
                   ++++ ++++  c1 = 8 and this will be our loop counter again\
                   [\
                   < +++ +++  Add 6 to c0\
                   > -        Subtract 1 from c1\
                   ]\
                   < .        Print out c0 which has the value 55 which translates to \"7\"!")
# Credit to wikipedia
    machine1.show_state()


if __name__ == "__main__":
    main()
