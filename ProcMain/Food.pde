import java.util.*;

static final float WOBBLE = 0.4;

Collection<Food> scatterFood(int num) {
    Set<Food> food = new HashSet<Food>();
    while (num-->0) {
	PVector pos = randomPos();
	int fillColor, radius;
	if (clearTree) {
	    fillColor = color(128);
	    radius = 10;
	} else {
	    fillColor = randomColor();
	    radius = 10 + int(random(10));
	}
	food.add(new Food(pos, fillColor, radius));
    }
    return food;
}		    

public class Food implements Drawable{
    PVector pos;
    int fillColor;
    int radius;
    float phase;
    PVector heading;

    boolean render() {
	return onScreen(pos);
    }

    public Food(PVector pos, int fillColor, int radius) {
	this.pos = pos;
	this.fillColor = fillColor;
	this.radius = radius;
	this.phase = random(16);
	this.heading = PVector.random2D().setMag(WOBBLE);
    }
    
    public void draw() {
	fill(red(fillColor), green(fillColor), blue(fillColor), 158+64*sin((time-2*PI*phase)/16));
	stroke(fillColor);
	ellipse(pos.x, pos.y, radius, radius);
	if (render())
	    wobble();
    }

    private void wobble() {
	pos.add(heading);
	heading.rotate(PI/12);
    }
}
