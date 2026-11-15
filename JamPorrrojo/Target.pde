class Target{
  float x;
  float y;
  
  public Target(float _x, float _y){
    x = _x;
    y = _y;
  }
  
  void show(){
    fill(0xff5500ff);
    ellipse(x,y,100,100);
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
