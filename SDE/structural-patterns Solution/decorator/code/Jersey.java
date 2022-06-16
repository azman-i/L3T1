public abstract class Jersey{

	private String description = "Jersesy Description";

	public String getDescription(){
		return description;
	}

	public void setDescription(String description){
		this.description = description;
	}

	public abstract double cost();

}
