import java.util.Scanner;

public class Main{

	public static void main(String[] args){
		int choice;
		int round = 0;
		int enemyPosition = 100;
		boolean won = false;

		System.out.println("SCENARIO: Enemy tower at a distance of " + enemyPosition + " units.");

		MobileTower enemyTower = new MobileTower();
		enemyTower.setPosition(enemyPosition);
		LongRangeUnit mlruAdapterForMT = new MobileLongRangeUnitAdapter(enemyTower);

		while(true){
			System.out.print("Enter choice [1/2/3 - bowman/advanced bowman/chariot archer]: ");

			Scanner in = new Scanner(System.in);
			choice = in.nextInt();

			LongRangeUnit lru;

			switch(choice){
				case 1: lru = new Bowman(); break;
				case 2: lru = new AdvancedBowman(); break;
				case 3: ChariotArcher ca = new ChariotArcher(); lru = new MobileLongRangeUnitAdapter(ca); break;
				default: lru = new Bowman(); break;
			}

			while(true){
				round += 1;
				System.out.print("Round " + round + ") ");

				System.out.print(lru.getName() + ": ");
				System.out.print("Current hp " + lru.getHP() + ". ");
				if(lru.getHP() <= 0){
					System.out.println("UNIT DEAD!");
					round--;
					break;
				}else{
					if((lru.getPosition() + lru.getStepSize()) <= mlruAdapterForMT.getPosition()){
						lru.walk();
					}
					System.out.print("Positioned at " + lru.getPosition() + ". ");
					if((lru.getPosition() + lru.getRange()) >= mlruAdapterForMT.getPosition()){
						lru.shootArrow();
						mlruAdapterForMT.setHP(mlruAdapterForMT.getHP() - lru.getDamage());
					}
				}

				System.out.print(mlruAdapterForMT.getName() + ": ");
				System.out.print("Current hp " + mlruAdapterForMT.getHP() + ". ");
				if(mlruAdapterForMT.getHP() <= 0){
					System.out.println("BATTLE WON!");
					won = true;
					break;
				}else{
					if((mlruAdapterForMT.getPosition() - mlruAdapterForMT.getRange()) <= lru.getPosition()){
						mlruAdapterForMT.shootArrow();
						lru.setHP(lru.getHP() - mlruAdapterForMT.getDamage());
					}
				}
				System.out.println("");

				if(won == true){
					break;
				}

			}

			if(won == true){
				break;
			}
		}
	}

}
