# just a ordinary thing that can run BF i felt like making.
# its not special in any shape or form from something you can find in seconds
# online.
# unfinished, will return to this later.

# 6 months later i finished this, i guess i didn't really feel like making
# this, huh
# oh and i am pretty sure this is quite unusable + questionable reliability.

class Brainfuck:
    def __init__(self) -> None:
        self.state: dict[int, int] = {}  # cells (keys) and their values
        self.index: int = 0  # cell at which it is currently pointing
        self.stack: list[int] = []  # stack to remember position in loops
        self.ins_idx: int = 0  # instruction index
        self.output_list: list[str] = []  # memory to log all the outputs

    def show_state(self) -> None:
        print()
        for key in self.state:
            val = self.state[key]
            print("[", key, ":", val, "]", end="")
        print("idx:", self.index)

    def preprocessRun(self, code: str):
        processed: str = ""
        for i in code:
            if i in ("+-<>[],."):
                processed += i
        self.execution(processed)

    def execution(self, code: str):
        while self.ins_idx < len(code):
            instruction = code[self.ins_idx]
            self.ins_idx += 1
            match instruction:
                case ">":
                    self.index += 1
                    continue
                case "<":
                    self.index -= 1
                    continue
                case "-":
                    self.state[self.index] = self.state.get(self.index, 0) - 1
                    continue
                case "+":
                    self.state[self.index] = self.state.get(self.index, 0) + 1
                    continue
                case "[":
                    self.loopstart(code)
                    continue
                case "]":
                    self.loopend()
                    continue
                case ".":
                    self.out()
                    continue
                case ",":
                    self.inp()
                    continue

    def out(self) -> None:
        output_char = chr(self.state.get(self.index, 0))
        print(output_char, end="")
        self.output_list.append(output_char)

    def inp(self) -> None:
        while True:
            try:
                self.state[self.index] = int(input("input type: int ="))
                return
            except ValueError:
                print("incorrect type")
                continue

    def loopstart(self, code: str) -> None:
        if self.state.get(self.index, 0) != 0:
            self.stack.append(self.ins_idx)
            return
        else:
            is_loop_end = 0
            aux_ins_idx = self.ins_idx
            while is_loop_end != 1:
                aux_ins_idx += 1
                if code[aux_ins_idx] == "[":
                    is_loop_end -= 1
                elif code[aux_ins_idx] == "]":
                    is_loop_end += 1
            self.ins_idx = aux_ins_idx+1  # ins after loop end
            return

    def loopend(self) -> None:
        # TODO
        if self.state.get(self.index, 0) != 0:
            self.ins_idx = self.stack[-1]
            return
        else:
            self.stack.pop()
            return


def main() -> None:
    # tests
    machine = Brainfuck()
    machine.execution("++>++>---<+")
    machine.show_state()
    assert machine.state[0] == 2
    assert machine.state[1] == 3
    assert machine.state[2] == -3
    machine1 = Brainfuck()
    machine1.preprocessRun("++       Cell c0 = 2\
                   > +++++  Cell c1 = 5\
                   \
                   [        Start your loops with your cell pointer on the\
                   loop counter (c1 in our case)\
                   < +      Add 1 to c0\
                   > -      Subtract 1 from c1\
                   ]        End your loops with the cell pointer on the loop\
                   counter\
                   \
                   At this point our program has added 5 to 2 leaving 7 in\
                   c0 and 0 in c1\
                   but we cannot output this value to the terminal since it is\
                   not ASCII encoded\
                   \
                   To display the ASCII character \"7\" we must add 48 to the\
                   value 7\
                   We use a loop to compute 48 = 6 * 8\
                   \
                   ++++ ++++  c1 = 8 and this will be our loop counter again\
                   [\
                   < +++ +++  Add 6 to c0\
                   > -        Subtract 1 from c1\
                   ]\
                   < .        Print out c0 which has the value 55 which\
                   translates to \"7\"!")
# Credit to wikipedia, with text and everything so i can make sure it
# ignores comments as it should.
    machine1.show_state()
    assert machine1.state[0] == 55, f"actual number: {machine1.state[0]}"
    machine3 = Brainfuck()
    machine3.execution(">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++.\
                       .+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++\
                       ++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]\
                       <+.")
    machine3.show_state()


if __name__ == "__main__":
    main()
