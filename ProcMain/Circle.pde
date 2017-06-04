import java.util.*;

public class Circle implements Drawable{
    int radius;
    PVector pos;
    int fillColor;
    int strokeColor;

    PVector pos() {
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
}
