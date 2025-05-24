

public class Ball{

  PVector pos;
  PVector vel;
  PVector acc;
  
  int radius, mass, massLength;
  color col;
  
  static final int minR = 20;
  static final int maxR = 100;
  static final int MaxInitialSpeed = 8;
  
    
  public Ball(PVector initPos, PVector initVel, int r, int m, int massLength, color c){
    this.pos = initPos;
    this.vel = initVel;
    this.radius = r;
    this.mass = m;
    this.massLength = massLength;
    this.col = c;
    
  }
  
  public void draw(){
    
      stroke(color(0,0,0));
      strokeWeight(2);
      fill(this.col);
      circle(this.pos.x, this.pos.y, 2*radius);
      fill(0);
      textSize(20);
      text(this.mass,this.pos.x-5*this.massLength,this.pos.y+5);
  }
  

  
  public void update(){
    
    // update position and velocity
    this.vel.add(this.acc);
    this.pos.add(this.vel);
   
   
     // Detecte boundery collisions
     if(this.pos.y < this.radius) {
       this.pos.y = this.radius;
       this.vel.y *= -1;
     }else if(this.pos.y + this.radius > height){
       this.pos.y = height - this.radius;
       this.vel.y *= -1;
     }
     
     
     if(this.pos.x < this.radius){
         this.pos.x = this.radius;
         this.vel.x *= -1;
     }else if(this.pos.x + this.radius > width){
         this.pos.x = width - this.radius;
         this.vel.x *= -1;
     }
     
     
          
   }

   
   
   
   
   
  }
  
  
