import java.util.*;

abstract public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int speed = 10;
    int health = 0;
    int skip = 4;
    PVector heading = new PVector(1, 0);
    final int SKIP_MAX = 2;
    final int SKIP_MIN = 1;
    protected boolean speedMode = false;
    final int DEC_STEP = 1;
    final int INC_STEP = 1;
    abstract float turnRate(); //higher to turn faster. 0 to not turn

    boolean render() {
	for (Circle c: body)
	    if (onScreen(c.pos))
		return true;
	return false;
    }

    protected void initAt(PVector pos) {
	fillColor = randomColor(128);
	strokeColor = randomColor(128) + #888888;
	head = new Circle(pos, radius(), fillColor, strokeColor);
	body.add(head);
    }

    //behavorial bethods, def need tweaking
    abstract protected int level();
    abstract protected void decLevel();
    abstract protected int radius();
    abstract protected int length();
    abstract protected PVector nextHeading();

    //neccesary things that must happen for all snakes
    public void step() {
	if (time%skip!=0) return;
	heading = PVector.add(heading, nextHeading().mult(turnRate())).normalize();
	grow(heading);
	eat();
	shrink();
	doHealth();
	if (bounded && !gameArea.contains(head.pos))
	    alive = false;
    }
    
    protected void grow(PVector d) {
	PVector delta = d.mult(speed); 
	PVector newPos = PVector.add(head.pos, delta);
	head = new Circle(newPos, radius(), fillColor, strokeColor);
	body.add(head);
    }

    protected void shrink() {
	if (body.size() > length())
	    body.remove();
    }

    protected void doHealth() {
	if (speedMode) {
	    speedMode = decHealth();
	    //test if should stay speeding
	} else {
	    incHealth();
	    //refresh health if not speeding
	}
	if (speedMode)//update speed to reflecting speeding
	    skip = SKIP_MIN;
	else
	    skip = SKIP_MAX;
	speedMode = false; //reset by default to not speeding, will be set back to true in ProcMain by mouse loop
    }

    protected void incHealth() {
	if (health <= level())
	    health += INC_STEP;
    }

    protected boolean decHealth() {
	if (health>0) {
	    health -= DEC_STEP;
	    decLevel();
	    return true;
	} else {
	    return false;
	}
	    
    }

    public void speedUp() {
	speedMode = true;
    }
	    

    protected int eat() {
	Rectangle bounds = head.bounds();
	int eaten = 0;
	for (Food food: foodTree.within(bounds)) {
	    if ((food.pos).dist(head.pos) <= radius() + 5) { //tolerance is annoying but slightly necessary
		eaten += food.radius;
		foodTree.remove(food);
		thingsToDraw.remove(food);
	    }
	}
	return eaten;
    }

    public void draw() {
	int radius = radius();
	for (Circle c: body)
	    c.draw();
	PVector center = head.pos;
	PVector direction = nextHeading();
	PVector leftCenter = new PVector(heading.x, heading.y)
	    .rotate(QUARTER_PI)
	    .setMag(radius/2)
	    .add(center);
	PVector rightCenter = new PVector(heading.x, heading.y)
	    .rotate( -1 * QUARTER_PI)
	    .setMag(radius/2)
	    .add(center);
	(new Circle(leftCenter, radius/4, #FFFFFF, #FFFFFF)).draw();
	(new Circle(rightCenter, radius/4, #FFFFFF, #FFFFFF)).draw();
	PVector leftOffCenter = mouse()
	    .sub(center)
	    .setMag(radius/6)
	    .add(leftCenter);
	PVector rightOffCenter = mouse()
	    .sub(center)
	    .setMag(radius/6)
	    .add(rightCenter);
	(new Circle(leftOffCenter, radius/6, #000000, #000000)).draw();
	(new Circle(rightOffCenter, radius/6, #000000, #000000)).draw();
    }
    
}

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
	return Math.max(30, int(2*sqrt(foodEaten)));
    }

    @Override
    protected int length() {
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
    protected int eat() {
	int eaten = super.eat();
	foodEaten += eaten;
	return eaten;
    }
}

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
    protected void decLevel() {}
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

