class Plant {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxforce = 0.3;
  float maxspeed = 1;
  float r;
  float size;
  float spreadX;
  float spreadY;
  float rotation;

  PVector top;
  float windforce = 0;
  float f;

  Plant(PVector position_, float size_, float spreadX_, float spreadY_) {
    position = position_;
    velocity = new PVector();
    acceleration = new PVector();
    size = size_;
    r = size/4;
    spreadX = spreadX_;
    spreadY = spreadY_;
    top = new PVector(r*2, -r*5);
    f = random(-5, 5);
  }
  void display() {
    pushMatrix();
    strokeWeight(1);
    stroke(0);
    translate(position.x+spreadX, position.y);
    rotate(radians(rotation));
    leaves();
    popMatrix();
  }
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    //wind();
  }
  void addForce(PVector force) {
    force.limit(maxforce);
    acceleration.add(force);
  }
  void leaves() {
    beginShape();
    line(0, 0, 0, -r*1.5);
    line(0,-r*1.5,r/2,-r*2.5);
    line(r, -3.5*r, top.x, top.y);
    endShape();
  }
  void wind(){
    windforce++;
    top.x += cos(windforce/10);
  }
}

class PlantSystem {
  ArrayList<Plant> ps;
  PVector origin;

  PlantSystem(PVector origin_) {
    ps = new ArrayList<Plant>();
    origin = origin_;

    for (int i = 0; i < 50; i++) {
      ps.add(new Plant(origin, random(15,30), random(-500, 500), random(0,100)));
    }
  }

  void display() {
    for (int i = ps.size()-1; i >= 0; i--) {
      Plant p = ps.get(i);
      p.update();
      p.display();
    }
  }
  void update() {
  }
  void addForce(PVector force) {
    for (Plant p : ps) {
      p.addForce(force);
    }
  }
}