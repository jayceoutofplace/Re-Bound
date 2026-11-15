class Map{
  Tile[] tiles;
  int TileSize = 32;
  
  int[][] map;
  String[] MapFile;
  
  int rows;
  int cols;
  
  public Map(String MapName){
    tiles = new Tile[10];
    tiles[0] = new Wall(); // 0.
    tiles[1] = new Floor(); // 1.
    
    MapFile = loadStrings(MapName);
    rows = MapFile.length;
    String[] FirstRow = split(MapFile[0],",");
    cols = FirstRow.length;
    map = new int[rows][cols];
    // Populates the array.
    for(int row = 0; row < rows; row++){
      String[] vals = split(MapFile[row],",");
      for(int col = 0; col < cols; col++){
        map[row][col] = int(trim(vals[col]));
      }
    }
  }
  
  void show(){
    for(int row = 0; row<rows; row++){
      for(int col = 0; col<cols; col++){
        int TileNum = map[row][col];
        int x = col*TileSize;
        int y = row*TileSize;
        if(TileNum>=0&&tiles[TileNum]!=null){
          image(tiles[TileNum].img,x,y,TileSize,TileSize);
        }
      }
    }
  }
}
