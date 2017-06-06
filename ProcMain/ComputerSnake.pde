public class ComputerSnake extends Snake {
    final float TURN_RATE = 2; //accounts for precision in algorithms
    @Override
    float turnRate() {
	//if too close too edge, turn more quickly
	if (gameArea.contains(PVector.add(head.pos, PVector.mult(heading, 15))))
	    return TURN_RATE;
	else
	    return 3 * TURN_RATE;
    }
    
    int level;
    int radius;
    int length;
    
    @Override
    protected int level() {
	return level;}
    @Override
    protected void decLevel() {
	level--;
    }
    @Override
    protected int radius() {
	return radius;}
    @Override
    protected int length() {
	return length;}

    @Override
    protected PVector nextHeading() {
	return PVector
	    .sub(foodTree.nearestTo(head.pos).pos, head.pos)
	    .normalize();
    }
    
    public ComputerSnake() {
	initAt(randomPos());
	level = 100 + int(random(50));
	radius = 30 + int(random(10));
	length = 50 + int(random(20));
    }
}

