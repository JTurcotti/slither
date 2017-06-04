import java.util.*;

public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int radius = 50;
    int length = 15;
    int speed = 10;

    public Snake() {
	fillColor = color(int(random(256)), int(random(256)), int(random(256)));
	strokeColor = #000000;
	head = new Circle(screenCenter, radius, fillColor, strokeColor);
	body.add(head);
    }

    public void grow(PVector delta) {
	PVector newPos = PVector.add(head.pos, delta);
	head = new Circle(newPos, radius, fillColor, strokeColor);
	body.add(head);
	if (false && body.size() > length)
	    body.remove();

    }

    public void draw() {
	for (Circle c: body)
	    c.draw();
    }
    
}
