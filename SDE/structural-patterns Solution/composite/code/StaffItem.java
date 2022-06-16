public class StaffItem extends StaffComponent{

	private String name;
	private int age;
	private double salary;
	private double externalRevenue;
	private double commissionPercentage;

	public StaffItem(String name, int age, double salary, double externalRevenue, double commissionPercentage){
		this.name = name;
		this.age = age;
		this.salary = salary;
		this.externalRevenue = externalRevenue;
		this.commissionPercentage = commissionPercentage;
	}

	public String getName(){
		return name;
	}

	public int getAge(){
		System.out.println("Age of " + name + " is " + age);
		return age;
	}

	public double getSalary(){
		System.out.println("Salary of " + name + " is " + salary);
		return salary;
	}

	public double getExternalRevenue(){
		return externalRevenue;
	}

	public double getCommissionPercentage(){
		return commissionPercentage;
	}

	public void setName(String name){
		this.name = name;
	}

	public void setAge(int age){
		this.age = age;
	}

	public void setSalary(double salary){
		this.salary = salary;
	}

	public void setExternalRevenue(double externalRevenue){
		this.externalRevenue = externalRevenue;
	}

	public void setCommissionPercentage(double commissionPercentage){
		this.commissionPercentage = commissionPercentage;
	}

	public double getClubCommission(){
		System.out.println("Club Commission of " + name + " is " + externalRevenue * commissionPercentage * 0.01);
		return externalRevenue * commissionPercentage * 0.01;
	}

}
