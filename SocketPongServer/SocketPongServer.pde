/*
 * The code below is a template for a multi-player Pong game that
 * communicates over Java sockets. The template only transmits the
 * score from the server to the client so the paddle and ball data
 * need to be transmitted as well. The game data is serialized
 * as strings formatted as a JSONObject. Processing has native
 * support for handling Stringdata in a JSON format:
 * https://www.processing.org/reference/JSONObject.html
 *
 * To Run:
 * Run this Pong Server file first, then the Pong client file.
 * The up and down arrow keys move the paddle.
 * Press 's' key to add a ball
 * The score should be updated on both the server (this file)
 * and the client.
 */
import processing.net.*;
import java.util.*;

Server server;
Client client;
ArrayList<Ball> pongBalls = new ArrayList<Ball>();
HashMap<String, Paddle> paddles = new HashMap<String, Paddle>();
Paddle myPaddle;
Paddle my1Paddle;
Paddle clientPaddle;
boolean ballAdded = false;
int ballDiameter = 50;
int paddleLength = 100;
int scoreLeft = 0;
int scoreRight = 0;
int updateFreqMs = 20;
int now;
JSONObject obj;
 JSONArray  a;
 JSONObject pad;
 JSONArray b;
 int paddleCounter = 0;
void setup(){
  size(800, 600);


  pongBalls = new ArrayList<Ball>();
  paddleCounter++;
  myPaddle = new Paddle("My"+paddleCounter, paddleLength, Paddle.PADDLE_LEFT, null, true);
  paddleCounter++;
  my1Paddle = new Paddle("My"+paddleCounter, paddleLength, Paddle.PADDLE_LEFT, null, true);
  clientPaddle = new Paddle("Client", paddleLength, Paddle.PADDLE_RIGHT, null, false);
  paddles.put(myPaddle.name, myPaddle);
paddles.put(my1Paddle.name, my1Paddle);
 
  
  server = new Server(this, 8080);
  now = millis();
}

void draw(){
  background(0);
  pad = new JSONObject();
obj = new JSONObject();
      a = new JSONArray();
      b = new JSONArray();
     for(int i = 0; i< pongBalls.size();i++){
     JSONObject ball = new JSONObject();
     ball.setInt("Speed",pongBalls.get(i).speed);
      ball.setInt("SpeedX",pongBalls.get(i).speedX);
       ball.setInt("SpeedY",pongBalls.get(i).speedY);
     ball.setInt("Size",pongBalls.get(i).size);
     ball.setInt("X",pongBalls.get(i).x);
     ball.setInt("Y",pongBalls.get(i).y);
       ball.setInt("Color",pongBalls.get(i).ballColor);
     a.setJSONObject(i,ball);
     }
     for(int i = 1; i<paddles.size()+1;i++){
       System.out.println(paddles.size());
       JSONObject paddle = new JSONObject();
       paddle.setInt("Side",paddles.get("My"+i).paddleLR);
       paddle.setInt("PadY",paddles.get("My"+i).y);
       paddle.setInt("Color",paddles.get("My"+i).paddleColor);
       b.setJSONObject(i-1,paddle);
     }
  sendDataToClients();
  readDataFromClient();

  addPongBall();
  purgePongBalls();

  // No need to update the other paddles, their info comes directly from
  // the client messages
  myPaddle.update();

  updateAndDrawPongBalls(); //<>//
  
  drawPaddles();
  drawScore();
}

void addPongBall(){
  if( keyPressed ){
    if( key == 's' && !ballAdded ){
      ballAdded = true;
      pongBalls.add( new Ball(ballDiameter, 3) );
      
      for( Ball b : pongBalls ){
        b.startBall();
      }
    }
  }
}

void purgePongBalls(){
Iterator<Ball> it = pongBalls.iterator();
  while(it.hasNext()){
    Ball b = it.next();
    if( !b.isAlive ){
      if( b.x < 0 ){
        scoreRight = scoreRight + 1;
      } else if ( b.x > width ){
        scoreLeft = scoreLeft + 1;
      }
      it.remove();
    }
  }
}

void updateAndDrawPongBalls(){
  for( Ball ball : pongBalls ){
    ball.update();
    
    for( String paddleName : paddles.keySet() ){
      Paddle paddle = paddles.get(paddleName);
      
      // TODO: This can be optimized
      if( ball.x < width / 2 ){
        if( paddle.paddleLR == Paddle.PADDLE_LEFT ){
          ball.isCollision(paddle);
        }
      } else {
        if( paddle.paddleLR == Paddle.PADDLE_RIGHT ){
          ball.isCollision(paddle);
        }
      }
    }
    
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

void keyReleased(){
 ballAdded = false;
 myPaddle.paddleDirection = ""; 
}
 //<>// //<>//
/*
 * Send message to client(s)/player(s)
 */
void sendDataToClients(){
  if(millis() > now + updateFreqMs) {
    
   
    obj.setJSONArray("E", a);
    obj.setJSONArray("L",b);
    obj.setInt("PadY",myPaddle.y);
    obj.setInt("scoreLeft", scoreLeft);
    obj.setInt("scoreRight", scoreRight);
    println(obj.toString());
    server.write(obj.toString());
    now = millis();
  }
}

/*
 * Get a message from the client(s)/player(s)
 */
void readDataFromClient(){
  client = server.available();
  while( client != null ){
   JSONObject jsonObj = parseJSONObject(client.readString());
      clientPaddle.y = jsonObj.getInt("PadY");
        client = server.available();
  }
}
