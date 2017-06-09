import java.util.*;

public class Circle implements Drawable{
    int radius;
    PVector pos;
    int fillColor;
    int strokeColor;

    boolean render() {
	return onScreen(pos);
    }

    public Circle(PVector pos, int radius, int fillColor, int strokeColor) {
	if (radius <= 0)
	    throw new IllegalArgumentException("radius must be +");
	if (pos == null || Float.isNaN(pos.x) || Float.isNaN(pos.y))
	    throw new IllegalArgumentException("position objects is null or contains NaN values");
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

    public float dist(Circle other) {
	return (this.pos).dist(other.pos);
    }

}
