Snake s; // the player's snake
PVector screenCenter; //stores the center of the screen
PVector translation; //current board translation
int gameRadius = 4096; //gameboard of sidelength gameradius * 2
Rectangle screen;
Rectangle gameArea;
float foodDensity = .00005; //food per pixel
Queue<Drawable> thingsToDraw = new ArrayDeque<Drawable>(); //all things to draw
FoodTree foodTree = new FoodTree();;
int foodEaten = 0; //food eaten so far
int time = 0;

boolean alive = true; //is the snake moving?

int randomColor() {
    return color(int(random(256)), int(random(256)), int(random(256)));
}

boolean onScreen(PVector actual) {
    PVector virtual = PVector.add(actual, translation);
    return screen.contains(virtual);
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
    thingsToDraw.addAll(bounds);
    
    s = new Snake();
    thingsToDraw.add(s);

    Collection<Food> foodSet = scatterFood(int(gameRadius * gameRadius * foodDensity));
    thingsToDraw.addAll(foodSet);

    foodTree.addAll(foodSet);

    println("NW " + gameArea.vertex(Direction.NW));
    println("NE " + gameArea.vertex(Direction.NE));
    println("SW " + gameArea.vertex(Direction.SW));
    println("SE " + gameArea.vertex(Direction.SE));
	
	
}

void draw() {
    time++;
    if (!alive) return;
    //    if (time%10==0) return;
    
    background(#FFFFFF);
    
    PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
    s.step(delta);
    
    translation = PVector.sub(screenCenter, s.head.pos);
    translate(translation.x, translation.y);

    for (Drawable thing: thingsToDraw)
	if (onScreen(thing.pos()))
	    thing.draw();
    
}

