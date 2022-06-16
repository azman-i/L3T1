
package coffeefactory;


public class CreateFactory {
    private static CreateFactory factory=null;
    private CreateFactory()
    {
        
    }
    public static CreateFactory getFactory()
    {
        if(factory==null)
            factory= new CreateFactory();
        return factory;
    }
    public CoffeeInterface ProduceCoffee(String str)
   {
       if(str==null)
           return null;
       if(str.equalsIgnoreCase("CoffeeA"))
           return  new CoffeeA();
       if(str.equalsIgnoreCase("CoffeeB"))
           return new CoffeeB();
        if(str.equalsIgnoreCase("CoffeeC"))
           return new CoffeeC();
       return null;
   }
    
    
}
