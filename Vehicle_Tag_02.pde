import java.util.Iterator;

ArrayList<Thief> thiefs = new ArrayList<Thief>();
ArrayList<Police> polices = new ArrayList<Police>();

float worldRecord = 80;
color BGC = #01000B;

float maxThiefsSize = 500;
float maxPolicesSize = 10;

void setup(){
  size(1300, 800);
  background(BGC);
  for(int i = 0; i < 100; i++){
    thiefs.add(new Thief(random(width), random(height)));
  }
  for(int i = 0; i < 3; i++){
    polices.add(new Police(random(width), random(height)));
  }
}

void draw(){
  background(BGC);
  if(thiefs.size() < maxThiefsSize && mousePressed){
    thiefs.add(new Thief(mouseX, mouseY));
  }

  Iterator<Thief> it = thiefs.iterator();
  while(it.hasNext()){
    Thief thief = it.next();
    PVector target = thief.randomWalk();
    for(Police police : polices){
      target.add(thief.predictTarget(police));
    }
    thief.flock(thiefs);
    thief.seek(target);
    thief.update();
    thief.keepAwayFromWall(random(30, 35));
    thief.bounceOffwall();
    thief.display();

    if(thief.isDead){
      it.remove();
    }
  }

  for(Police police : polices){
    PVector target = police.randomWalk();
    for(Thief thief : thiefs){
      float distance = PVector.sub(thief.location, police.location).mag();
      if(distance < worldRecord){
        worldRecord = distance;
        target = thief.location;
      }
    }
    police.separate(polices);
    police.seek(target);
    police.update();
    police.keepAwayFromWall(20);
    police.bounceOffwall();
    police.display();

    worldRecord = police.visibility;
  }
  
}

void keyPressed(){
  if(polices.size() < maxPolicesSize && (keyPressed == true) && (key == 'p')){
    polices.add(new Police(random(width), random(height)));
  }
}
