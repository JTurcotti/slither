import java.util.*;

class Node {
    Food value;
    Map<Direction, Node> next = new HashMap<Direction, Node>();
    Node prev;
    Direction whichChild;
    int depth;

    Node(Food value, int depth) {
	this.value = value;
	this.depth = depth;
	this.value.fillColor = depth*10;
    }
}

public class FoodTree {
    private Node root;
    
    public void addAll(Collection<Food> values) {
	for (Food value: values)
	    add(value);
    }

    int layer;
    int maxDepth;
    
    //wrapper add function, begins at root
    public void add(Food value) {
	layer = 0;
	maxDepth = 0;
	root = add(root, value); //returns root unless root is null
	println("Max Deoth: " + maxDepth);
    }

    private Node add(Node n, Food value) {
	if (n == null)
	    //if reached the end of a tree (or no tree to begin with) create a new node
	    return new Node(value, layer); //pass new node

	Direction d = direction(n.value.pos, value.pos);

	layer++;
	if (layer>maxDepth) maxDepth = layer;
	Node child = add(n.next.get(d), value);
	layer--;
	
	if (child.prev == null) {
	    child.prev = n;
	    child.whichChild = d;
	    if (n.depth - child.depth != -1)
		throw new IllegalStateException("depth fucked up");
	}
	n.next.put(d, child); //when done, put back passed node

	return n; //pass old node
    }

    public void remove(Food value) {
	remove(root, value);
    }

    private void remove(Node n, Food value) {
	if (n == null)
	    //value not contained in tree
	    throw new IllegalArgumentException("value not contained in tree");
	
	if (n.value == value) { //once reached correct node
	    n.prev.next.remove(n.whichChild); //cut pointers to node
	    //recursively go through all children of node, adding them back to the tree
	    Stack<Node> children = new Stack<Node>();
	    children.push(n);
	    while (!children.empty()) {
		Node child = children.pop();
		for (Direction d: Direction.values()) {
		    Node grandchild = child.next.get(d);
		    if (grandchild != null) {
			add(grandchild.value);
			children.push(grandchild);
		    }
		}
	    }
	}

	//go to next node in right direction
	Direction d = direction(n.value.pos, value.pos);
	remove(n.next.get(d), value);
    }
    
    
    public Collection<Food> within(Rectangle rect) {
	Set<Food> found = new HashSet<Food>();
	within(rect, root, found);
	return found;
    }

    private void within(Rectangle rect, Node n, Set<Food> found) {
	if (n==null)
	    return;

	if (rect.contains(n.value.pos))
	    found.add(n.value);

	for (Direction d: Direction.values())
	    if (direction(n.value.pos, rect.vertex(d.opposite)) == d)
		within(rect, n.next.get(d), found);
    }

}
	
		
    
    
