

public class Board{
  
 ArrayList<Ball> balls = new ArrayList<Ball>();
 
 static final float mu = 0;
  
  public Board(){
    updateAccelerations();
    
  }
  
  
  
  
  public ArrayList<Ball> getBalls(){
   return this.balls; 
  }
  
  public void draw(){
    
    
    for(Ball b: this.balls)
       b.draw();
    
  }
  
  
  
  public void update(){
    
     updateAccelerations();
     
     for(Ball b: this.balls)
       b.update();
     
     
     handleCollisions();
  }
  
  void updateAccelerations(){
    for(Ball b: this.balls){
      PVector velDir = b.vel.copy().normalize();
      b.acc = PVector.mult(velDir, -mu);
    }
  }
  
  
  
  void handleCollisions(){
  Ball b1,b2;
  for(int i=0;i<balls.size();i++){
    for(int j=i+1;j<balls.size();j++){
      b1 = balls.get(i);
      b2 = balls.get(j);
      
      float d = b1.pos.dist(b2.pos);
      int r1 = b1.radius;
      int r2 = b2.radius;
      
      if(d <= r1 + r2){
        
        
        // Creating the normal and tangent unit vectors
        PVector unitNormal = PVector.sub(b2.pos,b1.pos).normalize();
        PVector unitTangent = new PVector(unitNormal.y, -unitNormal.x);
        
        // Seperate the balls
        b2.pos.add(PVector.mult(unitNormal,r1+r2-d));
        
        
        // Saving normal and tangent components of ball 1 velocity
        float v1normal = PVector.dot(unitNormal,b1.vel);
        float v1tangent = PVector.dot(unitTangent,b1.vel);
        
        // Saving normal and tangent components of ball 2 velocity
        float v2normal = PVector.dot(unitNormal,b2.vel);
        float v2tangent = PVector.dot(unitTangent,b2.vel);
        
        // Saving the tangent component of new velocities
        float u1tangent = v1tangent;
        float u2tangent = v2tangent;
         
        // Calculating the normal component of the new velocities
        float u1normal = (v1normal*(b1.mass-b2.mass)+2*b2.mass*v2normal)/(b1.mass+b2.mass);
        float u2normal = (v2normal*(b2.mass-b1.mass)+2*b1.mass*v1normal)/(b1.mass+b2.mass);
        
       
        b1.vel = PVector.add(PVector.mult(unitNormal,u1normal),PVector.mult(unitTangent,u1tangent));
        b2.vel = PVector.add(PVector.mult(unitNormal,u2normal),PVector.mult(unitTangent,u2tangent));
        
       
      }
    }
  }
  
  
  
  
}
  
}
