Snake s;
PVector screenCenter;

void setup() {
    size(2048, 2048);
    screenCenter = new PVector(width/2, height/2);
    background(#FFFFFF);
    ellipseMode(RADIUS);
    s = new Snake();
}

void draw() {
    background(#FFFFFF);
    
    PVector delta = new PVector(mouseX, mouseY)
	.sub(screenCenter)
	.normalize()
	.mult(10);
    s.grow(delta);
    PVector trans = PVector.sub(screenCenter, s.head.pos);
    translate(trans.x, trans.y);
    s.draw();
}
