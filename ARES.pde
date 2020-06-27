import ddf.minim.*;


Player player;
PVector gun_position = new PVector();
PVector player_position;
PVector player2_position;

ArrayList<Walker> walker;
PVector walker_position;

ArrayList<Soldier> soldier;

ArrayList<ParticleSystem> sparks;
ArrayList<Projectile> projectile;
ArrayList<Plateau> plateau;
ArrayList<Collectable> item;
ArrayList<Collectable> item2;
ArrayList<PlantSystem> grass;
PVector plateau_position;
PVector item_position;
PVector item_position2;
PVector grass_position;

float count = 0;
float tracker = 0;
float initial_position;
PVector player_target;

float points = 0;
PImage img;

boolean keylock = false;
boolean [] kp = new boolean[3];

Minim shot1;
AudioPlayer s;
int shotcount = 0;
boolean shot_playing;

Minim hits;
AudioPlayer h;
AudioPlayer h2;
AudioPlayer h3;
AudioPlayer h4;
boolean metal_sound;
boolean impact_sound;
int metal_count;
int impact_count;

Minim explosion;
AudioPlayer e;
boolean explosion_sound;
int e_count;

Minim thumping;
AudioPlayer t;
boolean thumping_sound;
int t_count;

Minim creaking;
AudioPlayer c;
boolean creaking_sound;
int c_count;

Minim rocket;
AudioPlayer rock;
boolean rocket_sound;
int rock_count;

Minim flag;
AudioPlayer f;
boolean flag_sound;
int flag_count;

Minim collect;
AudioPlayer co;
boolean collect_sound;
int collect_count;

Minim spear;
AudioPlayer sp;
boolean spear_sound;
int spear_count;

Minim player_hit;
AudioPlayer ph;
boolean hit_sound;
int hit_count;

Minim player_run;
AudioPlayer pr;
boolean run_sound;
int run_count;

Minim shot2;
AudioPlayer s2;
boolean shot2_sound;
int shot2_count;

Minim music;
AudioPlayer m;
float background_displacement = 0;

void setup() {
 // size(1920, 1080);
  noCursor();
  fullScreen();
  frameRate(40);
  player_position = new PVector(750, height*2/3);
  img = loadImage("bground4.jpg");

  player = new Player(player_position, player_position);
  walker = new ArrayList<Walker>();
  soldier = new ArrayList<Soldier>();

  sparks = new ArrayList<ParticleSystem>();
  projectile = new ArrayList<Projectile>();
  plateau = new ArrayList<Plateau>();
  item = new ArrayList<Collectable>();
  item2 = new ArrayList<Collectable>();
  grass = new ArrayList<PlantSystem>();
  initial_position = player.position.x;

  shot1 = new Minim(this);
  s = shot1.loadFile("gunshot.mp3", 2048);
  hits = new Minim(this);
  h = hits.loadFile("metal1.mp3", 2048);
  h2 = hits.loadFile("metal2.mp3", 2048);
  h3 = hits.loadFile("metal2.mp3", 2048);
  h4 = hits.loadFile("impact.mp3", 2048);
  explosion = new Minim(this);
  e = explosion.loadFile("explosion.mp3", 2048);
  thumping = new Minim(this);
  t = thumping.loadFile("thumping.mp3", 2048);
  creaking = new Minim(this);
  c = creaking.loadFile("creaking.mp3", 2048);
  rocket = new Minim(this);
  rock = rocket.loadFile("rocket.mp3", 2048);
  flag = new Minim(this);
  f = flag.loadFile("flag.mp3", 2048);
  collect = new Minim(this);
  co = collect.loadFile("collect.mp3", 2048);
  spear = new Minim(this);
  sp = spear.loadFile("spear.mp3", 2048);
  player_hit = new Minim(this);
  ph = player_hit.loadFile("player_hit.mp3", 2048);
  player_run = new Minim(this);
  pr = player_run.loadFile("player_run.mp3", 2048);
  shot2 = new Minim(this);
  s2 = shot2.loadFile("shot2.mp3", 2048);

  music = new Minim(this);
  m = music.loadFile("soundflakes.mp3", 2048);
  m.loop();
}

void draw() {
  background(0);
  
  pushMatrix();
  translate(background_displacement,0);
  image(img,0,0);
  popMatrix();

  tracker = player.position.x;
  pushMatrix();
  translate(initial_position-tracker, 0);

  keys_();
  sound();
  make_plateaus();
  // instead of canyons, I chose to make plateaus that the player can stand on
  make_player();
  make_walkers(7, 20, 120, 6);
  make_soldiers(60);
  make_collectables(1, 20);
  make_particles();
  make_text();
  player.displayCross();
  make_ground();
  exit_condition();

  popMatrix();
}
void mouseReleased() {
  s.rewind();
}

void keyPressed() {
  if (key == 'd') {
    kp[0] = true;
  }
  if (key == 'a') {
    kp[1] = true;
  }
  if (key == 'w') {
    kp[2] = true;
  }
  if (keyCode == TAB) {
    if (player.fuel >= 35) {
      player.rocket = true;
    } else {
      pushMatrix();
      fill(255, 0, 0);
      textSize(20);
      text("NO FUEL", 100-initial_position+tracker, 60);
      popMatrix();
    }
  }

  if (keyCode == ENTER) {
    if (player.fuel >= 50) {
      player.flagattack = true;
    } else {
      pushMatrix();
      fill(255);
      textSize(20);
      text("NO FUEL", 100-initial_position+tracker, 60);
      popMatrix();
    }
  }
}
void keyReleased() {
  if (key == 'd') {
    kp[0] = false;
  }
  if (key == 'a') {
    kp[1] = false;
  }
  if (key == 'w') {
    kp[2] = false;
  }
}
void keys_() {
  if (keylock == false) {
    if (kp[0] && player.flagattack == false) {
      player.moveleft = 1;
      player.moveRight();
      player.walkingright = true;
      run_sound = true;
      background_displacement--;
    } else if (kp[1] && player.position.x > initial_position) {
      player.moveLeft();
      player.walkingleft = true;
      run_sound = true;
      background_displacement++;
    } else {
      run_sound = false;
      pr.pause();
    }
    if (kp[2]) {
      player.jumping = true;
    }
  }
}

void make_plateaus() {
  plateau_position = new PVector(player_position.x+random(1000, 6000), random(450, 600));
  if (plateau.size() < 16) {
    plateau.add(new Plateau(plateau_position, random(100, 300), random(8, 15)));
  }
  int count = 0;
  for (Plateau p : plateau) {
    float d = PVector.dist(player.position, p.position);
    if (d < width) {
      p.display();
      p.checkImpact(player);
      if (p.onPlatform) {
        count++;
      }
    }
  }
  if (count > 0) {
    player.plateau = true;
  } else {
    player.plateau = false;
  }

  for (int i = plateau.size()-1; i >= 0; i--) {
    Plateau p = plateau.get(i);
    float d = PVector.dist(player.position, p.position);
    if (d > width*2) {
      plateau.remove(i);
    }
  }
}

void make_scenery() {

  grass_position = new PVector(player_position.x+random(400, 5000), height*2/3);
  if (grass.size() < 4) {
    //grass.add(new PlantSystem(grass_position));
  }

  for (PlantSystem p : grass) {
    float d = PVector.dist(player.position, p.origin);
    if (d < width) {
      p.display();
      p.update();
    }
  }
}

void make_walkers(float amount, float minSize, float maxSize, float projectile_damage) {
  walker_position = new PVector(player.position.x + random(1000, 6000), height*2/3);
  count++;
  if (walker.size() <= amount) {
    walker.add(new Walker(walker_position, walker_position, random(minSize, maxSize), projectile_damage));
  }
  for (Walker w : walker) {
    float d = PVector.dist(player.position, w.position);
    if (d < width) {
      w.display();
    }
  }
  for (int i = walker.size()-1; i >= 0; i--) {
    Walker w = walker.get(i);
    if (w.health < 1) {
      w.die();
      if (w.diecount > 400) {
        walker.remove(i);
      }
    }
    float d = PVector.dist(player.position, w.position);
    if (d > width*1.5) {
      walker.remove(i);
    }
  }
}
void make_soldiers(float amount) {
  PVector soldier_position = new PVector(player_position.x+random(1500, 5000), height*2/3);
  if (soldier.size() <= amount) {
    soldier.add(new Soldier(soldier_position, soldier_position));
  }
  for (Soldier s : soldier) {
    float d = PVector.dist(player.position, s.position);
    if (d < width) {
      s.display();
    }
  }
  for (int i = soldier.size()-1; i >= 0; i--) {
    Soldier s = soldier.get(i);
    float d = PVector.dist(player.position, s.position);
    if (s.diecount > 60 || d > width*2) {
      soldier.remove(i);
    }
  }
}
void make_collectables(float amount_health, float amount_fuel) {
  item_position = new PVector(player_position.x+random(2500, 5000), random(600, 610));
  item_position2 = new PVector(player_position.x+random(1000, 5000), 600);


  if (item.size() <= amount_health) {
    item.add(new Collectable(item_position, 20, "health"));
  }
  if (item2.size() <= amount_fuel+amount_health) {
    item2.add(new Collectable(item_position2, 4, "fuel"));
  }
  for (Collectable i : item) {
    float d = PVector.dist(player.position, i.position);
    if (d < width) {
      i.display();
      i.functionality();
    }
  }
  for (int i = item.size()-1; i >= 0; i--) {
    Collectable t = item.get(i);
    float d = PVector.dist(player.position, t.position);
    if (t.collected || d > width*2) {
      item.remove(i);
    }
  }
  for (Collectable i : item2) {
    float d = PVector.dist(player.position, i.position);
    if (d < width) {
      i.display();
      i.functionality();
    }
  }
  for (int i = item2.size()-1; i >= 0; i--) {
    Collectable t = item2.get(i);
    float d = PVector.dist(player.position, t.position);
    if (t.collected || d > width*2) {
      item2.remove(i);
    }
  }
}
void make_particles() {
  for (ParticleSystem pS : sparks) {
    float d = PVector.dist(player.position, pS.origin);
    if (d < width) {
      pS.display();
      pS.update();
    }
  }
  for (int i = sparks.size()-1; i >= 0; i--) {
    ParticleSystem ps = sparks.get(i);
    if (ps.lifespan < 0) {
      sparks.remove(i);
    }
  }
}
void make_ground() {
  pushMatrix();
  strokeWeight(1);
  stroke(0);
  fill(255);
  rectMode(CORNER);
  rect(-initial_position+tracker, height*2/3, width, 10);
  fill(0);
  rect(-initial_position+tracker, height*2/3+10, width, 50);
  stroke(255);


  popMatrix();
}
void make_text() {
  strokeWeight(1);
  stroke(0);
  fill(0);
  rectMode(CORNER);
  rect(-initial_position+tracker, 0, 250, 150);
  
  textSize(15);
  stroke(255);
  fill(255);
  text(int(player.health), 10-initial_position+tracker, 30);
  text("HEALTH", 50-initial_position+tracker, 30);
  text(int(player.fuel), 10-initial_position+tracker, 60);
  text("FUEL", 50-initial_position+tracker, 60);
  textSize(30);
  text(int(points), 10-initial_position+tracker, 120);
  text("POINTS", 110-initial_position+tracker, 120);
  textSize(20);
  text("by Lars Brestrich", 1700-initial_position+tracker, 1050);
}
void make_player() {
  gun_position = new PVector(mouseX, mouseY);

  player.displayflag();
  player.jump();
  player.displaylaser();
  
  player.displayRight();
  player.displayparts();
  player.forceAccumulation();
  player.rocketjump();


  if (mousePressed) {
    if (keylock == false) {
      player.shoot(55, 0, 50, 2);
      shot_playing = true;
      
      if (shotcount%10 == 0) {
        s.rewind();
        shot_playing = false;
      } else {
        shot_playing = true;
      }
      shotcount++;
      
    }
  }
  player.fuel -= 0.02;
  points -= 0.05;

  if (shot_playing) {
    s.play();
  }
}
void exit_condition() {
  if (player.health < 1 || player.fuel <= 0) {
    fill(255);
    textSize(100);
    text("SCORE", (width/3)-initial_position+tracker, height/2-100);
    textSize(200);
    text(int(points), (width/3)-initial_position+tracker, height/2+200);
    keylock = true;
    points += 0.05;
  }
}

void sound() {
  if (metal_sound) {
    int r = int(random(1, 3));
    if (r == 1) {
      h.play();
      if (metal_count % 8 == 0) {
        h.rewind();
      }
    }
    if (r == 2) {
      h2.play();
      if (metal_count % 8 == 0) {
        h2.rewind();
      }
    }
    if (r == 3) {
      h3.play();
      if (metal_count % 8 == 0) {
        h3.rewind();
      }
    }
    metal_count++;
    if (metal_count % 8 == 0) {
      metal_sound = false;
    }
  }
  if (impact_sound) {
    h4.play();
    impact_count++;
    if (impact_count % 4 == 0) {
      h4.rewind();
      impact_sound = false;
    }
  }
  if (explosion_sound) {
    e.play();
    e_count++;
    if (e_count % 200 == 0) {
      explosion_sound = false;
      e.pause();
      e.rewind();
    }
  }
  if (thumping_sound) {
    t.play();
    t_count++;
    if (t_count % 200 == 0) {
      thumping_sound = false;
      t.pause();
      t.rewind();
    }
  }
  if (creaking_sound) {
    c.play();
    c_count++;
    if (c_count % 200 == 0) {
      creaking_sound = false;
      c.pause();
      c.rewind();
    }
  }
  if (flag_sound) {
    f.play();
    flag_count++;
    if (flag_count % 62 == 0) {
      flag_sound = false;
      f.pause();
      f.rewind();
    }
  }
  if (rocket_sound) {
    rock.play();
    rock_count++;
    if (rock_count % 40 == 0) {
      rocket_sound = false;
      rock.pause();
      rock.rewind();
    }
  }
  if (collect_sound) {
    co.play();
    collect_count++;
    if (collect_count % 8 == 0) {
      collect_sound = false;
      co.pause();
      co.rewind();
    }
  }
  if (spear_sound) {
    sp.play();
    spear_count++;
    if (spear_count % 10 == 0) {
      spear_sound = false;
      sp.pause();
      sp.rewind();
    }
  }
  if (hit_sound) {
    ph.play();
    hit_count++;
    if (hit_count % 10 == 0) {
      hit_sound = false;
      ph.pause();
      ph.rewind();
    }
  }
  if (run_sound) {
    pr.play();
    run_count++;
    if (run_count % 8 == 0) {
      run_sound = false;
      pr.pause();
      pr.rewind();
    }
  }
  if (shot2_sound) {
    s2.play();
    shot2_count++;
    if (shot2_count % 30 == 0) {
      shot2_sound = false;
      s2.pause();
      s2.rewind();
    }
  }
}