public class Paddle {
  static final int PADDLE_WIDTH = 30;
  static final int PADDLE_LEFT = 0;
  static final int PADDLE_RIGHT = 1;
  boolean controled;
  int x;
  int controlType;
  int y;
  int size;
  int speed;
  boolean isAlive;
  Integer paddleColor;
  Integer paddleLR;
  String paddleDirection;
  String name;
  
  Paddle(String name, int paddleSize, int paddleLR, Integer paddleColor, boolean controled, int controlType){
    this.controled = controled;
    this.controlType = controlType;
    this.name = name;
    this.y = height / 2;
    this.size = paddleSize;
    this.speed = 15;
    this.isAlive = false;
    this.paddleColor = (paddleColor == null) ? #FFFFFF : paddleColor;
    this.paddleLR = paddleLR;
    this.paddleDirection = "";
    
    if( paddleLR == PADDLE_LEFT ){
      this.x = 0;
    } else if( paddleLR == PADDLE_RIGHT ){
      this.x = width - PADDLE_WIDTH;
    }
  }
  
  void draw(){
    push();
    
    strokeWeight(5);
    stroke(this.paddleColor);
    fill(this.paddleColor, 25);
    rect(this.x, this.y, PADDLE_WIDTH, this.size);
    textSize(22);
    fill((this.paddleColor ^ 0x00FFFFFF) | 0xFF000000);  // Invert color with max alpha 
    strokeWeight(15);
    text(this.name.replace("", "\n").trim(), this.x + 5, this.y + 25);
    
    pop();
  }
  
  void update(){
    if (keyPressed && key == CODED && controled) {
      if(controlType == 0){
      if (keyCode == UP) {
        
        this.paddleDirection = "up";
        this.y = (this.y - this.speed >= 0) ? this.y - this.speed : 0;
      } else if (keyCode == DOWN) {
        this.paddleDirection = "down";
        boolean isAboveScreen = this.y + this.size + this.speed < height;
        this.y = isAboveScreen ? this.y + this.speed : height - this.size;
      }
    } else if(controlType == 1){
      System.out.println("WORKING");
      if (keyCode == SHIFT) {
        this.paddleDirection = "up";
        this.y = (this.y - this.speed >= 0) ? this.y - this.speed : 0;
      } else if (keyCode == CONTROL) {
        this.paddleDirection = "down";
        boolean isAboveScreen = this.y + this.size + this.speed < height;
        this.y = isAboveScreen ? this.y + this.speed : height - this.size;
      }
    } 
    
  }
  }
}
