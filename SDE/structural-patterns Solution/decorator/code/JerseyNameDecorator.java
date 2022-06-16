public class JerseyNameDecorator extends JerseyDecorator{

	private Jersey jersey;
	private String name;
	private double costPerLetter = 2;

	public JerseyNameDecorator(Jersey jersey, String name){
		this.jersey = jersey;
		this.name = name;
	}

	public String getDescription(){
		return jersey.getDescription() + " for " + name;
	}

	public double cost(){
		return (costPerLetter * name.length()) + jersey.cost();
	}

}
