public class PlayerSnake extends Snake {
    final float TURN_RATE = 3; //good value
    @Override
    float turnRate() {
	return TURN_RATE;
    }
    
    @Override
    protected int level() {
	return foodEaten;
    }

    @Override
    protected void decLevel() {
	foodEaten--;
    }
    
    @Override
    protected int radius() {
	return Math.max(30, int(2*sqrt(level())));
    }

    @Override
    protected int length() {
	println("length " + Math.max(10, level()/10));
	return Math.max(10, level()/10);
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

    @Override
    protected int eat() {
	int eaten = super.eat();
	foodEaten += eaten;
	return eaten;
    }
}
