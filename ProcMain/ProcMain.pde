Snake s;

void setup() {
    size(2048, 2048);
    background(#FFFFFF);
    s = new Snake();
}

void draw() {
    PVector m = new PVector(mouseX, mouseY);
    s.grow(m);
    background(#FFFFFF);
    s.draw();
}
