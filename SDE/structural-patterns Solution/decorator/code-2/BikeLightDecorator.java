public class BikeLightDecorator extends BikeDecorator{

	private Bike bike;
	private int lightType;

	public BikeLightDecorator(Bike bike, int lightType){
		this.bike = bike;
		this.lightType = lightType;
	}

	public String getDescription(){
		String lightDescription;
		switch(lightType){
			case 1:
				lightDescription = "front light";
				break;
			case 2:
				lightDescription = "back light";
				break;
			case 3:
				lightDescription = "both front and back light";
				break;
			default:
				lightDescription = "front light";
				break;
		}
		return bike.getDescription() + " + " + lightDescription;
	}

	public double cost(){
		int lightCost;
		switch(lightType){
			case 1:
				lightCost = 30;
				break;
			case 2:
				lightCost = 25;
				break;
			case 3:
				lightCost = 40;
				break;
			default:
				lightCost = 30;
				break;
		}
		return lightCost + bike.cost();
	}

}

