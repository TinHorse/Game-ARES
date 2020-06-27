class Player {

  PVector position;
  PVector footpos;
  float translation;

  PVector hip;
  PVector knee;
  PVector knee2;
  PVector foot;
  PVector foot2;

  float mov;
  float mov2;
  float c;

  PVector gunposition;
  PVector gun;
  PVector target;

  float moveleft = 1;
  PVector shot;

  float reload_count = 0;
  boolean jumping = false;
  boolean walkingright = false;
  boolean walkingleft = false;

  float health = 200;
  float fuel = 100;

  float jumpcount = -20;
  float jumpfactor = 1;

  PVector velocity;
  PVector acceleration;
  float maxforce = 4;
  float maxspeed = 6;

  PVector fpoint;


  boolean plateau = false;
  boolean rocket = false;
  boolean flagattack = false;


  float ammo = 500;
  float rocketcount = 0;
  float flagcount = 0;
  PVector flagpoint;
  
  float reload = 10;
  float projectile_amount = 6;


  Player(PVector position_, PVector footpos_) {
    position = position_;
    footpos = footpos_;

    gunposition = new PVector(-10, -80);
    gun = new PVector(0, 0);

    hip = new PVector(0, -20);
    foot = new PVector(0, 0);
    foot2 = new PVector(0, 0);
    knee = new PVector(0, -15);
    knee2 = new PVector(0, -15);

    target = new PVector(mouseX, mouseY);

    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    flagpoint = new PVector(0, 0);
  }

  void forceAccumulation() {
    velocity.add(acceleration).limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void addForce(PVector force) {
    acceleration.add(force).limit(maxforce);
  }

  void displayRight() {  
    
    pushMatrix();
    rectMode(CENTER);
    translate(position.x, position.y+translation);
    translate(0, -35);
    stroke(255);
    fill(255);
    strokeWeight(2);

    // leg joints and triangles (body)
    pushMatrix();
    stroke(0);
    pushMatrix();
    translate(0, -14);
    triangle(5, 10, -40, 20, -3, -16);
    popMatrix();
    translate(-25, -30);
    rotate(radians(15));
    triangle(5, -5, -40, -30, 0, -25);
    translate(-10, -30);
    triangle(5, -5, -40, -10, 10, -15);
    popMatrix();

    ellipse(-10, -8, 35, 35);
    pushMatrix();
    fill(0);
    ellipse(-10, -8, 25, 25);
    popMatrix();

    // spine

    pushMatrix();
    stroke(0);
    translate(-20, -35);
    rotate(radians(-25));
    fill(0);
    rect(0, 0, 20, 10);
    for (int i = 0; i < 7; i++) {
      translate(3, (i*2)-16);
      rotate(radians(30));
      rect(0, 0, 20-i*4, 10-i*2);
    }
    popMatrix();

    // head and arm rectangles 

    pushMatrix();
    stroke(255);
    translate(0, -70);
    pushMatrix();
    rotate(radians(15));
    rect(0, 0, 25, 30);
    popMatrix();
    fill(0, 100, 150);


    triangle(18, -8, 3, 17, 30, 30);
    pushMatrix();
    translate(-20, 30);
    fill(0, 100, 150);
    for (int i = 0; i < 5; i++) {
      translate(-5, -5);
      rotate(radians(30));
      rect(0, 0, 8, 20);
    }
    popMatrix();
    popMatrix();



    pushMatrix();
    translate(0, -50);
    fill(255);
    ellipse(-10, 0, 20, 20);
    pushMatrix();
    fill(0);
    ellipse(-10, 0, 15, 15);
    popMatrix();
    popMatrix();

    popMatrix();


    for (int i = projectile.size()-1; i >= 0; i--) {
      Projectile p = projectile.get(i);
      if (p.make) {
        pushMatrix();
        p.display();
        p.move();
        
        popMatrix();
      }
      if (p.lifetime <= 0) {
        projectile.remove(i);
      }
    }
  }

  void arms() {
    pushMatrix();

    stroke(0);
    translate(-10, -60);
    stroke(0, 100, 130);
    ellipse(0, 0, 12, 12);
    fill(0);
    ellipse(0, 20, 6, 6);
    stroke(0);
    strokeWeight(7);
    line(0, 0, 0, 20);
    line(0, 20, 10, 30);
    pushMatrix();
    strokeWeight(10);
    translate(10, 30);
    float f = gun.heading();

    rotate(f);
    f = constrain(f, 0, PI/80);
    translate(30, 0);

    triangle(-34, 0, 3, 0, 0, 3);

    popMatrix();


    popMatrix();
  }
  void legs() {
    pushMatrix();

    strokeWeight(2);
    stroke(0);
    translate(-10, 0);
    fill(255);
    ellipse(hip.x, hip.y, 22, 22);
    ellipse(knee.x, knee.y, 14, 14);
    ellipse(knee2.x, knee2.y, 14, 14);

    pushMatrix();
    strokeWeight(12);
    line(hip.x, hip.y, knee.x, knee.y);
    line(hip.x, hip.y, knee2.x, knee2.y);
    popMatrix();

    pushMatrix();
    stroke(255);
    strokeWeight(2);
    line(hip.x, hip.y, knee.x, knee.y);
    line(hip.x, hip.y, knee2.x, knee2.y);
    popMatrix();

    pushMatrix();
    stroke(0);
    strokeWeight(2);
    fill(255);

    triangle(foot2.x-15, foot2.y+10, foot2.x-4, foot2.y-10, foot2.x+30, foot2.y+10);
    ellipse(foot2.x, foot2.y, 10, 10);
    triangle(foot.x-15, foot.y+10, foot.x-4, foot.y-10, foot.x+30, foot.y+10);
    ellipse(foot.x, foot.y, 10, 10);

    strokeWeight(5);
    line(knee.x, knee.y, foot.x, foot.y);
    line(knee2.x, knee2.y, foot2.x, foot2.y);

    popMatrix();
    popMatrix();
  }
  void displaylaser() {
    pushMatrix();



    target = new PVector(mouseX-initial_position+tracker, mouseY);
    gun = new PVector(mouseX-initial_position+tracker, mouseY).sub(position).sub(gunposition).normalize().mult(40);
    if (health < 1) {
      die();
    }
    if(health == 0){
    explosion_sound = true;
    health -= 1;
    }
    pushMatrix();
    stroke(255,0,0, 150);
    line(position.x, position.y-55, mouseX-initial_position+tracker, mouseY);

    popMatrix();
    popMatrix();
  }
  void displayCross() {
    pushMatrix();
    translate(-initial_position+tracker, 0);
    stroke(200,0,0);
    strokeWeight(3);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
    popMatrix();
  }
  void displayparts() {

    pushMatrix();

    translate(footpos.x, footpos.y);
    translate(0, -20);
    legs();
    popMatrix();

    pushMatrix();
    translate(position.x, position.y);
    translate(0, -25);
    arms();
    popMatrix();
  }
  void displayflag() {

    pushMatrix();

    translate(position.x, position.y);
    translate(-18, -105);
    
    flag();
    popMatrix();
  }


  void flag() {
    PVector flagpoint = new PVector();
    if (flagattack) {
      if(flagcount == 1){fuel -= 50;}
      flag_sound = true;
      flagpoint = new PVector(flagpoint.x+70, flagpoint.y).add(position);
      rotate(radians(110));

      flagcount++;

      moveleft = 1;
      moveRight();
      walkingright = true;
      if (flagpoint.y > height*2/3 -5) {
        sparks.add(new ParticleSystem(flagpoint, 5, 20, 0, 5, -3, -30));
      }
    } else {
      flagpoint = new PVector(flagpoint.x+36, flagpoint.y-98).add(position);
    }

    if (flagcount > 60) {
      flagcount = 0;
      flagattack = false;
    }
    
    for (Walker w : walker) {
      PVector f = new PVector(flagpoint.x+36, flagpoint.y-98);
      float d = PVector.dist(f, w.head);
      float range = w.scalar;
      if (d <= range) {
        if(flagattack || rocket){
        w.health -= 6;
        sparks.add(new ParticleSystem(f, 2, 30, 0, 30, 0, 30));
      }}
    }
    for (Soldier s : soldier) {

      float d = PVector.dist(flagpoint, s.position);
      float range = 10;
      if (d <= range) {
        s.health -= 3;
        s.inAir = true;
        sparks.add(new ParticleSystem(flagpoint, 2, 30, 0, 30, 0, 30));
      }
    }
    rotate(radians(20));
    strokeWeight(2);
    stroke(50);
    fill(0, 100, 150);
    line(0, 0, 0, -80);
    if (flagattack) {
      line(0, -80, 0, -150);
    }
    if (flagattack) {
      translate(0, -60);
    }

    beginShape();
    vertex(0, -20);
    vertex(-20, -20);
    vertex(-20, -75);
    vertex(0, -75);
    endShape();
    line(0, -77.5, -22, -77.5);
    stroke(0, 100, 150);
    line(0, -20, 0, -30);
    line(0, -40, 0, -50);
    line(0, -60, 0, -70);
    stroke(0);
    triangle(-4, -80, 2, -80, 0, -100);
  }

  void moveRight() {

    knee2 = foot2.copy();
    knee2.y -= 15;
    knee = foot.copy();
    knee.y -= 15;


    //knee1X = knee1X + width1 * Math.cos(angle1*8 * Math.PI / 180)/2;
    //knee1Y = knee1Y + width1 * Math.sin(angle1*8 * Math.PI / 180)/2;
    float ms = 0;
    if (flagattack) {
      ms = 15;
    } else {
      ms = 7.5;
    }
    float divide = 40;
    float mult = 4;

    if (mov > 20) {
      mov = 0;
    }
    if (mov2 > 20) {
      mov2 = 0;
    }
    if (mov < 5 || mov > 15) {
      foot.x += ms*cos(mult*mov * PI/divide) *moveleft;
      foot.y += ms*sin(mult*mov * PI/divide)*moveleft;
      position.x += ms*cos(mult*mov * PI/divide)*moveleft;
      foot2.x -= ms*cos(mult*mov * PI/divide)*moveleft;
    }

    if (mov2 < 5 || mov2 > 15) {
      foot2.x += ms*cos(mult*mov2 * PI/divide)*moveleft;
      foot.x -= ms*cos(mult*mov2 * PI/divide)*moveleft;
      foot2.y += ms*sin(mult*mov2 * PI/divide)*moveleft;
      position.x += ms*cos(mult*mov2 * PI/divide)*moveleft;
    }
    foot.x = constrain(foot.x, -38, 38);
    foot2.x = constrain(foot2.x, -38, 38);
    foot.y = constrain(foot.y, 0, 8);
    foot2.y = constrain(foot2.y, 0, 8);
    mov+=2;
    c+=2;
    if (c > 10) {
      mov2+=2;
    }
  }
  void moveLeft() {
    moveleft = -1;
    moveRight();
  }
  void jump() {

    position.y = constrain(position.y, 0, height*2/3);


    if (jumpcount >= 0 && plateau == true) {
      jumping = false;
      jumpcount = -20;
    }
    if (jumping && player.position.x >= initial_position) {
      jumpcount++;
      position.y += 0.8*jumpcount*jumpfactor;
      
    }
    if (jumpcount >= 19) {
      jumping = false;
      jumpcount = -20;
    } 
    if (jumping == false && plateau == false && position.y < height*2/3) {
      jumpcount = 0;
      jumping = true;
    }
  }
  void rocketjump() {

    if (rocketcount < 39) {
      if (rocket) {
        if(rocketcount == 1){fuel -= 30;}
        rocket_sound = true;
        rocketcount++;
        PVector f = position.copy();
        f.add(foot);
        PVector f2 = position.copy();
        f2.add(foot2);

        sparks.add(new ParticleSystem(f, 20, 10, -3, 3, 5, 10));
        sparks.add(new ParticleSystem(f2, 20, 10, -3, 3, 5, 10));

        jumping = true;
        jumpfactor = 4;

        walkingright = false;
        walkingleft = false;
      }
    } else {
      rocket = false;
      rocketcount = 0;
      jumpfactor = 1;
    }
  }


  void shoot(float shotposition, float fillcol, float speed, float dam) {
    reload_count++;
    if (reload_count%reload == 0) {       
      shot = new PVector(0, 0).add(position);
      shot.y -= shotposition;
      projectile.add(new Projectile(shot, target, fillcol, reload, speed, dam));
      for (Projectile p : projectile) {
        p.create();
      }
    }
  }
  void die() {
    sparks.add(new ParticleSystem(position.add(gunposition), 100, 300, -3, 3, -3, 3));
  }

  void checkObstacle() {
  }
  void Health() {
  }
  void checkI() {
  }
}