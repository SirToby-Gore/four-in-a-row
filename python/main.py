from colorama import init, Fore
init()

class Board:
    def __init__(self, size: int = 7) -> None:
        self.size: int = size
        self.board: list[list[str]] = [["□" for _ in range(size)] for __ in range(size)]
    
    def print(self):
        global player1, player2
        print("¦".join([ i for i in range(1, self.size+1)]))
        for row in self.board:
            line: str = ""
            for space in row:
                match space:
                    case "□":
                        line += space
                    case player1.play:
                        line += colour(space, player1.colour)
                    case player2.play:
                        line += colour(space, player2.colour)
                line += "¦"
            print(line)
    
    def flip(self) -> None:
        pass


class Player:
    def __init__(self, name: str, colour: str, play: str) -> None:
        self.colour: str = colour
        self.name: str = name
        self.play: str = play

def colour(text: str, colour: str) -> str:
    colours = {
        "red" : Fore.RED,
        "yellow" : Fore.YELLOW,
        "green" : Fore.GREEN,
        "blue" : Fore.BLUE,
        "megenta" : Fore.MAGENTA,
        "black" : Fore.BLACK,
        "white" : Fore.WHITE,
        "light_red":Fore.LIGHTRED_EX,
        "light_yellow" : Fore.LIGHTYELLOW_EX,
        "light_green" : Fore.LIGHTGREEN_EX,
        "light_blue" : Fore.LIGHTBLUE_EX,
        "light_megenta" : Fore.LIGHTMAGENTA_EX,
        "light_black" : Fore.LIGHTBLACK_EX,
        "light_white" : Fore.LIGHTWHITE_EX
        }
    if colour in colours:
        return colours[colour.lower()] + text + Fore.RESET
    else:
        return text

def main() -> None:
    board: Board = Board()
    board.print()

player1: Player = Player("p1", "red", "x")
player2: Player = Player("p2", "yellow", "o")

if __name__ == "__main__":
    main()