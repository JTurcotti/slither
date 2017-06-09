public class ComputerSnake extends Snake {
    final float TURN_RATE = 2; //accounts for precision in algorithms
    final float DANGER_RADIUS = 20;
    
    @Override
    float turnRate() {
	//if too close too edge, turn more quickly
	if (gameArea.contains(PVector.add(head.pos, PVector.mult(heading, 15))))
	    return TURN_RATE;
	else
	    return 3 * TURN_RATE;
    }
    
    @Override
    protected PVector nextHeading() {
	//	PVector danger = safestHeading();
	//	if (danger == null)
	    return PVector
		.sub(foodTree.nearestTo(head.pos).pos, head.pos)
		.normalize();
	    //	return danger.normalize();
    }
    
    public ComputerSnake() {
	initAt(randomPos());
	eaten = 100 + int(random(50));
    }

    @Override
    protected void die() {
	super.die();

	//spawn some number of new snakes
	for (int i=0; i<int(random(5)); i++) {
	    Snake s = new ComputerSnake();
	    thingsToDraw.add(s);
	    snakeList.add(s);
	}
    }

    private PVector safestHeading() {
	PVector heading = new PVector(0, 0);
	NavigableSet<Circle> danger = dangerList(); //yes its costly to calculate
	if (danger.size() == 0 || (danger.first()).dist(head) >= DANGER_RADIUS)
	    return null; //irrelevant result
	for (Circle c: danger) {//gauranteed to go in ascending order of distance
	    PVector subHeading = PVector.sub(head.pos, c.pos);
	    subHeading.setMag(1 / (1 + subHeading.mag()));
	    heading.add(subHeading);
	}
	return heading;
    }

    
}

