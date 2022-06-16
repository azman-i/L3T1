/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package burgershop;

/**
 *
 * @author DELL
 */
public class Waiter {
   public ItemInterface getBurger(String str)
   {
       if(str==null)
           return null;
       if(str.equalsIgnoreCase("Chicken Burger"))
       {
           ChickenBurger chb=new ChickenBurger();
           chb.addCheese("Chicken cheese");
           chb.addPatty("Chicken Patty");
           chb.addSauce("Chicken Sauce");
           return  chb;
       }
       
       if(str.equalsIgnoreCase("Beef Burger"))
       {
           BeefBurger bfb=new BeefBurger();
           bfb.addCheese("Beef cheese");
           bfb.addPatty("Beef Patty");
           bfb.addSauce("Beef Sauce");
           return  bfb;
       }
       return null;
   }
    
}
