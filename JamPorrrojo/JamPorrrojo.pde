Player player;

float zoom = 0.66; //1.0 0.5 for testing.
float TZoom = zoom;
Camera cam;

ArrayList<Enemy> enemies = new ArrayList<Enemy>(0);

ArrayList<Point> points = new ArrayList<Point>(0);
final float NUM_POINTS = 11.0;
final float RAD = 500.0;
boolean ShowPoints = false;

ArrayList<Bullet> bullets = new ArrayList<Bullet>(0);

boolean slowed = false;
boolean CanSlow = true;

PImage stick;
PImage agent;
PImage bullet;

Map map;

Door TopDoor;
Door LeftDoor;
Door RightDoor;
Door BottomDoor;

int score = 0;
int wave = 0;

boolean JustSlowed = false;
int FrameCooldownSlow = 300;

PImage title;
PImage dead;
boolean GameStarted = false;

void setup(){
  size(1280,720,P2D);
  textAlign(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  noStroke();
  map = new Map("data/map.txt");
  player = new Player(width/2,height/2,map);
  cam = new Camera(player.x,player.y);
  
  for(int i = 0; i < NUM_POINTS; i++){
    float angle = TWO_PI/NUM_POINTS*i;
    float x = width/2+RAD*cos(angle);
    float y = height/2+RAD*sin(angle);
    points.add(new Point(x,y));
  }
  stick = loadImage("data/stick.png");
  agent = loadImage("data/agent.png");
  bullet = loadImage("data/bullet.png");
  TopDoor = new Door(width/2,20,120,10,false);
  LeftDoor = new Door(20,height/2,10,120,true);
  RightDoor = new Door(width+587,height/2,10,120,true);
  BottomDoor = new Door(width/2,height+316,120,10,false);
  dead = loadImage("data/dead.png");
  title = loadImage("data/main.png");
}

void draw(){
  background(0);
  //println("FPS: "+int(frameRate));
  if(GameStarted){
    IDKwhattocallthisbutthishandlesthebulletcooldown();
    DrawWorld();
  }else{
    image(title,width/2,height/2,1280,720);
    fill(0xffff0000);
    rect(width/2,height-100,300,60);
    fill(0);
    textSize(28);
    text("start game",width/2,height-100);
    if(mousePressed){
      if(dist(mouseX,mouseY,width/2,height-100)<100){
        GameStarted = true;
      }
    }
  }
}

void DrawWorld(){
  cam.SetX(player.GetX());
  cam.SetY(player.GetY());
  pushMatrix();
  translate(width/2,height/2);
  scale(zoom);
  translate(-cam.GetX(),-cam.GetY());
  HandleSlowAnims();
  DrawMap();
  DrawPlayer();
  DrawPoints();
  DrawDoors();
  DrawEnemies();
  DrawBullets();
  popMatrix();
  DrawUI();
}

void DrawPlayer(){
  player.keyHandler();
  player.update();
  player.UpdatePoints();
  player.die();
  player.show();
}

void DrawEnemies(){
  for(Enemy e:enemies){
    e.update();
    e.die();
    e.show();
  }
}

void DrawPoints(){
  if(!ShowPoints) return;
  for(int i = 0; i < points.size(); i++){
    Point CurrentPoint = points.get(i);
    fill(0xffff0000);
    ellipse(CurrentPoint.x,CurrentPoint.y,50,50);
  }
}

void DrawBullets(){
  // Shooting bullet.
  for(Bullet b:bullets){
    b.shoot();
    b.die();
    b.update();
    b.show();
  }
}

void HandleSlowAnims(){
  if(player.dead) return;
  zoom = zoom+(TZoom-zoom)*0.3;
  if(slowed&&CanSlow){
    TZoom = 1.0;
    //zoom = 1.0;
  }else{
    TZoom = 0.66;
    //zoom = 0.5;
  }
}

void DrawMap(){
  map.show();
}

void DrawDoors(){
  TopDoor.update();
  TopDoor.show();
  
  LeftDoor.update();
  LeftDoor.show();
  
  RightDoor.update();
  RightDoor.show();
  
  BottomDoor.update();
  BottomDoor.show();
  
  if(TopDoor.CanGoUp || LeftDoor.CanGoUp || RightDoor.CanGoUp || BottomDoor.CanGoUp){
    wave++;
    TopDoor.CanGoUp = false;
    LeftDoor.CanGoUp = false;
    RightDoor.CanGoUp = false;
    BottomDoor.CanGoUp = false;
  }
}

void IDKwhattocallthisbutthishandlesthebulletcooldown(){
  if(JustSlowed){
    CanSlow = false;
    FrameCooldownSlow-=1;
    if(FrameCooldownSlow<=0){
      JustSlowed = false;
      CanSlow = true;
    }
  }
}

void DrawUI(){
  textSize(32);
  fill(0xff);
  text("Score: "+score+" Wave: "+wave,150,50);
  if(player.dead){
    image(dead,width/2,height/2,width,height);
    fill(0);
    textSize(48);
    text("YOU DIED (press r to restart btw)",width/2,50);
  }
}

void ResetThings(){
  score = 0;
  wave = 0;
  player.dead = false;
  player.CanTakeShot = true;
  player.SetX(width/2);
  player.SetY(height/2);
  player.XVel = 0.0;
  player.YVel = 0.0;
  CanSlow = true;
  slowed = false;
  enemies.clear();
  bullets.clear();
  player.FirstBullet = null;
  for(Point p: points){
    p.taken = false;
  }
}

void DrawTestingCube(){
  fill(0xff);
  rect(width/2,height/2,50,50);
}

void keyPressed(){
  if(key=='w') player.keys[0] = true;
  if(key=='a') player.keys[1] = true;
  if(key=='s') player.keys[2] = true;
  if(key=='d') player.keys[3] = true;
  
  if(key==' '&&CanSlow) slowed = true;
  
  if(key=='r'&&player.dead) ResetThings();
}

void keyReleased(){
  if(key=='w') player.keys[0] = false;
  if(key=='a') player.keys[1] = false;
  if(key=='s') player.keys[2] = false;
  if(key=='d') player.keys[3] = false;
  
  if(key==' '){
    slowed = false;
    JustSlowed = true;
    FrameCooldownSlow = 300; 
  }
}

boolean collides(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2){
  float dx = abs(x1-x2);
  float dy = abs(y1-y2);
  float MaxDx = (w1+w2)*0.5;
  float MaxDy = (h1+h2)*0.5;
  return dx<=MaxDx&&dy<=MaxDy;
}

boolean collides(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2){
  return x1+w1>=x2
         &&x1<=x2+w2
         &&y1+h1>=y2
         &&y1<=y2+h2;
}
