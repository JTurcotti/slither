import java.util.*;

public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int radius = 50;
    int length = 50;
    int speed = 10;

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
	grow(delta);
	eat();
	if (!gameArea.contains(head.pos))
	    alive = false;
    }
    
    private void grow(PVector d) {
	PVector delta = d.normalize().mult(speed); 
	PVector newPos = PVector.add(head.pos, delta);
	head = new Circle(newPos, radius, fillColor, strokeColor);
	body.add(head);
	if (body.size() > length)
	    body.remove();
    }

    private void eat() {
	Rectangle bounds = head.bounds();
	for (Food food: foodTree.within(bounds)) {
	    if ((food.pos).dist(head.pos) <= radius + 5) { //tolerance is annoying but slightly necessary
		println(foodEaten++);
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
