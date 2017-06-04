import java.util.*;

public class Snake implements Drawable {
    Queue<Circle> body = new ArrayDeque<Circle>(); //head represents "tail" of snake
    Circle head; //"actual" head (tail of real deque)
    int fillColor;
    int strokeColor;
    int radius = 50;

    public Snake() {
	fillColor = color(int(random(256)), int(random(256)), int(random(256)));
	strokeColor = #000000;
	head = new Circle(new PVector(width/2, height/2),
			  radius, fillColor, strokeColor);
	body.add(head);
    }

    public void grow(PVector target) {
	PVector newPos = PVector
	    .sub(target, head.pos)
	    .normalize()
	    .mult(10)
	    .add(head.pos);
	head = new Circle(newPos, radius, fillColor, strokeColor);
	body.add(head);
    }

    public void draw() {
	for (Circle c: body)
	    c.draw();
    }
    
}
