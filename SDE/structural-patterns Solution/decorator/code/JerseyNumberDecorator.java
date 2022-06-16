public class JerseyNumberDecorator extends JerseyDecorator{

	private Jersey jersey;
	private String number;
	private double costPerDigit = 3;

	public JerseyNumberDecorator(Jersey jersey, String number){
		this.jersey = jersey;
		this.number = number;
	}

	public String getDescription(){
		return jersey.getDescription() + " with the number " + number;
	}

	public double cost(){
		return (costPerDigit * number.length()) + jersey.cost();
	}

}
