class Floor extends Tile{
  public Floor(){
    img = loadImage("data/floor.png");
  }
  
  boolean IsWall(){
    return false;
  }
}
