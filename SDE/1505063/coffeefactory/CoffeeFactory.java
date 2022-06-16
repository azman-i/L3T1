
package coffeefactory;

import java.util.Scanner;


public class CoffeeFactory {

   
    public static void main(String[] args) {
      CreateFactory factory=CreateFactory.getFactory();
      while(true){
          CoffeeInterface coffee=null;
          System.out.println("1.Coffee A   2.Coffee B(For diabatic people)  3.Coffee C");
          Scanner sc=new Scanner(System.in);
          int number =sc.nextInt();
          if(number==1){
      coffee=factory.ProduceCoffee("CoffeeA");
    
          }
           else if(number==2){
       coffee=factory.ProduceCoffee("CoffeeB");
     
          }
             else if(number==3){
       coffee=factory.ProduceCoffee("CoffeeC");
      
          }
          else
             {
                 System.out.println("Not available");
             }
          if(coffee!=null)
          {
              coffee.addCaffein();
      coffee.addSugar();
      coffee.addmilk();
              
          }
       
      }
    }
    
}
