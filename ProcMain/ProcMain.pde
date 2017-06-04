Snake s; // the player's snake
PVector screenCenter; //stores the center of the screen
int gameRadius = 4096; //gameboard of sidelength gameradius * 2
Rectangle screen;
Rectangle gameArea;
float foodDensity = .00005; //food per pixel
Set<Drawable> thingsToDraw = new HashSet<Drawable>(); //all things to draw
FoodTree foodTree = new FoodTree();;
int foodEaten = 0; //food eaten so far

int randomColor() {
    return color(int(random(256)), int(random(256)), int(random(256)));
}

boolean onScreen(PVector actual, PVector trans) {
    PVector virtual = PVector.add(actual, trans);
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

    s = new Snake();
    thingsToDraw.add(s);
    
    Set<Food> foodSet = scatterFood(int(gameRadius * gameRadius * foodDensity));
    thingsToDraw.addAll(foodSet);

    foodTree.addAll(foodSet);
	
}

int i=0;
void draw() {
    if (i++%10==0) return;
    background(#FFFFFF);
    
    PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
    s.step(delta);
    
    PVector trans = PVector.sub(screenCenter, s.head.pos);
    translate(trans.x, trans.y);

    for (Drawable thing: thingsToDraw)
	if (onScreen(thing.pos(), trans))
	    thing.draw();
    
}

