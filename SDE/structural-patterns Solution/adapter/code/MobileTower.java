public class MobileTower implements MobileLongRangeUnit{

	private int range = 50;
	private int hp = 200;
	private int stepSize = 1;
	private int damage = 20;
	private int position = 0;
	private String name = "Tower";

	public void shoot(){
		System.out.print("Shooting improved arrow. ");
	}

	public void drive(){
		System.out.print("Driving. ");
	}

	public int getRange(){
		return range;
	}

	public int getHP(){
		return hp;
	}

	public int getStepSize(){
		return stepSize;
	}

	public int getDamage(){
		return damage;
	}

	public int getPosition(){
		return position;
	}


	public String getName(){
		return name;
	}

	public void setRange(int range){
		this.range = range;
	}

	public void setHP(int hp){
		this.hp = hp;
	}

	public void setStepSize(int stepSize){
		this.stepSize = stepSize;
	}

	public void setDamage(int damage){
		this.damage = damage;
	}

	public void setPosition(int position){
		this.position = position;
	}


	public void setName(String name){
		this.name = name;
	}

}
