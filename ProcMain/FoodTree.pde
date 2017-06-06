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
    }

    Collection<Node> children() {
	List<Node> children = new LinkedList<Node>();
	for (Direction d: Direction.values()) {
	    Node child = next.get(d);
	    if (child != null)
		children.add(child);
	}
	return children;
    }
}

public class FoodTree implements Iterable<Node> {
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
    }

    private Node add(Node n, Food value) {
	if (n == null)
	    //if reached the end of a tree (or no tree to begin with) create a new node
	    return new Node(value, layer); //pass new node

	if (n.value == value)
	    return n;
	
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
	    if (n!=root)
		n.prev.next.remove(n.whichChild); //cut pointer to node
	    //recursively go through all children of node, adding them back to the tree
	    for (Node child: toNodeList(n))
		if (child != n)
		    add(child.value);
	} else {
	    
	    //go to next node in right direction
	    Direction d = direction(n.value.pos, value.pos);
	    remove(n.next.get(d), value);
	}
    }
    
    
    public Collection<Food> within(Rectangle rect) {
	Set<Food> found = new HashSet<Food>();
	within(rect, root, found);
	return found;
    }

    private void within(Rectangle rect, Node n, Set<Food> found) {
	if (n==null)
	    return;

	if (mouseMode) 
	    n.value.fillColor = color(255, 255, 0);
			
	if (rect.contains(n.value.pos))
	    found.add(n.value);

	for (Direction d: Direction.values()) {
	    if (direction(n.value.pos, rect.vertex(d)) == d) {
		within(rect, n.next.get(d), found);
	    }
	}
    }

    public Food nearestTo(PVector v) {
	List<Node> potential = nearestTo(root, v);
	final PVector w = new PVector(v.x, v.y); //necessary to use in anon
	return Collections.min(potential, new Comparator<Node>() {
		public int compare(Node one, Node two) {
		    return int(one.value.pos.dist(w) -
			       two.value.pos.dist(w));
		}
	    }).value;
    }

    private List<Node> nearestTo(Node n, PVector v) {
	Direction d = direction(n.value.pos, v);
	Node child = n.next.get(d);
	if (child==null)
	    return toNodeList(n==root? n: n.prev);
	return nearestTo(child, v);
    }
	

    public Iterator<Node> iterator() {
	return toNodeList().iterator();
    }
    
    public List<Node> toNodeList() {
	return toNodeList(root);
    }

    //generates list of node and all children
    public List<Node> toNodeList(Node n) {
	Queue<Node> eval = new ArrayDeque<Node>();
	List<Node> nodes = new LinkedList<Node>();
	if (n==null)
	    return nodes;
	eval.add(n);
	nodes.add(n);
	while (!eval.isEmpty()) {
	    Node child = eval.remove();
	    for (Node grandchild: child.children()) {
		eval.add(grandchild);
		nodes.add(grandchild);
	    }
	}
	return nodes;
    }
}
	
		
    
    
