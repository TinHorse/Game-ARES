class Walker extends Player {

  PVector position;
  PVector footpos;
  float scalar;

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

  float moveleft = 1;


  float count = 0;
  float diecount = 0;

  float health = 1;

  PVector head;
  PVector eyes;
  float r = random(10);
  float projectile_damage;
  int shot_count_;
 

  Walker(PVector position_, PVector footpos_, float scalar_, float projectile_damage_) {
    super(position_, footpos_);
    position = position_;
    footpos = footpos_;
    scalar = scalar_;
    health = scalar;
    projectile_damage = projectile_damage_;

    hip = new PVector(0, -50-scalar*3);
    foot = new PVector(0, 0);
    foot2 = new PVector(0, 0);
    knee = new PVector(0, -30);
    knee2 = new PVector(0, -30);

    head = new PVector(position.x+hip.x, position.y+hip.y-scalar*1.3);
    eyes = new PVector(-scalar/3, 0).add(head);

    gunposition = new PVector(-10, scalar*4);
    
    reload = 50;
  }

  void display() {
    target = new PVector(player.position.x, player.position.y-80);
    
    count++;
    head();
    displayparts();
    if (count%2 == 0) {
      moveLeft();
    }
  }
  void head() {
    if (diecount <= 0) {
      head = new PVector(position.x+hip.x, position.y+hip.y-scalar*1.3);
      eyes = new PVector(-scalar/3, 0).add(head);
      gun = new PVector();
      gun.add(target).sub(position).sub(gunposition).normalize().mult(40);
    }


    pushMatrix();
    translate(position.x-gunposition.x, position.y-gunposition.y);
    stroke(20);
    strokeWeight(5);
    fill(0);
    float f = gun.heading()+HALF_PI;
    rotate(f);
    rectMode(CENTER);

    triangle(-20, -10, -10, 5, 10, 0);
    popMatrix();
    pushMatrix();
    fill(0);
    stroke(0);
    strokeWeight(4);

    ellipse(head.x, head.y, scalar*1.5, scalar*1.5);

    strokeWeight(8);
    fill(255);
    ellipse(eyes.x, eyes.y, scalar, scalar/2);
    strokeWeight(5);
    popMatrix();
    pushMatrix();
    stroke(255);
    line(head.x, head.y, -gunposition.x+position.x, -gunposition.y+position.y);
    popMatrix();
  }
  void legs() {
    pushMatrix();
    strokeWeight(2);
    stroke(30);

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
    strokeWeight(3);
    fill(0);

    rectMode(CENTER);

    rect(foot2.x, foot2.y, 10, 40);
    rect(foot.x, foot.y, 10, 40);
    fill(255);
    ellipse(foot2.x, foot2.y, 10, 10);
    ellipse(foot.x, foot.y, 10, 10);

    strokeWeight(5);
    line(knee.x, knee.y, foot.x, foot.y);
    line(knee2.x, knee2.y, foot2.x, foot2.y);

    popMatrix();
    popMatrix();
  }
  void moveRight() {

    knee2 = foot2.copy();
    knee2.y -= 3*scalar;
    knee = foot.copy();
    knee.y -= 3*scalar;



    //knee1X = knee1X + width1 * Math.cos(angle1*8 * Math.PI / 180)/2;
    //knee1Y = knee1Y + width1 * Math.sin(angle1*8 * Math.PI / 180)/2;
    if (mov > 20) {
      mov = 0;
    }
    if (mov2 > 20) {
      mov2 = 0;
    }
    if (mov < 5 || mov > 15) {
      foot.x += 3.75*cos(4*mov * PI/40) *moveleft;
      foot.y += 3*sin(4*mov * PI/40)*moveleft;
      position.x += 3.75*cos(4*mov * PI/40)*moveleft;
      foot2.x -= 3.75*cos(4*mov * PI/40)*moveleft;
    }
    if (mov2 < 5 || mov2 > 15) {
      foot2.x += 3.75*cos(4*mov2 * PI/40)*moveleft;
      foot.x -= 3.75*cos(4*mov2 * PI/40)*moveleft;
      foot2.y += 3*sin(4*mov2 * PI/40)*moveleft;
      position.x += 3.75*cos(4*mov2 * PI/40)*moveleft;
    }
    foot.x = constrain(foot.x, -38, 38);
    foot2.x = constrain(foot2.x, -38, 38);
    foot.y = constrain(foot.y, 0, 8);
    foot2.y = constrain(foot2.y, 0, 8);
    mov++;
    c++;
    if (c > 10) {
      mov2++;
    }
  }
  void moveLeft() {

    if (diecount <= 0) {
      float d = position.x - player.position.x;
      if (d < 300 && d > -200 && scalar > 50) {
        moveleft = -0.5;
        moveRight();
      } else if (d < -200 && scalar > 50) {
        moveleft = 1;
        moveRight();
      }
      else {
        moveleft = -1;
        moveRight();
      }
      if (diecount <= 0 && d < 800) {
      shoot(scalar*4, 10, 7,projectile_damage);
    }
    if(d < 800){
      shot_count_++;
      if(shot_count_ % 40 == 0){
        shot2_sound = true;
      }
    }
    }
  }
  void arms() {
  }
  void die() {
    diecount++;
    if(diecount == 1){
      points += scalar*3;
      explosion_sound = true;
    }
    if (diecount < 100) {
      sparks.add(new ParticleSystem(head, 30, 40,-5,0,-4,10));
    }



    if (head.y + scalar*1.5/2 >= height*2/3) {
      thumping_sound = true;
      head.y += 0;
      eyes.y += 0;
      if (diecount < 100) {
        if (r > 5) {
          head.x += 0.1;
          eyes.x += 0.2;
        } else {
          head.x -= 0.1;
          eyes.x -= 0.2;
          eyes.y += 0.2;
        }
      }
    } else {
      head.y+=6;
      eyes.y+=5;
      if (diecount > 18) {
        eyes.y++;
      }
    }
    if (diecount > 200) {
      creaking_sound = true;
      if (position.y+hip.y < height*2/3) {
        hip.y+=4;
      } else {
        hip.y += 0;
      }
    }
    if (diecount > 300) {
      if (position.y+knee.y < height*2/3) {
        knee.y += 2;
        knee2.y += 3;
        gunposition.y -= 3;
      } else {
        knee.y += 0;
        knee2.y += 0;
        gunposition.y += 0;
      }
    }
  }
}