class Bullet{
  float x;
  float y;
  
  float rot;
  
  float BulletSpeed = 15.0;
  
  boolean CanBeThrown = false;
  boolean held = false;
  
  boolean dead = false;
  
  public Bullet(float _x, float _y, float _rot){
    x = _x;
    y = _y;
    rot = _rot;
  }
  
  void die(){
    // When bullet hits a wall it stops rendering.
    if(IsCollide()){
      dead = true;
    }
  }
  
  boolean IsCollide(){
    for(int row = 0; row<map.rows; row++)
      for(int col = 0; col<map.cols; col++){
        int tile = map.map[row][col];
        if(tile>=0&&tile<map.tiles.length&&map.tiles[tile]!=null&&map.tiles[tile].IsWall()){
          int xx = col*map.TileSize;
          int yy = row*map.TileSize;
          if(collides(xx,yy,map.TileSize,map.TileSize,x,y,50,30)){
            return true;
          }
        }
      }
    return false;
  }
  
  void shoot(){
    if(CanBeThrown && dead && JustSlowed) return;
    x+=cos(rot)*BulletSpeed;
    y+=sin(rot)*BulletSpeed;
  }
  
  void update(){
    if(dead) return;
    if(slowed&&CanSlow){
      BulletSpeed = 1.0;
    }else{
      BulletSpeed = 15.0;
    }
    
    if(!held){
      x+=cos(rot)*BulletSpeed;
      y+=sin(rot)*BulletSpeed;
    }
  }
  
  void show(){
    if(dead) return;
    noStroke();
    fill(150);
    pushMatrix();
    translate(x,y);
    rotate(rot);
    image(bullet,0,0,50,30);
    popMatrix();
  }
  
  float GetX(){
    return x;
  }
  void SetX(float NewX){
    x = NewX;
  }
  float GetY(){
    return y;
  }
  void SetY(float NewY){
    y = NewY;
  }
}
