import java.util.HashMap;
import java.util.Map;

public class JerseyCrestDecorator extends JerseyDecorator{

	private Jersey jersey;
	private String crest;
	private double costPerDigit = 3;
	private Map<String,Double> map = new HashMap<String,Double>();

	public JerseyCrestDecorator(Jersey jersey, String crest){
		this.jersey = jersey;
		this.crest = crest;

		map.put("FA Cup", 8.0);
		map.put("Premiere League", 10.0);
		map.put("Europa League", 15.0);
		map.put("Champions League", 20.0);
	}

	public String getDescription(){
		return jersey.getDescription() + " playing in " + crest;
	}

	public double cost(){
		return map.get(crest) + jersey.cost();
	}

}

