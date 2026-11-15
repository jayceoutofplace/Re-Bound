class Wall extends Tile{
  public Wall(){
    img = loadImage("data/wall.png");
  }
  
  boolean IsWall(){
    return true;
  }
}
