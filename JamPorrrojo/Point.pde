class Point{
  float x;
  float y;
  
  final float POINT_SIZE = 50.0;
  
  boolean taken = false;
  
  public Point(float _x, float _y){
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
