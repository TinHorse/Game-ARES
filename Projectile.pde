class Projectile {

  PVector acceleration;
  PVector velocity;
  PVector location;
  PVector target;

  float maxforce;
  float maxspeed;

  boolean make = true;
  float fillcol;
  float projectile_count;
  float damage;
  float r;
  
  int lifetime = 200;


  Projectile(PVector location_, PVector target_, float fillcol_, float projectile_count_, float speed_, float damage_) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = location_;
    target = target_;
    target.sub(location);
    fillcol = fillcol_;
    projectile_count = projectile_count_;
    maxspeed = speed_;
    maxforce = maxspeed/20;
    damage = damage_;
  }
  void move() {
    checkImpact(walker, player, plateau);
    velocity.add(acceleration).limit(maxspeed);
    location.add(velocity);
  }
  void display() {
    float z = velocity.heading();
    r = damage*1.5;
    pushMatrix();
    stroke(0);
    strokeWeight(1);
    fill(255-fillcol,225-fillcol,0);
    translate(location.x, location.y);
    beginShape(TRIANGLES);
    rotate(z);
    vertex(r*4, 0);
    vertex(-r, r);
    vertex(-r, -r);
    endShape();
    fill(0);
    rect(0,0,r,r);
    rect(-10,0,r/1.5,r/1.5);
    popMatrix();

    //ellipse(location.x, location.y, 7, 7);
  }

  void addForce(PVector force) {
    acceleration.add(force).limit(maxforce);
  }
  void create() {
    addForce(target);
  }
  void checkImpact(ArrayList<Walker> walker, Player player, ArrayList<Plateau> plateau) {
    boolean friendly;
    if (fillcol > 5) {
      friendly = true;
    } else {
      friendly = false;
    }
    float range = 0;
    float d = 0;
    for (Walker w : walker) {
      d = dist(location.x, location.y, w.head.x, w.head.y);

      range = w.scalar*0.75;
      if (d < range && friendly == false) {
        metal_sound = true;
        make = false;
        
        if (friendly == false) {
          w.health -= damage;
        }
        sparks.add(new ParticleSystem(location, 3, 100, -5, 0, -4, 10));
      }
    }
    float dis = dist(player.position.x+player.gunposition.x, player.position.y+player.gunposition.y, location.x, location.y);
    float range2 = 30;
    if (dis < range2 && friendly == true) {
      hit_sound = true;
      make = false;
      sparks.add(new ParticleSystem(location, 3, 50, -5, 0, -4, 10));
      player.health -= damage;
    }

    float xRange3 = 0;
    float yRange3 = 0;
    float d3 = 0;
    for (Plateau p : plateau) {
      d3 = dist(location.x, location.y, p.position.x, p.position.y);
      xRange3 = p.w.x/2;
      yRange3 = p.h.y/2 + 2;
      if (d3 < xRange3 && location.y < p.position.y+yRange3 && location.y > p.position.y-yRange3) {
        impact_sound = true;
        make = false;
        sparks.add(new ParticleSystem(location, 2, 5, -5, 0, -4, 10));
      }
    }

    float range4 = 0;
    float d4 = 0;
    for (Soldier s : soldier) {
      d = dist(location.x, location.y, s.position.x,s.position.y-35);
      range4 = 12;
      if (d < range4 && friendly == false && s.diecount< 1) {
        metal_sound = true;
        make = false;
        if (friendly == false) {
          s.health -= damage;
        }
        sparks.add(new ParticleSystem(location, 3, 5, -5, 0, -4, 10));
      }
    }
  }
}