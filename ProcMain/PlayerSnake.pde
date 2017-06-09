public class PlayerSnake extends Snake {
    final float TURN_RATE = 3; //good value
    @Override
    float turnRate() {
	return TURN_RATE;
    }
    
    @Override
    protected PVector nextHeading() {
	return new PVector(mouseX, mouseY)
	    .sub(screenCenter)
	    .normalize();
    }
    
    public PlayerSnake() {
	initAt(ORIGIN);
    }

    @Override
    protected void die() {
	super.die();
	println("game over");
    }
}
