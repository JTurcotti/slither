PlayerSnake snake; //the player's snake
final PVector ORIGIN = new PVector(0, 0); //origin
PVector screenCenter; //stores the center of the screen
PVector translation; //current board translation
final int GAME_RADIUS = 8192; //gameboard of sidelength gameradius * 2 (default 8192)
Rectangle screen;
Rectangle gameArea;
final float FOOD_DENSITY = .00005; //food per pixel
final Deque<Drawable> thingsToDraw = new ArrayDeque<Drawable>(); //all things to draw
final List<Snake> thingsToDo = new LinkedList<Snake>(); //all things to do/move
final FoodTree foodTree = new FoodTree();
int foodEaten = 0; //food eaten so far
int time = 0; //number of times draw executed
final long maxMinTimeMillis = 20; //maximum minimum time between draws
long minTimeMillis = 0; //minimum time between draws
long lastTimeMillis = System.currentTimeMillis(); //time of last draw

final int NUM_SNAKES = 20;

boolean bounded = true; //for debugging, bound the snake yes or no?
boolean alive = true; //is the snake moving?
boolean mouseMode = false; //debuggin modes
boolean clearTree = false;

int randomColor(int tone) {
    return color(int(random(tone)), int(random(tone)), int(random(tone)));
}

PVector mouse() {
    return new PVector(mouseX, mouseY).sub(translation);
}

PVector randomPos() {
    	return new PVector(int(random(2 * (GAME_RADIUS - 50))) - (GAME_RADIUS - 50),
			   int(random(2 * (GAME_RADIUS - 50))) - (GAME_RADIUS - 50));
}

int randomColor() {
    return randomColor(256);
}

boolean onScreen(PVector actual) {
    PVector virtual = PVector.add(actual, translation);
    return screen.contains(virtual);
}

void doAllThings() {
    if (!alive) return;
    for (Snake s: thingsToDo) s.step();
}

void drawAllThings() {
    translation = PVector.sub(screenCenter, snake.head.pos);
    translate(translation.x, translation.y);

    /*
    LinkedList<Circle> l = new LinkedList<Circle>();
    Circle c = new Circle(foodTree.nearestTo(mouse(), l).pos, 30, #0000FF, #000000);
    l.addFirst(c);
    for (Circle d: l) thingsToDraw.addLast(d);
    //*/
    
    for (Drawable thing: thingsToDraw)
	if (onScreen(thing.pos()))
	    thing.draw();

    if (clearTree) {
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
    }
}

void setup() {
    size(2048, 2048);
    screenCenter = new PVector(width/2, height/2);
    screen = new Rectangle(0, width, 0, height);
    gameArea = new Rectangle(-1 * GAME_RADIUS, GAME_RADIUS,
			     -1 * GAME_RADIUS, GAME_RADIUS);
    background(#FFFFFF);
    ellipseMode(RADIUS);

    Collection<Boundary> bounds = genBounds();
    if (bounded) thingsToDraw.addAll(bounds);
    
    snake = new PlayerSnake();
    thingsToDraw.add(snake);
    thingsToDo.add(snake);

    for (int i=0; i<NUM_SNAKES; i++) {
	Snake s = new ComputerSnake();
	thingsToDraw.add(s);
	thingsToDo.add(s);
    }
    
    Collection<Food> foodSet = scatterFood(int(GAME_RADIUS * GAME_RADIUS * FOOD_DENSITY));
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
    
    doAllThings();
    if (clearTree)
	println(snake.pos() + " " + foodTree.root.value);

    if (mousePressed) {
	snake.speedUp();
    }
    
    drawAllThings();
}

void keyReleased() {
    if (key == ' ') 
	alive = !alive;
}



