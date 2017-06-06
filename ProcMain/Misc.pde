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

class Rectangle implements Drawable{
    int x1, x2, y1, y2;
    private Map<Direction, PVector> vertices = new HashMap<Direction, PVector>();
    public Rectangle(int x1, int x2, int y1, int y2) {
	if (x2<=x1 || y2 <= y1)
	    throw new IllegalArgumentException("rect must have + area");
	this.x1 = x1;
	this.y1 = y1;
	this.x2 = x2;
	this.y2 = y2;

	vertices.put(Direction.NW, new PVector(x1, y1));
	vertices.put(Direction.NE, new PVector(x2, y1));
	vertices.put(Direction.SE, new PVector(x2, y2));
	vertices.put(Direction.SW, new PVector(x1, y2));
    }

    boolean contains(float x, float y) {
	return x>=x1 && x<=x2 && y>=y1 && y<=y2;
    }

    boolean contains(PVector v) {
	return contains(v.x, v.y);
    }

    Collection<PVector> vertices() {
	List<PVector> l = new ArrayList<PVector>();
	for (Direction d: Direction.values())
	    l.add(vertex(d));
	return l;
    }  

    PVector vertex(Direction d) {
	return vertices.get(d);
    }

    boolean render() {
	for (PVector v: vertices())
	    if (onScreen(v))
		return true;
	return false;
    }
		    

    void draw() {
	fill(color(0, 255, 0, 128));
	rectMode(CORNERS);
	rect(x1, y1, x2, y2);
    }
}

enum Direction {
    NW, NE, SE, SW;

    public Direction opposite;

    static {
	NW.opposite = SE;
	NE.opposite = SW;
	SE.opposite = NW;
	SW.opposite = NE;
    }
}

Direction direction(PVector v1, PVector v2) {
    if ((v2.x < v1.x) && (v2.y <= v1.y))
	return Direction.NW;
    if ((v2.x >= v1.x) && (v2.y < v1.y))
	return Direction.NE;
    if ((v2.x > v1.x) && (v2.y >= v1.y))
	return Direction.SE;
    if ((v2.x <= v1.x) && (v2.y > v1.y))
	return Direction.SW;
    return Direction.NW; //this could be rlllly fucked up
    
    //throw new IllegalStateException("direction calc went wrong " + v1 + " " + v2);

    
    /*
    float angle = PVector.sub(v2, v1).heading();
    if (angle > 0)
	if (angle < HALF_PI)
	    return Direction.SE;
	else
	    return Direction.SW;
    else
	if (angle > HALF_PI * -1)
	    return Direction.NE;
	else
	    return Direction.NW;
    //*/
}
