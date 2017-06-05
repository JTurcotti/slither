Snake s; // the player's snake
PVector screenCenter; //stores the center of the screen
PVector translation; //current board translation
int gameRadius = 1200; //gameboard of sidelength gameradius * 2
Rectangle screen;
Rectangle gameArea;
float foodDensity = .00005; //food per pixel
Deque<Drawable> thingsToDraw = new ArrayDeque<Drawable>(); //all things to draw
FoodTree foodTree = new FoodTree();
int foodEaten = 0; //food eaten so far
int time = 0;

boolean bounded = false; //for debugging, bound the snake yes or no?
boolean alive = true; //is the snake moving?
boolean mouseMode = false;

int randomColor() {
    return color(int(random(256)), int(random(256)), int(random(256)));
}

boolean onScreen(PVector actual) {
    PVector virtual = PVector.add(actual, translation);
    return screen.contains(virtual);
}

void drawAllThings() {
    translation = PVector.sub(screenCenter, s.head.pos);
    translate(translation.x, translation.y);

    Rectangle r = s.head.bounds();
    thingsToDraw.addFirst(r);
    
    for (Drawable thing: thingsToDraw)
	if (onScreen(thing.pos()))
	    thing.draw();
    thingsToDraw.remove(r);

    /*
    for (Node n: foodTree) {
	if (n.next.get(Direction.NW) != null) {
	    stroke(255, 0, 0);
	    line(n.value.pos.x, n.value.pos.y,
		 n.next.get(Direction.NW).value.pos.x,
		 n.next.get(Direction.NW).value.pos.y);
	}
	if (n.next.get(Direction.NE) != null) {
	    stroke(0, 255, 0);
	    line(n.value.pos.x, n.value.pos.y,
		 n.next.get(Direction.NE).value.pos.x,
		 n.next.get(Direction.NE).value.pos.y);
	}
	if (n.next.get(Direction.SE) != null) {
	    stroke(0, 0, 255);
	    line(n.value.pos.x, n.value.pos.y,
		 n.next.get(Direction.SE).value.pos.x,
		 n.next.get(Direction.SE).value.pos.y);
	}
	if (n.next.get(Direction.SW) != null) {
	    stroke(255, 0, 255);
	    line(n.value.pos.x, n.value.pos.y,
		 n.next.get(Direction.SW).value.pos.x,
		 n.next.get(Direction.SW).value.pos.y);
	}
    }

    //*/
}

void setup() {
    size(2048, 2048);
    screenCenter = new PVector(width/2, height/2);
    screen = new Rectangle(0, width, 0, height);
    gameArea = new Rectangle(-1 * gameRadius, gameRadius,
			     -1 * gameRadius, gameRadius);
    background(#FFFFFF);
    ellipseMode(RADIUS);

    Collection<Boundary> bounds = genBounds();
    if (bounded) thingsToDraw.addAll(bounds);
    
    s = new Snake();
    thingsToDraw.add(s);

    Collection<Food> foodSet = scatterFood(int(gameRadius * gameRadius * foodDensity));
    thingsToDraw.addAll(foodSet);

    foodTree.addAll(foodSet);
}

void draw() {
    time++;
    background(#FFFFFF);
    if (alive) {
	PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
	s.step(delta);
    }

    Rectangle r = null;
    if (mouseMode) {
	r = new Rectangle(mouseX-50-int(translation.x),
			  mouseX+50-int(translation.x),
			  mouseY-50-int(translation.y),
			  mouseY+50-int(translation.y));
	thingsToDraw.addFirst(r);
	for (Food f: foodTree.within(r)) {
	    println(f.pos + " found");
	    f.fillColor = color(0, 0, 255);
	}
    }

    
    drawAllThings();
    if (mouseMode) {
	thingsToDraw.remove(r);
	for (Node n: foodTree)
	    n.value.fillColor = color(140);
    }
}

void keyReleased() {
    if (key == ' ') 
	alive = !alive;
}

