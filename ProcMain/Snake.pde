import java.util.*;

public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int radius = 35;
    int speed = 10;
    int health = 0;

    PVector pos() {
	return head.pos;
    }
    
    public Snake() {
	fillColor = randomColor();
	strokeColor = #000000;
	head = new Circle(screenCenter, radius, fillColor, strokeColor);
	body.add(head);
    }

    public void step(PVector delta) {
	System.out.println(health);
	grow(delta);
	eat();
	shrink();
	incHealth();
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

    public void incHealth() {
	if (health <= foodEaten)
	    health+=1;
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
