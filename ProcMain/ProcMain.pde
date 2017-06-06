PlayerSnake mainSnake; //the player's snake
final PVector ORIGIN = new PVector(0, 0); //origin
PVector screenCenter; //stores the center of the screen
PVector translation; //current board translation
final int GAME_RADIUS = 8192; //gameboard of sidelength gameradius * 2 (default 8192)
Rectangle screen;
Rectangle gameArea;
final float FOOD_DENSITY = .00005; //food per pixel
final float SNAKE_DENSITY = .000001; //snakes per pizel
final Deque<Drawable> thingsToDraw = new ArrayDeque<Drawable>(); //all things to draw
final List<Snake> snakeList = new LinkedList<Snake>(); //all things to do/move
Snake deathRow = null; //see doAllThings()
final FoodTree foodTree = new FoodTree();
int foodEaten = 0; //food eaten so far
int time = 0; //number of times draw executed
final long maxMinTimeMillis = 20; //maximum minimum time between draws
long minTimeMillis = 0; //minimum time between draws
long lastTimeMillis = System.currentTimeMillis(); //time of last draw

boolean bounded = true; //for debugging, bound the snake yes or no?
boolean alive = true; //is the snake moving?
boolean mouseMode = false; //debuggin modes
boolean clearTree = false;



void doAllThings() {
    if (!alive) return;
    for (Snake s: snakeList) s.step();
    if (deathRow!=null)
	deathRow.die();
    deathRow = null;
}

void drawAllThings() {
    translation = PVector.sub(screenCenter, mainSnake.head.pos);
    translate(translation.x, translation.y);

    /*
    LinkedList<Circle> l = new LinkedList<Circle>();
    Circle c = new Circle(foodTree.nearestTo(mouse(), l).pos, 30, #0000FF, #000000);
    l.addFirst(c);
    for (Circle d: l) thingsToDraw.addLast(d);
    //*/
    
    for (Drawable thing: thingsToDraw)
	if (thing.render())
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
    
    mainSnake = new PlayerSnake();
    thingsToDraw.add(mainSnake);
    snakeList.add(mainSnake);

    for (int i=0; i<GAME_RADIUS * GAME_RADIUS * SNAKE_DENSITY; i++) {
	Snake s = new ComputerSnake();
	thingsToDraw.add(s);
	snakeList.add(s);
    }
    
    Collection<Food> foodSet = scatterFood(int(GAME_RADIUS * GAME_RADIUS * FOOD_DENSITY));
    thingsToDraw.addAll(foodSet);

    foodTree.addAll(foodSet);
}

void draw() {
    println(foodEaten);
    /*
    if (System.currentTimeMillis() - lastTimeMillis < minTimeMillis)
	return;
    lastTimeMillis = System.currentTimeMillis();
    minTimeMillis = maxMinTimeMillis; //reset min to maxmin
    //*/
	    
    time++;
    background(#FFFFFF);
    
    doAllThings();

    if (mousePressed) {
	mainSnake.speedUp();
    }
    
    drawAllThings();
}

void keyReleased() {
    if (key == ' ') 
	alive = !alive;
}



