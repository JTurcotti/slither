import java.util.*;

public class Boundary implements Drawable {
    PVector start, end;

    public Boundary(PVector start, PVector end) {
	this.start = start;
	this.end = end;
    }

    public void draw() {
	stroke(#FF0000);
	strokeWeight(50);
	line(start.x, start.y, end.x, end.y);
	strokeWeight(1);
    }

    public PVector pos() {
	//ensure always renders
	return PVector.sub(screenCenter, translation);
    }
}

public Collection<Boundary> genBounds() {
    Set<Boundary> bounds = new HashSet<Boundary>();
    bounds.add(new Boundary(gameArea.vertex(Direction.NW), gameArea.vertex(Direction.NE)));
    bounds.add(new Boundary(gameArea.vertex(Direction.NE), gameArea.vertex(Direction.SE)));
    bounds.add(new Boundary(gameArea.vertex(Direction.SE), gameArea.vertex(Direction.SW)));
    bounds.add(new Boundary(gameArea.vertex(Direction.SW), gameArea.vertex(Direction.NW)));
    return bounds;
}

