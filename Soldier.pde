class Soldier extends Player {

  PVector position;
  PVector head_position;

  PVector foot;
  PVector foot2;
  PVector hip;

  PVector spear_end;
  float health = 4;
  
  float diecount = 0;
  float jumpcount = 0;
  boolean inAir = false;
  
  PVector velocity;
  PVector acceleration;
  float randomizer;

  Soldier(PVector position_, PVector position_empty) {
    super(position_, position_empty);
    position = position_;
    head_position = new PVector(0, -40);
    foot = new PVector();
    foot2 = new PVector();
    hip = new PVector(0, -20);
    spear_end = new PVector(-51, -80);
    velocity = new PVector();
    acceleration = new PVector();
    randomizer = random(-3,3);
  }
  void display() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    
    pushMatrix();
    strokeWeight(3);
    stroke(0);
    fill(255);
    translate(position.x, position.y);
    if(diecount < 40 && inAir){
      rotate(radians(jumpcount*randomizer));
    } else if(diecount < 40 && inAir == false){
      rotate(radians(diecount*2));
    }
    triangle(head_position.x-2, head_position.y+1, head_position.x+7, head_position.y+2, head_position.x, head_position.y-4);
    ellipse(head_position.x, head_position.y+8, 8, 8);
    triangle(head_position.x-4, head_position.y+8, head_position.x+4, head_position.y+8, hip.x, hip.y);
    legs();
    airjump();
    if(health > 0){
    move();
    }
    if(diecount < 40){
    spear();
    }
    popMatrix();
    if(health < 1){
      die();
    }
    if(diecount == 1){
      points += 3;
    }
  }
  void legs() {
    pushMatrix();
    stroke(0);
    strokeWeight(2);
    fill(255);
    line(hip.x, hip.y, foot.x, foot.y);
    line(hip.x, hip.y, foot2.x, foot2.y);
    triangle(foot.x+1, foot.y, foot.x, foot.y-1, foot.x-2, foot.y);
    triangle(foot2.x+1, foot2.y, foot2.x, foot2.y-1, foot2.x-2, foot2.y);
    popMatrix();
  }
  void move() {
    float ms = -1;
    float divide = 40;
    float mult = 4;

    if (mov > 20) {
      mov = 0;
    }
    if (mov2 > 20) {
      mov2 = 0;
    }
    if (mov < 5 || mov > 15) {
      foot.x += ms*cos(mult*mov * PI/divide);
      foot.y += ms*sin(mult*mov * PI/divide);
      position.x += ms*cos(mult*mov * PI/divide);
      foot2.x -= ms*cos(mult*mov * PI/divide);
    }

    if (mov2 < 5 || mov2 > 15) {
      foot2.x += ms*cos(mult*mov2 * PI/divide);
      foot.x -= ms*cos(mult*mov2 * PI/divide);
      foot2.y += ms*sin(mult*mov2 * PI/divide);
      position.x += ms*cos(mult*mov2 * PI/divide);
    }
    foot.x = constrain(foot.x, -38, 38);
    foot2.x = constrain(foot2.x, -38, 38);
    foot.y = constrain(foot.y, 0, 8);
    foot2.y = constrain(foot2.y, 0, 8);
    mov+=1.5;
    c+=1.5;
    if (c > 10) {
      mov2+=1.5;
    }
  }
  void spear() {

    pushMatrix();
    rotate(radians(-40));
    translate(12, 10);
    stroke(150);
    line(0, 0, 0, -95);
    popMatrix();
    pushMatrix();
    stroke(255);
    line(0, -40, -5, -25);
    triangle(spear_end.x, spear_end.y, -40, -65, -40, -57);
    popMatrix();
    PVector spearpoint = new PVector();
    spearpoint.add(position).add(spear_end);

    float d = dist(player.position.x+player.gunposition.x, player.position.y+player.gunposition.y, spearpoint.x, spearpoint.y);
    float range = 30;
    if (d <= range) {
      player.health -= 0.3;
      if(player.flagattack){
        player.health += 0.2;
      }
      spear_sound = true;
      sparks.add(new ParticleSystem(spearpoint, 2, 10, -2, 2, -2, 3));
    }
  }
  void die(){
    diecount++;
    
  }
  void airjump(){
    if(inAir){
    diecount++;
    jumpcount++;
    position.y += -15 + jumpcount/2 + (random(-10,10));
    }
  }
}