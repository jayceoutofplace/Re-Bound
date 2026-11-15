class Door{
  float x;
  float y;
  float w;
  float h;
  PImage img;
  boolean IsVert;
  
  int NextCount = int(random(1,5));
  int SpawnTimer = 0;
  int TimeToSpawn = 200;
  boolean CombatLock = false;
  
  boolean CanGoUp = false;
  
  public Door(float _x, float _y, float _w, float _h, boolean _IsVert){
    img = loadImage("data/topdoor.png");
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    IsVert = _IsVert;
  }
  
  void AddEnemy(float xx, float yy){
    int xoffs = IsVert?200:0;
    int yoffs = IsVert?0:200;
    if(x>=597){
      xoffs = IsVert?-200:0;
    }
    if(y>=316){
      yoffs = IsVert?-0:-200;
    }
    enemies.add(new Enemy(xx+xoffs,yy+yoffs,player));
  }
  
  void update(){
    if(!CombatLock){
      SpawnTimer+=1;
    }
    if(SpawnTimer>=TimeToSpawn && !CombatLock){
      for(int i = 0; i < NextCount; i++){
        AddEnemy(x,y);
        CombatLock = true;
      }
      CanGoUp = true;
      NextCount = int(random(1,5));
      SpawnTimer = 0;
    }
    
    for(int i = enemies.size()-1; i >= 0; i--){
      Enemy ce = enemies.get(i);
      if(ce.dead){
        enemies.remove(ce);
      }
    }
    
    //println(enemies.size());
    if(enemies.size()==0){
      CombatLock = false;
    }
  }
  
  void show(){
    pushMatrix();
    translate(x,y);
    /*if(IsVert){
      rotate(HALF_PI);
    }*/
    noTint(); // STOP DRAWING OVER MY DOOR!
    image(img,0,0,w,h);
    popMatrix();
  }
}
