class Particle {

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity = new PVector(0, 0.04);
  float lifespan = 255;
  boolean isDead;  
  float diam;

  Particle(PVector loc, float diam_, float firespan_,float accXmin, float accXmax, float accYmin, float accYmax) {
    acceleration = new PVector(random(accXmin, accXmax), random(accYmin, accYmax));
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = loc.get();
    diam = diam_;
  }
  void update() {
    checkEdges();
    // addForce(gravity);
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan-= 8;
  }
  void display() {
    pushMatrix();
    noStroke();
    fill(255, lifespan, lifespan-50, lifespan);
    ellipse(location.x, location.y, diam, diam);
    popMatrix();
  }
  void addForce(PVector force) {
    acceleration.add(force);
  }
  boolean isDead() {
    if (lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }
  void checkEdges() {
    if (location.y > height*2/3) {
      velocity.y =0;
      velocity.x *= 0.1;
    }
  }
}



class ParticleSystem {
  ArrayList<Particle> ps;
  PVector origin;
  float fire = 0;
  float lifespan;
  float magnitude;

  ParticleSystem(PVector origin_, float magnitude_,float lifespan_,float xMin,float xMax,float yMin,float yMax) {
    ps = new ArrayList<Particle>();
    origin = origin_;
    magnitude = magnitude_;
    lifespan = lifespan_;
    for (int i = 0; i < 15; i++) {
      ps.add(new Particle(origin, magnitude, fire,xMin,xMax,yMin,yMax));
    }
    
  }

  void display() {
    for (int i = ps.size()-1; i >= 0; i--) {
      Particle p = ps.get(i);
      p.update();
      p.display();
    }
    lifespan--;
  }
  void update() {
    fire += 0.01;
    for (int i = ps.size()-1; i >= 0; i--) {
      Particle p = ps.get(i);
      if (p.isDead) {
        ps.remove(i);
      }
    }
    if (ps.size() > 40) {
      ps.remove(0);
    }
  }
  void addForce(PVector force) {
    for (Particle p : ps) {
      p.addForce(force);
    }
  }
}