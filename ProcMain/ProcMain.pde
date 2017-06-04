Snake s;
PVector screenCenter;
int gameRadius = 4096;
float foodDensity = .00005; //food per pixel
Set<Drawable> things = new HashSet<Drawable>();

int randomColor() {
    return color(int(random(256)), int(random(256)), int(random(256)));
}

boolean onScreen(PVector actual, PVector trans) {
    PVector virtual = PVector.add(actual, trans);
    return virtual.x > 0 &&
	virtual.y > 0 &&
	virtual.x < width &&
	virtual.y < height;
}

void setup() {
    size(2048, 2048);
    screenCenter = new PVector(width/2, height/2);
    background(#FFFFFF);
    ellipseMode(RADIUS);

    s = new Snake();
    things.add(s);
    things.addAll(scatterFood(int(gameRadius * gameRadius * foodDensity)));
}

int i=0;
void draw() {
    if (i++%10==0) return;
    background(#FFFFFF);
    
    PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
    s.grow(delta);
    
    PVector trans = PVector.sub(screenCenter, s.head.pos);
    translate(trans.x, trans.y);
    for (Drawable thing: things)
	if (onScreen(thing.pos(), trans))
	    thing.draw();
    
}


