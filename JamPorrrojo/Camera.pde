class Camera{
  float x;
  float y;
  
  public Camera(float _x, float _y){
    x = _x;
    y = _y;
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
