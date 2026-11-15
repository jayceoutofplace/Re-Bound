class Player{
  float x;
  float y;
  
  float XVel = 0.0;
  float YVel = 0.0;
  float acceleration = 5.0;
  
  boolean[] keys = new boolean[4];
  
  boolean dead = false;
  
  final float BULLET_CHECK_RADIUS = 250;
  Bullet FirstBullet = null;
  
  float TargetX = 0.0;
  float TargetY = 0.0;
  Target target;
  
  boolean PrevMouse = false;
  
  boolean CanTakeShot = true;
  
  boolean CanWalk = true;
  
  Map m;
  
  public Player(float _x, float _y, Map _m){
    x = _x;
    y = _y;
    target = new Target(TargetX,TargetY);
    m = _m;
  }
  
  void keyHandler(){
    if(keys[0]&&!player.dead) YVel-=acceleration;
    if(keys[1]&&!player.dead) XVel-=acceleration;
    if(keys[2]&&!player.dead) YVel+=acceleration;
    if(keys[3]&&!player.dead) XVel+=acceleration;
  }
  
  void UpdatePoints(){
    for(int i = 0; i < points.size(); i++){
      Point p = points.get(i);
      float angle = TWO_PI/NUM_POINTS*i;
      p.x = x+RAD*cos(angle);
      p.y = y+RAD*sin(angle);
    }
  }
  
  void die(){
    for(Bullet bullet:bullets){
      if(collides(bullet.x,bullet.y,50,50,x,y,50,50)&&!bullet.CanBeThrown&&CanTakeShot){
        CanSlow = false;
        CanTakeShot = false;
        dead = true;
        bullets.remove(bullet);
        break;
      }
    }
  }
  
  boolean IsCollide(){
    for(int row = 0; row<m.rows; row++){
      for(int col = 0; col<m.cols; col++){
        int tile = m.map[row][col];
        if(tile>=0&&tile<m.tiles.length&&m.tiles[tile]!=null&&m.tiles[tile].IsWall()){
          int xx = col*m.TileSize;
          int yy = row*m.TileSize;
          if(collides(xx,yy,m.TileSize,m.TileSize,x,y,100,100)){
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void update(){
    if(dead) return;
    XVel*=0.8;
    YVel*=0.8;
    x+=XVel;
    if(IsCollide()){
      x-=XVel;
      XVel = 0;
    }
    y+=YVel;
    if(IsCollide()){
      y-=YVel;
      YVel = 0;
    }
    
    boolean JustClicked = mousePressed&&!PrevMouse;
    
    if(slowed&&CanSlow){
      acceleration = 1.0;
    }else{
      acceleration = 5.0;
    }
    
    if(FirstBullet==null && slowed){ // Searching for first bullet.
      for(Bullet b:bullets){
        float dx = b.x-x;
        float dy = b.y-y;
        float DistSq = sq(dx)+sq(dy);
        float RadSq = sq(BULLET_CHECK_RADIUS);
        if(DistSq<=RadSq && JustClicked){ // Check 500 pixels for the bullet.
          FirstBullet = b;
          FirstBullet.held = true; // Stops movement while held.
          bullets.remove(b);
          break; // Stop searching once found.
        }
      }
    }else if(FirstBullet!=null){
      CanSlow = false;
      FirstBullet.x = x;
      FirstBullet.y = y;
      FirstBullet.CanBeThrown = true;
      // Gotta calculate screen to world bs.
      float WorldMouseX = cam.GetX()+(mouseX-width/2.0)/zoom;
      float WorldMouseY = cam.GetY()+(mouseY-height/2.0)/zoom;
      target.x = WorldMouseX;
      target.y = WorldMouseY;
      target.show();
      
      if(JustClicked){
        TargetX = WorldMouseX;
        TargetY = WorldMouseY;
        float dx = WorldMouseX-x;
        float dy = WorldMouseY-y;
        float angle = atan2(dy,dx);
        FirstBullet.rot = angle;
        FirstBullet.held = false; // LET IT RIP
        bullets.add(FirstBullet);
        FirstBullet = null; // Remove from player.
        CanSlow = true;
      }
    }
    PrevMouse = mousePressed;
  }
  
  void show(){
    if(dead) return;
    if(slowed&&CanSlow){
      noFill();
      stroke(0xff);
      strokeWeight(4);
      ellipse(x,y,BULLET_CHECK_RADIUS*2,BULLET_CHECK_RADIUS*2);
    }
    //fill(0xff);
    image(stick,x,y,100,100);
    if(FirstBullet!=null){
      FirstBullet.show();
    }
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
