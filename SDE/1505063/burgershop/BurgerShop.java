
package burgershop;

import java.util.Scanner;


public class BurgerShop {

    
    public static void main(String[] args) {
       Waiter waiter=new Waiter();
       while(true)
       {
           System.out.println("1.Beef Burger  2.Chicken Burger");
           Scanner reader = new Scanner(System.in);
           int number=reader.nextInt();
           ItemInterface item=null;
           if(number==1)
           { item=waiter.getBurger("Beef Burger");
     
           }
           else if(number==2)
           { item=waiter.getBurger("Chicken Burger");
      
           }
           else
           {
               System.out.println("Not available");
           }
           if(item!=null)
           {
                item.showpatty();
       item.showcheese();
       item.showsauce();
           }
           
       }
    }
    
}
