

Board board;

float posX, posY, velX, velY, Radius;
int Mass, massLength;
int ballsAmount;
final int MaxAmount = 8;

color[] colors = {color(128, 255, 128),color(255, 0, 128),color(0, 128, 255),color(158,128,158),color(220,190,100), color(250,200,250),color(204,204,153),color(153,153,220)};



public static enum STATE {
    Ready,
    ChoosePosition,
    ChooseRadius,
    ChooseMass,
    ChooseInitialVelocity,
    Simulator;
}

STATE state, nextState;


void setup() {
  size(1200,700);
  board = new Board();
  //createBalls();
  
  
  
  state = STATE.Ready;
  ballsAmount = 0;
  
}

void createBalls(){
   
    
    board.balls.add(new Ball(new PVector(100,100),new PVector(4,5),30,20,2,color(128, 255, 128)));
    board.balls.add(new Ball(new PVector(500,100),new PVector(-2,4),50,40,2,color(255, 0, 128)));
    board.balls.add(new Ball(new PVector(250,500),new PVector(3,-3),100,100,2,color(0, 128, 255)));
    
    
}

void drawArrow(PVector p1, PVector p2){
  
  PVector d = PVector.sub(p2, p1);
  PVector normal = new PVector(d.y, -d.x);
  
  line(p1.x,p1.y, p2.x, p2.y);
  
  d.normalize();
  normal.normalize().mult(10);
  
  PVector u1 = PVector.add(PVector.sub(p2,PVector.mult(d,15)),normal);
  PVector u2 = PVector.sub(PVector.sub(p2,PVector.mult(d,15)),normal);
  
  line(u1.x,u1.y, p2.x, p2.y);
  line(u2.x,u2.y, p2.x, p2.y);
}


void previewBalls(){
  stroke(0);
  for(Ball b: board.balls){
    if(b.vel.mag() > b.radius){
      drawArrow(b.pos, PVector.add(b.pos, b.vel));
      b.draw();
    }else{
      b.draw();
      drawArrow(b.pos, PVector.add(b.pos, b.vel));
      
    }
  }
  
}


void draw(){
  background(255,255,255);
  fill(255);
  stroke(0);
  strokeWeight(4);
  rect(0,0,width-2,height-2,2);
  strokeWeight(2);
  
  
  if(state != STATE.Simulator){
    
    
    previewBalls();
    
    
    if(state == STATE.Ready){
      if(ballsAmount < MaxAmount){
        fill(60,160,60);
        rect(width/2-100,height-100, 200,80);
        fill(0);
        textSize(50);
        text("New Ball", width/2-90,height-45);
      }
      
      fill(60,160,160);
      rect(width-270,height-160, 250,150,20);
      fill(0);
      textSize(50);
      text("Start", width-200,height-100);
      text("Simulation!", width-265,height-40);
      
    }else{
      stroke(0);
      fill(160,60,60);
      rect(width/2-100,height-100, 200,80);
      fill(0);
      textSize(50);
      text("Delete", width/2-65,height-45);
      fill(60,60,60);
      if(state == STATE.ChoosePosition || state == STATE.ChooseRadius){
        if(state == STATE.ChoosePosition){
          posX = mouseX;
          posY = mouseY;
        }
        circle(posX, posY, 2 * Radius);
        
        if(state == STATE.ChooseRadius)
          Radius = fixValue(dist(posX, posY, mouseX, mouseY), Ball.minR, Ball.maxR);
        
        if(!isPositionValid()){
          
         stroke(255,0,0);
         line(posX-0.707*Radius, posY-0.707*Radius,posX+0.707*Radius, posY+0.707*Radius);
         line(posX+0.707*Radius, posY-0.707*Radius,posX-0.707*Radius, posY+0.707*Radius);
        }
        
      }else if(state == STATE.ChooseMass || state == STATE.ChooseInitialVelocity) {
        circle(posX, posY, 2 * Radius);
        fill(0);
        textSize(20);
        text(Mass,posX-5*massLength,posY+5);
        
        if(state == STATE.ChooseInitialVelocity)
          drawArrow(new PVector(posX, posY), new PVector(mouseX, mouseY));
      }
      
      
    }

   
    
  }else{ //Simulator
    board.draw();
    board.update();
  }
  
}


float fixValue(float val, int min, int max){
 if(val < min)  return min;
 else if(val > max)  return max;
 return val;
  
}

boolean isPositionValid(){
  if(posY < Radius || posY + Radius > height ||
     posX < Radius || posX + Radius > width)
     return false;
  
  for(Ball b: board.balls){
   if(dist(b.pos.x, b.pos.y,posX, posY) < b.radius + Radius) 
    return false;
  }
  return true;
}



boolean isMouseOn(int x, int y, int w, int h){
  
  return (x <= mouseX && mouseX <= x+w) && (y <= mouseY && mouseY <= y+h);
  
}


void keyPressed(){
 
  if(state == STATE.ChooseMass){
    
    
    
    if(keyCode == ENTER){
      state = STATE.ChooseInitialVelocity;
    }else if(keyCode == BACKSPACE){
      Mass = 0;
      massLength = 1;
      
    }else if(48 <= int(key) && int(key) <= 57 && massLength <= 2){
      if(Mass != 0)
        massLength++;
      Mass = 10*Mass + int(key) - 48;
      
    }
  }
  
}


void normelizeVelocities(){
  float maxVel = 0;
  for(Ball b:board.balls)
   if(b.vel.mag() > maxVel)
     maxVel = b.vel.mag();
  
  for(Ball b:board.balls){
    b.vel.mult(Ball.MaxInitialSpeed/maxVel);
    b.vel.x = int(b.vel.x);
    b.vel.y = int(b.vel.y);
  }
  
}

void mousePressed(){
  
  if(state != STATE.Ready && state != STATE.Simulator  && isMouseOn(width/2-100,height-100, 200,80)){
   
     state = STATE.Ready;
    
  }else{
  
  if(state == STATE.Ready && ballsAmount < MaxAmount && isMouseOn(width/2-100,height-100, 200,80)){
    state = STATE.ChoosePosition;
    Radius = Ball.minR;
  }else if(state == STATE.Ready && isMouseOn(width-270,height-160, 250,150)){
    normelizeVelocities();
    state = STATE.Simulator;
  }else if(state == STATE.ChoosePosition){
    
    if(isPositionValid()){
      state = STATE.ChooseRadius;
    }
    
  }else if(state == STATE.ChooseRadius){
    
    if(isPositionValid()){
      state = STATE.ChooseMass;
      Mass = 0;
      massLength = 1;
    }
    
  }else if(state == STATE.ChooseInitialVelocity){
  
    velX = mouseX - posX;
    velY = mouseY - posY;
    
    board.balls.add(new Ball(new PVector(posX,posY),new PVector(velX,velY),int(Radius),Mass, massLength,colors[ballsAmount]));
    ballsAmount++;
    
    state = STATE.Ready;
  }
  
  }

}
