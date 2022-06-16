import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Staff extends StaffComponent{

	private String name;
	private List<StaffComponent> staffComponents = new ArrayList<StaffComponent>();

	public Staff(String name){
		this.name = name;
	}

	public void add(StaffComponent staffComponent){
		staffComponents.add(staffComponent);
	}

	public void remove(StaffComponent staffComponent){
		staffComponents.remove(staffComponent);
	}

	public StaffComponent getChild(int i){
		return (StaffComponent)staffComponents.get(i);
	}


	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

	public String getName(){
		return name;
	}

	public void setName(String name){
		this.name = name;
	}

	public int getAge(){
		int age = 0;
		Iterator iterator = staffComponents.iterator();
		while(iterator.hasNext()){
			StaffComponent staffComponent = (StaffComponent)iterator.next();
			age += staffComponent.getAge();
		}

		System.out.println("Age of " + name + " is " + age);
		return age;
	}

	public double getSalary(){
		double salary = 0;
		Iterator iterator = staffComponents.iterator();
		while(iterator.hasNext()){
			StaffComponent staffComponent = (StaffComponent)iterator.next();
			salary += staffComponent.getSalary();
		}

		System.out.println("Salary of " + name + " is " + salary);
		return salary;
	}

	public double getClubCommission(){
		double clubCommission = 0;
		Iterator iterator = staffComponents.iterator();
		while(iterator.hasNext()){
			StaffComponent staffComponent = (StaffComponent)iterator.next();
			clubCommission += staffComponent.getClubCommission();
		}

		System.out.println("Club Commission of " + name + " is " + clubCommission);
		return clubCommission;
	}

	public int getSize(){
		return staffComponents.size();
	}

	public void removeAtIndex(int idx){
		staffComponents.remove(idx);
	}

}
