public abstract class Bike{

	private String description = "Bike Description";

	public String getDescription(){
		return description;
	}

	public void setDescription(String description){
		this.description = description;
	}

	public abstract double cost();

}
