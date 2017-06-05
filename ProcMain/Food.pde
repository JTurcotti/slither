import java.util.*;

Collection<Food> scatterFood(int num) {
    Set<Food> food = new HashSet<Food>();
    while (num-->0) {
	PVector pos = new PVector(int(random(2 * gameRadius)) - gameRadius,
				  int(random(2 * gameRadius)) - gameRadius);
	int fillColor = randomColor();
	int radius = 10 + int(random(10));
	food.add(new Food(pos, fillColor, radius));
    }
    return food;
}		    

public class Food implements Drawable{
    PVector pos;
    int fillColor;
    int radius;

    PVector pos() {
	return pos;
    }

    public Food(PVector pos, int fillColor, int radius) {
	this.pos = pos;
	this.fillColor = fillColor;
	this.radius = radius;
    }
    
    public void draw() {
	fill(fillColor);
	stroke(fillColor);
	ellipse(pos.x, pos.y, radius, radius);
    }
}
