public class BikeBasketDecorator extends BikeDecorator{

	private Bike bike;

	public BikeBasketDecorator(Bike bike){
		this.bike = bike;
	}

	public String getDescription(){
		return bike.getDescription() + " + basket";
	}

	public double cost(){
		return 25 + bike.cost();
	}

}

