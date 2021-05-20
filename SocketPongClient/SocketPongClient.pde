/*
 * Run the Pong Server file first, then this Pong client file.
 * The up and down arrow keys move the paddle.
 */
import processing.net.*;
import java.util.*;

Client client;

ArrayList<Ball> pongBalls;
HashMap<String, Paddle> paddles = new HashMap<String, Paddle>();
Paddle myPaddle;
Paddle my1Paddle;
Paddle serverPaddle;
int paddleCount = 0;
int ballDiameter = 50;
int paddleLength = 100;
int scoreLeft = 0;
int scoreRight = 0;
int updateFreqMs = 20;
int now;
JSONArray a;

void setup() {
  size(800, 600);

  pongBalls = new ArrayList<Ball>();
  paddleCount++;
  myPaddle = new Paddle("My"+paddleCount, paddleLength, Paddle.PADDLE_RIGHT, null, true);
  paddleCount++;
  my1Paddle = new Paddle("My"+paddleCount, paddleLength, Paddle.PADDLE_RIGHT, null, true);
    my1Paddle.y = my1Paddle.y - 100;
        myPaddle.y = myPaddle.y + 100;

  paddles.put(myPaddle.name, myPaddle);
  paddles.put(my1Paddle.name, my1Paddle);
 

  client = new Client(this, "localhost", 8080);
  now = millis();
}

void draw() {
  background(0);
  
  sendDataToServer();
  readDataFromServer();
  
  // No need to update the other paddles, their info comes directly from
  // the client messages
  my1Paddle.update();
  myPaddle.update();
  drawPongBalls();
  drawPaddles();
  drawScore();
  a = new JSONArray();
  for(int i = 0; i<paddles.size();i++){
       try{
       JSONObject paddle = new JSONObject();
       paddle.setInt("Side",paddles.get("My"+(i+1)).paddleLR);
       paddle.setInt("PadY",paddles.get("My"+(i+1)).y);
       paddle.setInt("Color",paddles.get("My"+(i+1)).paddleColor);
       a.setJSONObject(i,paddle);
       }catch(Exception e){}
 
     }
}

void drawPongBalls(){
  for( Ball ball : pongBalls ){
    ball.draw();
  }
}

void drawPaddles(){
  for( String paddleName : paddles.keySet() ){
    Paddle paddle = paddles.get(paddleName);
    paddle.draw();
  }
  }


void drawScore(){
  textSize(22);
  fill(#FFFF00);
  text("Score: " + scoreLeft, 50, 50);
  text("Score: " + scoreRight, width - 100 - 50, 50);
}

/*
 * Send message to server/host
 */
void sendDataToServer(){
  if(millis() > now + updateFreqMs) {
     JSONObject obj = new JSONObject();
  obj.setJSONArray("W",a);
    client.write(obj.toString());
    now = millis();
  }
}

/*
 * Called when getting a message from the server/host
 */
void readDataFromServer(){

  if (client.available() > 0) {
   pongBalls.clear();
    String messageFromServer = client.readString();
    JSONObject jsonObj = parseJSONObject(messageFromServer);
     JSONArray info = jsonObj.getJSONArray("E");
     JSONArray pads = jsonObj.getJSONArray("L");
    for(int i = 0; i < info.size(); i++){
   
      JSONObject ball = info.getJSONObject(i);
         Ball b = new Ball(ball.getInt("Size"),ball.getInt("Speed"));
         b.speedX = ball.getInt("SpeedX");
        b.speedY = ball.getInt("SpeedY");
         b.x = ball.getInt("X");
         b.y = ball.getInt("Y");
         b.ballColor = ball.getInt("Color");
        pongBalls.add(b);
    }
      JSONObject pa;
      
   for(int i = 0; i<pads.size();i++){
     
     pa = pads.getJSONObject(i);
    
     Paddle p = new Paddle(""+(i+1),paddleLength,pa.getInt("Side"),pa.getInt("Color"),false);
     p.y = pa.getInt("PadY");
     paddles.put(p.name,p);
     println("test");
     println(p.toString());
     
   }
   
      scoreLeft = jsonObj.getInt("scoreLeft");
      scoreRight = jsonObj.getInt("scoreRight");
      
     
  }
}
