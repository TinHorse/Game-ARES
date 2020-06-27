class Collectable {

  PVector position;
  float size;
  boolean collected = false;
  String type;
  boolean health = false;
  boolean fuel = false;
  boolean collectsound = false;

  Collectable(PVector position_, float size_, String type_) {
    position = position_;
    size = size_;
    type = type_;
  }
  void display() {
    if(collectsound){
      collect_sound = true;
    }
    if (health) {
      pushMatrix();
      fill(0);
      stroke(255);
      strokeWeight(3);
      rect(position.x, position.y, size, size);
      fill(100,0,0);
      ellipse(position.x, position.y, size/1.2, size/1.2);
      popMatrix();
    } else if (fuel) {
      fill(200,200,0);
      stroke(200,200,0);
      strokeWeight(3);
      rect(position.x, position.y, size, size);
      beginShape();
      vertex(position.x-size/2,position.y-size/2);
      vertex(position.x-size/3,position.y-size);
      vertex(position.x,position.y-size/2);
      vertex(position.x+size/2,position.y+size/2);
      vertex(position.x+size/3,position.y+size);
      vertex(position.x,position.y+size/2);
      endShape();
      
    }
  }
  void functionality() {
    
    if (type == "health") {
      health = true;
    } else if (type == "fuel") {
      fuel = true;
    }
    float z = player.position.y - 50;
    float d = dist(position.x, position.y, player.position.x, z);
    if(d < 38){
      collect_sound = true;
    }
    if (d < 40) {
      
      if (health) {
        player.health += int(size/2);
      } else if (fuel) {
        player.fuel += int(size);
      }
      collected = true;
    }
  }
}