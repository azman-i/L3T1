public class BikeHornDecorator extends BikeDecorator{

	private Bike bike;

	public BikeHornDecorator(Bike bike){
		this.bike = bike;
	}

	public String getDescription(){
		return bike.getDescription() + " + horn";
	}

	public double cost(){
		return 15 + bike.cost();
	}

}
