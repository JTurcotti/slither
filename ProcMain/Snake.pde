import java.util.*;

public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int radius = 35;
    int speed = 10;
    int health = 0;
    int skip = 4;
    final int SKIP_MAX = 3;
    final int SKIP_MIN = 1;
    private boolean speedMode = false;
    final int DEC_STEP = 1;
    final int INC_STEP = 1;

    PVector pos() {
	return head.pos;
    }
    
    public Snake() {
	fillColor = randomColor(128);
	strokeColor = randomColor(128) + #888888;
	head = new Circle(screenCenter, radius, fillColor, strokeColor);
	body.add(head);
    }

    public void step(PVector delta) {
	if (time%skip!=0) return;
	System.out.println(health);
	grow(delta);
	eat();
	shrink();
	doHealth();
	if (bounded && !gameArea.contains(head.pos))
	    alive = false;
    }
    
    private void grow(PVector d) {
	PVector delta = d.normalize().mult(speed); 
	PVector newPos = PVector.add(head.pos, delta);
	head = new Circle(newPos, radius, fillColor, strokeColor);
	body.add(head);
    }

    private void shrink() {
	if (body.size() > Math.max(10, foodEaten/10))
	    body.remove();
    }

    private void doHealth() {
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

    private void incHealth() {
	if (health <= foodEaten)
	    health += INC_STEP;
    }

    private boolean decHealth() {
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
	    

    private void eat() {
	Rectangle bounds = head.bounds();
	for (Food food: foodTree.within(bounds)) {
	    if ((food.pos).dist(head.pos) <= radius + 5) { //tolerance is annoying but slightly necessary
		//println(foodEaten++);
		foodEaten+=food.radius;
		foodTree.remove(food);
		thingsToDraw.remove(food);
	    }
	}
    }

    public void draw() {
	for (Circle c: body)
	    c.draw();
    }
    
}
