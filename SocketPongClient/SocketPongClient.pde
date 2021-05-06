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

int ballDiameter = 50;
int paddleLength = 100;
int scoreLeft = 0;
int scoreRight = 0;
int updateFreqMs = 20;
int now;

void setup() {
  size(800, 600);

  pongBalls = new ArrayList<Ball>();
  myPaddle = new Paddle("", paddleLength, Paddle.PADDLE_RIGHT, null);
  paddles.put(myPaddle.name, myPaddle);

  client = new Client(this, "localhost", 8080);
  now = millis();
}

void draw() {
  background(0);
  
  sendDataToServer();
  readDataFromServer();
  
  // No need to update the other paddles, their info comes directly from
  // the client messages
  myPaddle.update();

  drawPongBalls();
  drawPaddles();
  drawScore();
}

void drawPongBalls(){
  for( Ball ball : pongBalls ){
    ball.draw();
  }
}

void drawPaddles(){
  for( String paddleName : paddles.keySet() ){
    paddles.get(paddleName).draw();
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
    client.write("This is the Client " + millis());
    now = millis();
  }
}

/*
 * Called when getting a message from the server/host
 */
void readDataFromServer(){
  if (client.available() > 0) {
    String messageFromServer = client.readString();
    JSONObject jsonObj = parseJSONObject(messageFromServer);
    if( jsonObj != null ){
      scoreLeft = jsonObj.getInt("scoreLeft");
      scoreRight = jsonObj.getInt("scoreRight");
    }
  }
}
