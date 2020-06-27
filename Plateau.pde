class Plateau {

  PVector position;
  PVector w;
  PVector h;

  float count = 0;
  boolean onPlatform = false;

  Plateau(PVector position_, float w_, float h_) {
    position = position_;
    w = new PVector(w_, 0);
    h = new PVector(0, h_);
  }
  void display() {
    pushMatrix();
    fill(200,150,0);
    stroke(0);
    strokeWeight(5);
    rectMode(CENTER);
    rect(position.x, position.y, w.x, h.y);
    popMatrix();
  }
  void checkImpact(Player player) {
    float player_grounddist = (height*2/3) - player.position.y;
    float grounddist = 0;
    float range = 0;
    float range2 = 0;

    float c = dist(position.x, position.y, player.position.x, player.position.y);
    grounddist = (height*2/3) - position.y;
    range = w.x/2;
    range2 = h.x/2;
    if (player_grounddist <= grounddist+7 && player_grounddist >= grounddist+range2 && c < range) {
      onPlatform = true;
    } else {
      onPlatform = false;
    }
  }
}