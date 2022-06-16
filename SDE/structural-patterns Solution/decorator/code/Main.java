import java.util.Scanner;

public class Main{

	public static void main(String[] args){
		
		int choice;
		String stringChoice;

		Scanner in = new Scanner(System.in);
		//Jersey jersey = new HomeJersey();

		//jersey = new JerseyNameDecorator(jersey, "Nazmus Saquib");
		//jersey = new JerseyNumberDecorator(jersey, "2527");
		//jersey = new JerseyCrestDecorator(jersey, "Champions League");

		//System.out.println(jersey.getDescription() + " || $" + jersey.cost());

		while(true){
			Jersey jersey;

			System.out.println("1. Buy a Jersey\n2. Exit");
			choice = in.nextInt();

			if(choice == 2){
				break;
			}

			System.out.println("1. Buy Home Jersey\n2. Buy Away Jersey\n3. Buy Third Jersey");
			choice = in.nextInt();

			switch(choice){
				case 1:
					jersey = new HomeJersey();
					break;
				case 2:
					jersey = new AwayJersey();
					break;
				case 3:
					jersey = new ThirdJersey();
					break;
				default:
					jersey = new HomeJersey();
					break;
			}

			System.out.print("Do you want name? [y/n]: ");
			in.nextLine();
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				System.out.print("Enter your name: ");
				stringChoice = in.nextLine();
				jersey = new JerseyNameDecorator(jersey, stringChoice);
			}

			System.out.print("Do you want number? [y/n]: ");
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				System.out.print("Enter your number: ");
				stringChoice = in.nextLine();
				jersey = new JerseyNumberDecorator(jersey, stringChoice);
			}

			System.out.print("Do you want crest? [y/n]: ");
			stringChoice = in.nextLine();
			if(stringChoice.equals("y")){
				System.out.print("Enter choice [1/2/3/4 - FA Cup/Premiere League/Europa League/Champions League]: ");
				choice = in.nextInt();
				switch(choice){
					case 1:
						jersey = new JerseyCrestDecorator(jersey, "FA Cup");
						break;
					case 2:
						jersey = new JerseyCrestDecorator(jersey, "Premiere League");
						break;
					case 3:
						jersey = new JerseyCrestDecorator(jersey, "Europa League");
						break;
					case 4:
						jersey = new JerseyCrestDecorator(jersey, "Champions League");
						break;
				}
			}

			System.out.println(jersey.getDescription() + " || $" + jersey.cost());
		}

	}

}
