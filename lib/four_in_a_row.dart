import "dart:io";
import "dart:math";

List<int> play(List players){
  Random random = Random();
  int player = random.nextInt(2);
  var board = Board();
  while (board.getValidColomns().isNotEmpty && !(board.isWinner())){
    board.printSelf();
    String valids = board.getValidColomns().join(", ");
    valids = "$valids , 9:flip, 10:rotate left, 11: rotate right";
    String colour = players[player][1];
    if (colour == "red"){
      colour = "\x1B[31m";
    }
    else if(colour == "yel"){
      colour = "\x1B[33m";
    }
    String player_ = colour+players[player][0]+"\x1B[0m";
    String inp;
    while (true){
      inp = input("choose a colomn to play $player_ from ($valids)");
      if ("1,2,3,4,5,6,7,8,9,10,11".contains(inp)){
        if (["9","10","11"].contains(inp)){
          if (inp == "9"){
            board.flip();
          }
          else if (inp == "10"){
            board.rotateLeft();
          }
          else{
            board.rotateRight();
          }
          break;
        }
        else {
          board.play(int.parse(inp)-1, players[player][1]);
          break;
        }
      }
      else {
        print("Please input a valid number");
      }
    }
    if (player == 1){
      player = 0;
    }
    else {
      player++;
    }
  }
  board.printSelf();
  String winner = "draw";
  for (var player_ in players){
    if (player_[1] == board.winner){
      winner = player_[0];
      break;
    }
  }
  print("End of game winner is $winner.");
  List<int> scores = [1,1];
  if (board.winner == "red"){
    scores = [3,0];
  }
  if (board.winner == "yel"){
    scores = [0,3];
  }
  return scores;
}

String input(String output){
  print(output);
  String? inp;
  while (true){
    inp = stdin.readLineSync();
    if (inp == null || inp == ""){
      print("please type something.");
    }
    else {
      return inp;
    }
  }
}

class Board{
  List grid = [];
  int gridSize = 8;
  String winner = "draw";
  List<int> lastPlay = [0,0];
  Board(){
    for (var i = 0; i < gridSize; i++) {
      List temp = [];
      for (var i = 0; i < gridSize; i++){
        temp.add(Tile("blank"));
      }
      grid.add(temp);
    }
  }
  
  void printSelf(){
    print("\x1B[2J\x1B[0;0H"); 
    for (var row in grid) {
      List printValues = ["\n"];
      for (var tile in row){
        printValues.add(tile.printValue());
      }
      print(printValues.join("\t"));
    }
    List printList = ["\n"];
    for (int i = 1; i <= gridSize; i++){
      printList.add(i.toString());
    }
    print(printList.join("\t"));
  }

  void changeAtPosision(int row, int colomn, String colour){
    grid[row][grid].colour == colour;
  }
  
  List<String> getValidColomns(){
    List<String> toReturn = [];
    for (var i = 0; i < grid.length; i++) {
      if (checkColomn(i)){
        toReturn.add((i+1).toString());
      }
    }
    return toReturn;
  }
  
  void play(int colomn, String colour){
    int pointer = 0;
    bool flag = true;
    while (flag){
      if (pointer < gridSize && canPlayAt(pointer, colomn)){
        pointer++;
      }
      else {
        grid[pointer-1][colomn].colour = colour;
        lastPlay = [pointer-1, colomn];
        flag = false;
      }
    }
    isWinner();
  }
  
  bool checkColomn(int colomn){
    if (grid[0][colomn].colour == "blank"){
      return true;
    }
    else{
      return false;
    }
  }
  
  bool canPlayAt(int row, int colomn){
    if (grid[row][colomn].colour == "blank"){
      return true;
    }
    else{
      return false;
    }
  }

  bool isWinner(){
    return winnerColomn() || winnerRow() || winnerRightDiagonal() || winnerLeftDiagonal();
  }

  bool winnerColomn(){
    List cache = [];
    for (Tile tile in grid[lastPlay[0]]){
      if (tile.colour != "blank") {
        cache.add(tile.colour);
      }
      else {
        cache = [];
      }
      if (cache.length == 4){
        if (isMatchingSet(cache)){
          winner = tile.colour;
          return true;
        }
        cache.removeAt(0);
      }
    }
    return false;
  }

  bool winnerRow(){ 
    List cache = [];
    for (List row in grid){
      Tile tile = row[lastPlay[1]];
      if (tile.colour != "blank"){
        cache.add(tile.colour);
      }
      else {
        cache = [];
      }
      if (cache.length == 4){
        if (isMatchingSet(cache)){
          winner = tile.colour;
          return true;
        }
        cache.removeAt(0);
      }
    }
    return false;
  }

  bool winnerLeftDiagonal(){
    List cache = [];
    for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
          int pointer = 0;
          cache = [];
          while (true){
            try {
              Tile tile = grid[row+pointer][col+pointer];
              if (tile.colour != "blank"){
                cache.add(tile.colour);
              }
              else {
                cache = [];
              }
              if (cache.length == 4){
                if (isMatchingSet(cache)){
                  winner = tile.colour;
                  return true;
                }
              }
              pointer++;
            } on RangeError catch(_){
              break;
            }
          }
        }
    }
    return false;
  }

  bool winnerRightDiagonal(){
    List cache = [];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        int pointer = 0;
        cache = [];
        while (true){
          try {
            if (cache.isNotEmpty){
            }
            Tile tile = grid[row+pointer][col-pointer];
            if (tile.colour != "blank"){
              cache.add(tile.colour);
            }
            else {
              cache = [];
            }
            if (cache.length == 4){
              if (isMatchingSet(cache)){
                winner = tile.colour;
                print("winner");
                return true;
              }
            }
            pointer++;
          } on RangeError catch(_){
            break;
          }
        }
      }
    }
    return false;
  }

  void flip(){
    List rows = [];
    for (var row in grid.reversed){
      rows.add(row);
    }
    grid = [];
    for (var row in rows){
      grid.add(row);
    }
    gravityUpdate();
  } 

  void rotateRight(){
    List newGrid = [];
    for (var n = 0; n < gridSize; n++) {
      List row = [];
      for (var i = 0; i < gridSize; i++) {
        row.add(grid[i][n]);
      }
      newGrid.add(row);
    }
    grid = newGrid;
    gravityUpdate();
  }

  void rotateLeft(){
    List newGrid = [];
    for (var n = 0; n < gridSize; n++) {
      List row = [];
      for (var i = 0; i < gridSize; i++) {
        row.add(grid[gridSize-1-i][gridSize-1-n]);
      }
      newGrid.add(row);
    }
    grid = newGrid;
    gravityUpdate();
  }

  void gravityUpdate() {
    for (var col = 0; col < gridSize; col++) {
      for (var row = gridSize - 1; row >= 0; row--) {
        // Skip non-blank tiles
        if (grid[row][col].colour != "blank") {
          continue;
        } 
        var newRow = row - 1;
        while (newRow >= 0 && grid[newRow][col].colour == "blank") {
          newRow--;
        }
        if (newRow >= 0) {
          grid[row][col] = grid[newRow][col];
          grid[newRow][col] = Tile("blank");
        }
      }
    }
  }
}

bool isMatchingSet(List list){
  for (int pointer = 1; pointer < list.length; pointer++) {
    if (list[pointer-1] != list[pointer]){
      return false;
    }
  }
  return true;
}

class Tile{
  String icon = "□";
  String value = "";
  String colour = "";
  Tile(String colour){
    colour = colour;
  }
  String printValue(){
    if (colour == "red"){
      return "\x1B[31m$icon\x1B[0m";
    }
    else if(colour == "yel"){
      return "\x1B[33m$icon\x1B[0m";
    }
    else{
      return icon;
    }
  }
}