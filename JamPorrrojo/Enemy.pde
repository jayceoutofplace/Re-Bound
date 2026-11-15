class Enemy{
  float x;
  float y;
  
  float rot = 0.0;
  
  float MoveSpeed = 5.0;
  
  boolean retreating = true;
  
  float MaxRad = 200.0;
  
  Player p;
  
  int ReloadTime = int(random(2000,4000));
  int LastShot = 0;
  boolean debounce = false;
  
  Point SelectedIdx = null;
  
  boolean wander = true;
  
  boolean dead = false;
  boolean CanTakeShot = true;
  
  boolean CanCollide = false;
  
  int SpawnProtection = 30;
  
  public Enemy(float _x, float _y, Player _p){
    x = _x;
    y = _y;
    p = _p;
    LastShot = millis();
  }
  
  void addBullet(float x, float y){
    bullets.add(new Bullet(x,y,rot));
  }
  
  void die(){
    for(Bullet bullet:bullets){
      if(collides(bullet.x,bullet.y,50,50,x,y,50,50)&&bullet.CanBeThrown&&CanTakeShot){
        score+=1;
        dead = true;
        CanTakeShot = false;
        bullets.remove(bullet);
        break;
      }
    }
  }
  
  boolean IsCollide(){
      for(int row = 0; row<map.rows; row++){
        for(int col = 0; col<map.cols; col++){
          int tile = map.map[row][col];
          if(tile>=0&&tile<map.tiles.length&&map.tiles[tile]!=null&&map.tiles[tile].IsWall()){
            int xx = col*map.TileSize;
            int yy = row*map.TileSize;
            if(collides(xx,yy,map.TileSize,map.TileSize,x,y,70,70)&&CanCollide){
              return true;
            }
          }
        }
      }
      return false;
  }
  
  void MoveOnCollide(float dx, float dy){
    if(!CanCollide){
      SpawnProtection--;
      if(SpawnProtection<=0){
        CanCollide = true;
      }
    }
    
    x+=dx;
    if(IsCollide()){
      x-=dx;
    }
    y+=dy;
    if(IsCollide()){
      y-=dy;
    }
  }
  
  void update(){
    if(dead) return;
    // Rotation.
    float XDire = p.x-x;
    float YDire = p.y-y;
    rot = atan2(YDire,XDire);
    
    float distSq = sq(XDire)+sq(YDire);
    if(distSq<=sq(MaxRad)){
      retreating = true;
    }else if(distSq>=sq(MaxRad*3)){
      retreating = false;
    }
    
    // ADD THIS SO THE ENEMIES MOVE BACKWARDS STILL.
    /*
    else{
        x-=(XDire/distan)*MoveSpeed;
        y-=(YDire/distan)*MoveSpeed;
      }
    */  
    
    // Moving towards player.
    if(wander){
      if(distSq>0){
        float distan = dist(x,y,p.x,p.y);
        float MoveX = (XDire/distan)*MoveSpeed;
        float MoveY = (YDire/distan)*MoveSpeed;
        MoveOnCollide(MoveX,MoveY); 
      }
    }
    
    float TimeScaler = (slowed&&CanSlow)?0.25:1.0;
    MoveSpeed = 5.0*TimeScaler;
    if(millis()-LastShot>=ReloadTime/TimeScaler && !p.dead){
      addBullet(x,y);
      LastShot = millis();
      ReloadTime = int(random(2200,3800));
    }
    
    // Go to a point.
    if(SelectedIdx==null){ // Searches a point if its empty.
      wander = true;
      for(Point point:points){
        float dx = point.x-x;
        float dy = point.y-y;
        float DistSq = sq(dx)+sq(dy);
        if(DistSq<=sq(500) && !point.taken){
          wander = false;
          point.taken = true;
          SelectedIdx = point;
          break;
        }
      }
    }
    
    if(SelectedIdx!=null){
      float dx = SelectedIdx.x-x;
      float dy = SelectedIdx.y-y;
      float DistSq = sq(dx)+sq(dy);
      float distan = dist(x,y,SelectedIdx.x,SelectedIdx.y);
      if(distan>MoveSpeed){ // Stops the enemy from moving once reaching the point.
        float MoveX = (dx/distan)*MoveSpeed;
        float MoveY = (dy/distan)*MoveSpeed;
        MoveOnCollide(MoveX,MoveY); 
      }else{
        MoveOnCollide(dx,dy); 
      }
      
      if(DistSq>sq(500)){
        SelectedIdx.taken = false;
        wander = true;
        SelectedIdx = null;
      }
    }
    
    if(p.dead){
      if(SelectedIdx!=null){
        SelectedIdx.taken = false;
        wander = true;
        SelectedIdx = null;
      }
    }
    
 
    /*if(slowed&&CanSlow){
      MoveSpeed = 1.0;
      ReloadTime = int(random(5000,5500));
    }else{
      MoveSpeed = 5.0;
      ReloadTime = int(random(2000,4000));
    }*/
  }
  
  void show(){
    if(dead) return;
    pushMatrix();
    translate(x,y);
    rotate(rot);
    fill(0xff);
    image(agent,0,0,100,100);
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
