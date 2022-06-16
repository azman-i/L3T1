import java.util.Scanner;

public class Main{

	public static void main(String[] args){
		int choice;
		String stringChoice;

		Scanner in = new Scanner(System.in);

		while(true){
			Bike bike;

			System.out.println("1. Buy a bike\n2. Exit");
			choice = in.nextInt();

			if(choice == 2){
				break;
			}

			System.out.println("1. Buy Fixed Gear Bike\n2. Buy Road Bike\n3. Buy Hybrid Bike\n4. Buy Mountain Bike");
			choice = in.nextInt();

			switch(choice){
				case 1:
					bike = new FixedGearBike();
					break;
				case 2:
					bike = new RoadBike();
					break;
				case 3:
					bike = new HybridBike();
					break;
				case 4:
					bike = new MountainBike();
					break;
				default:
					bike = new FixedGearBike();
					break;
			}
			
			System.out.print("Do you want horn? [y/n]: ");
			in.nextLine();
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				bike = new BikeHornDecorator(bike);
			}

			System.out.print("Do you want basket? [y/n]: ");
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				bike = new BikeBasketDecorator(bike);
			}

			System.out.print("Do you want lights? [y/n]: ");
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				System.out.println("1. Front Light\n2. Back Light\n3. Both Front and Back Lights");
				choice = in.nextInt();
				bike = new BikeLightDecorator(bike, choice);
			}

			System.out.println(bike.getDescription() + " || $" + bike.cost());

		}//end while
	}

}
