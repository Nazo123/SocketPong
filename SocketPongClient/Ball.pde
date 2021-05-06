public class Ball {
  int x;
  int y;
  int size;
  int speed;
  int speedX;
  int speedY;
  Integer ballColor;
  boolean isAlive;
  boolean isIntersects;

  Ball(int size, int speed) {
    this.x = width / 2;
    this.y = height / 2;
    this.size = size;
    this.speed = speed;
    this.speedX = 0;
    this.speedY = 0;
    this.ballColor = #FFFFFF;
    this.isAlive = false;
    this.isIntersects = false;
  }

  void draw() {
    push();
    
    strokeWeight(5);
    stroke(this.ballColor);
    fill(this.ballColor, 100);
    ellipse(this.x, this.y, this.size, this.size);
    
    pop();
  }
}
