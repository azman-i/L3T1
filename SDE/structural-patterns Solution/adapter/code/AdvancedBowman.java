public class AdvancedBowman implements LongRangeUnit{

	private int range = 20;
	private int hp = 80;
	private int stepSize = 10;
	private int damage = 20;
	private int position = 0;
	private String name = "Advanced Bowman";

	public void shootArrow(){
		System.out.print("Shooting fire arrow. ");
	}

	public void walk(){
		System.out.print("Walking. ");
		position += stepSize;
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
