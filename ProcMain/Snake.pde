import java.util.*;

abstract public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int speed = 10;
    int health = 0;
    int skip = 4;
    final int SKIP_MAX = 3;
    final int SKIP_MIN = 1;
    protected boolean speedMode = false;
    final int DEC_STEP = 1;
    final int INC_STEP = 1;

    PVector pos() {
	return head.pos;
    }

    protected void initAt(PVector pos) {
	fillColor = randomColor(128);
	strokeColor = randomColor(128) + #888888;
	head = new Circle(pos, radius(), fillColor, strokeColor);
	body.add(head);
    }

    //behavorial bethods, def need tweaking
    abstract protected int level();
    abstract protected int radius();
    abstract protected int length();

    //turn wrapper
    abstract public void doTurn();


    //neccesary things that must happen for all snakes
    protected void step(PVector delta) {
	if (time%skip!=0) return;
	System.out.println(health);
	grow(delta);
	eat();
	shrink();
	doHealth();
	if (bounded && !gameArea.contains(head.pos))
	    alive = false;
    }
    
    protected void grow(PVector d) {
	PVector delta = d.normalize().mult(speed); 
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
	for (Circle c: body)
	    c.draw();
    }
    
}

public class PlayerSnake extends Snake {
    @Override
    protected int level() {
	return foodEaten;
    }
    
    @Override
    protected int radius() {
	return Math.max(30, 2*Math.pow(foodEaten, 0.5));
    }

    @Override
    protected int length() {
	return Math.max(10, level()/10);
    }

    @Override
    public void doTurn() {
	PVector delta = new PVector(mouseX, mouseY).sub(screenCenter);
	step(delta);
    }

    public PlayerSnake() {
	initAt(screenCenter);
    }

    @Override
    protected int eat() {
	int eaten = super.eat();
	foodEaten += eaten;
	return eaten;
    }
}

