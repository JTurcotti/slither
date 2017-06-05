Snake snake; // the player's snake
PVector screenCenter; //stores the center of the screen
PVector translation; //current board translation
final int gameRadius = 4096; //gameboard of sidelength gameradius * 2
Rectangle screen;
Rectangle gameArea;
final float foodDensity = .00005; //food per pixel
final Deque<Drawable> thingsToDraw = new ArrayDeque<Drawable>(); //all things to draw
final FoodTree foodTree = new FoodTree();
int foodEaten = 0; //food eaten so far
int time = 0; //number of times draw executed
final long maxMinTimeMillis = 20; //maximum minimum time between draws
long minTimeMillis = 0; //minimum time between draws
long lastTimeMillis = System.currentTimeMillis(); //time of last draw

boolean bounded = true; //for debugging, bound the snake yes or no?
boolean alive = true; //is the snake moving?
boolean mouseMode = false;

int randomColor(int tone) {
    return color(int(random(tone)), int(random(tone)), int(random(tone)));
}

int randomColor() {
    return randomColor(256);
}

boolean onScreen(PVector actual) {
    PVector virtual = PVector.add(actual, translation);
    return screen.contains(virtual);
}

void drawAllThings() {
    translation = PVector.sub(screenCenter, snake.head.pos);
    translate(translation.x, translation.y);

    for (Drawable thing: thingsToDraw)
	if (onScreen(thing.pos()))
	    thing.draw();
    
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
    
    snake = new Snake();
    thingsToDraw.add(snake);

    Collection<Food> foodSet = scatterFood(int(gameRadius * gameRadius * foodDensity));
    thingsToDraw.addAll(foodSet);

    foodTree.addAll(foodSet);
}

void draw() {
    /*
    if (System.currentTimeMillis() - lastTimeMillis < minTimeMillis)
	return;
    lastTimeMillis = System.currentTimeMillis();
    minTimeMillis = maxMinTimeMillis; //reset min to maxmin
    //*/
	    
    time++;
    background(#FFFFFF);
    if (alive) {
	PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
	snake.step(delta);
    }

    if (mousePressed) {
	snake.speedUp();
    }
    drawAllThings();
}

void keyReleased() {
    if (key == ' ') 
	alive = !alive;
}

