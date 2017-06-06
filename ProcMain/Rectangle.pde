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
