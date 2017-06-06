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
