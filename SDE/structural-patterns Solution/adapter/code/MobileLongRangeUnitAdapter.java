public class MobileLongRangeUnitAdapter implements LongRangeUnit{

	MobileLongRangeUnit mlru;

	public MobileLongRangeUnitAdapter(MobileLongRangeUnit mlru){
		this.mlru = mlru;
	}

	public void shootArrow(){
		mlru.shoot();
	}

	public void walk(){
		mlru.drive();
	}

	public int getRange(){
		return mlru.getRange();
	}

	public int getHP(){
		return mlru.getHP();
	}

	public int getStepSize(){
		return mlru.getStepSize();
	}

	public int getDamage(){
		return mlru.getDamage();
	}

	public int getPosition(){
		return mlru.getPosition();
	}

	public String getName(){
		return mlru.getName();
	}

	public void setRange(int range){
		mlru.setRange(range);
	}

	public void setHP(int hp){
		mlru.setHP(hp);
	}

	public void setStepSize(int stepSize){
		mlru.setStepSize(stepSize);
	}

	public void setDamage(int damage){
		mlru.setDamage(damage);
	}

	public void setPosition(int position){
		mlru.setPosition(position);
	}

	public void setName(String name){
		mlru.setName(name);
	}

}
