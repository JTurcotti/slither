import java.util.*;

abstract public class Snake implements Drawable, Iterable<Circle> {
    private Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    public Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int speed = 10;
    int skip = 4;
    int eaten = 0;
    PVector heading = new PVector(1, 0);
    final int SKIP_MAX = 2;
    final int SKIP_MIN = 1;
    protected boolean speedMode = false;
    final int DEC_STEP = 2;
    final int INC_STEP = 1;
    final int TOLERANCE = 5;
    final float DEATH_SPAWN_CHANCE = 0.3;
    final int SCAT_SIZE = 7;
    final float SCAT_CHANCE = 0.1;
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
    abstract protected PVector nextHeading();

    protected int radius() {
	return Math.max(30, int(sqrt(eaten)));
    }

    protected int length() {
	return Math.max(10, eaten/10);
    }

    
    public Iterator<Circle> iterator() {
	return body.iterator();
    }

    public PVector pos() {
	return head.pos;
    }
    
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
	checkCollision();
    }

    private void dropTrail() {
	Food scat = new Food(body.element().pos, fillColor, SCAT_SIZE);
	foodTree.add(scat);
	thingsToDraw.add(scat);
    }
    
    protected void grow(PVector d) {
	PVector delta = d.mult(speed); 
	PVector newPos = PVector.add(head.pos, delta);
	head = new Circle(newPos, radius(), fillColor, strokeColor);
	body.add(head);
	circleList.add(head);
    }

    protected void shrink() {
	if (body.size() > length()) {
	    body.remove();
	    //this is sloppy, and does not ALWAYS remove the right circle, but its good enoigh
	    circleList.remove();
	}
    }

    protected void doHealth() {
	if (speedMode) {
	    speedMode = decHealth();
	    //test if should stay speeding
	}
	if (speedMode)//update speed to reflecting speeding
	    skip = SKIP_MIN;
	else
	    skip = SKIP_MAX;
	speedMode = false; //reset by default to not speeding, will be set back to true in ProcMain by mouse loop
    }

    protected boolean decHealth() {
	if (eaten > 0) {
	    eaten--;
	    if (random(1)<SCAT_CHANCE)
		dropTrail();
	    return true;
	} else {
	    return false;
	}
    }

    public void speedUp() {
	speedMode = true;
    }

    protected void die() {
	for (Circle c: this) {
	    if (random(1) < DEATH_SPAWN_CHANCE) {
		PVector off = PVector.random2D().setMag(random(20));
		Food f = new Food(PVector.add(c.pos, off), fillColor, 20 + int(random(radius()/4)));
		foodTree.add(f);
		thingsToDraw.add(f);
	    }
	}
	snakeList.remove(this);
	thingsToDraw.remove(this);
    }

    protected NavigableSet<Circle> dangerList() {
	final PVector pos = head.pos; 
	NavigableSet<Circle> danger = new TreeSet<Circle>(new Comparator<Circle>() {
		public int compare(Circle one, Circle two) {
		    return int(one.dist(head) - two.dist(head));
		}
	    });
	for (Circle circle: circleList)
	    if (circle.render())
		danger.add(circle);
	return danger;
    }

    protected boolean checkCollisionWith(Snake snake) {
	for (Circle circle: snake)
	    if (circle.dist(head) <= radius() + snake.radius() + TOLERANCE)
		return true;
	return false;
    }

    protected void checkCollision() {
	for (Snake snake: snakeList)
	    if (snake != this && snake.render() && checkCollisionWith(snake)) {
		deathRow = this;
		break;
	    }
    }
		
    protected void eat() {
	Rectangle bounds = head.bounds();
	int eatenThisTurn = 0;
	for (Food food: foodTree.within(bounds)) {
	    if ((food.pos).dist(head.pos) <= radius() + TOLERANCE) { //tolerance is annoying but slightly necessary
		eatenThisTurn += food.radius;
		foodTree.remove(food);
		thingsToDraw.remove(food);
	    }
	}
	eaten += eatenThisTurn;
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

void lineTrack() {
    try {
	throw new Exception();
    } catch (Exception e) {
	e.printStackTrace();
    }
}
