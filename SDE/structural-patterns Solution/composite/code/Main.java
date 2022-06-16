import java.util.Iterator;
import java.util.Scanner;

public class Main{

	public static void main(String[] args){
		int choice;

		String name;
		int age;
		double salary;
		double externalRevenue;
		double commissionPercentage;

		boolean exit = false;

		StaffComponent coachingStaff = new Staff("Coach");
		StaffComponent managerialStaff = new Staff("Manager");
		StaffComponent medicalStaff = new Staff("Medical Officer");
		StaffComponent doctorStaff = new Staff("Doctor");
		StaffComponent physiotherapistStaff = new Staff("Physiotherapist");

		medicalStaff.add(doctorStaff);
		medicalStaff.add(physiotherapistStaff);

		StaffComponent allStaffs = new Staff("All Staffs");
		allStaffs.add(coachingStaff);
		allStaffs.add(managerialStaff);
		allStaffs.add(medicalStaff);

		coachingStaff.add(new StaffItem("Unai Emery", 46, 6000000, 3000000, 20));
		coachingStaff.add(new StaffItem("Neil Banfield", 56, 520000, 100000, 12));
		managerialStaff.add(new StaffItem("Steve Bould", 55, 1560000, 500000, 16));
		managerialStaff.add(new StaffItem("Vic Akers OBE", 71, 62000, 100000, 5));
		doctorStaff.add(new StaffItem("Gary O'Driscoll", 58, 40000, 20000, 2));
		physiotherapistStaff.add(new StaffItem("Andrew Rolls", 38, 41000, 20000, 2));

		Scanner in = new Scanner(System.in);
		while(true){
			System.out.println("1. View Salary\n2. View Age\n3. View Club Commission\n4. Add Staff\n5. Remove Staff\n6. Exit");
			choice = in.nextInt();
			switch(choice){
				case 1: 
					allStaffs.getSalary();
					break;
				case 2: 
					allStaffs.getAge();
					break;
				case 3: 
					allStaffs.getClubCommission();
					break;
				case 4:
					System.out.print("Name: "); in.nextLine(); name = in.nextLine();
					System.out.print("Age: "); age = in.nextInt(); 
					System.out.print("Salary: "); salary = in.nextDouble(); 
					System.out.print("External Revenue: "); externalRevenue = in.nextDouble(); 
					System.out.print("Commission Percentage: "); commissionPercentage = in.nextDouble(); 
					System.out.print("Type of Staff [1/2/3/4 - Coach/Manager/Doctor/Physiotherapist]: "); choice = in.nextInt(); 
					switch(choice){
						case 1:
							coachingStaff.add(new StaffItem(name, age, salary, externalRevenue, commissionPercentage));
							break;
						case 2:
							managerialStaff.add(new StaffItem(name, age, salary, externalRevenue, commissionPercentage));
							break;
						case 3:
							doctorStaff.add(new StaffItem(name, age, salary, externalRevenue, commissionPercentage));
							break;
						case 4:
							physiotherapistStaff.add(new StaffItem(name, age, salary, externalRevenue, commissionPercentage));
							break;
					}
					break;
				case 5:
					System.out.print("Enter Name of Staff: "); in.nextLine(); name = in.nextLine();
					boolean found = false;
					for(int i = 0; i < coachingStaff.getSize(); i++){
						String temp = coachingStaff.getChild(i).getName();
						if(temp.equals(name)){
							found = true;
							coachingStaff.removeAtIndex(i);
						}
					}
					if(! found){
						for(int i = 0; i < managerialStaff.getSize(); i++){
							String temp = managerialStaff.getChild(i).getName();
							if(temp.equals(name)){
								found = true;
								managerialStaff.removeAtIndex(i);
							}
						}
					}
					if(! found){
						for(int i = 0; i < doctorStaff.getSize(); i++){
							String temp = doctorStaff.getChild(i).getName();
							if(temp.equals(name)){
								found = true;
								doctorStaff.removeAtIndex(i);
							}
						}
					}
					if(! found){
						for(int i = 0; i < physiotherapistStaff.getSize(); i++){
							String temp = physiotherapistStaff.getChild(i).getName();
							if(temp.equals(name)){
								found = true;
								physiotherapistStaff.removeAtIndex(i);
							}
						}
					}
					break;
				case 6:
					exit = true;
					break;
			}

			if(exit == true){
				break;
			}
		}
	}

}
