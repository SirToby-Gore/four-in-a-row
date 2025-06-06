import 'package:four_in_a_row/four_in_a_row.dart';

void main(){
  List players = [];
  players = [[input("what your name player 1?: "), "red", 0],[input("what is your name player 2: "), "yel", 0]];
  while (true){
    var points = play(players);
    players[0][2] += points[0];
    players[1][2] += points[1];
    print("scores");
    for (var player in players) {
      print("${player[0]} ${player[1]} : ${player[2].toString()}");
    }
    String inp = input("type 'c' to play a new match or type [any] to quit.");
    if (inp != "c"){
      break;
    }
  }
}
