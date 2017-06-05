import java.util.*;

public class Circle implements Drawable{
    int radius;
    PVector pos;
    int fillColor;
    int strokeColor;

    public PVector pos() {
	return pos;
    }

    public Circle(PVector pos, int radius, int fillColor, int strokeColor) {
	this.pos = pos;
	this.radius = radius;
	this.fillColor = fillColor;
	this.strokeColor = strokeColor;
    }
    
    public void draw() {
	fill(fillColor);
	stroke(strokeColor);
	ellipse(pos.x, pos.y, radius, radius);
    }

    public Rectangle bounds() {
	int radius = this.radius + 30; //tolerance for error in collision detection
	//necessary because quadtree can only effectively search recentagles
	return new Rectangle(int(pos.x - radius), int(pos.x + radius),
			     int(pos.y - radius), int(pos.y + radius));
    }
}
