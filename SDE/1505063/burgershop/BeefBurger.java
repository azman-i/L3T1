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
public class BeefBurger implements ItemInterface {
      private String pattystr;
      private String cheesestr; 
       private String saucestr;
      @Override
    public void addPatty(String str)
    {
        pattystr=str;
    }

    @Override
    public void addCheese(String str) {
      cheesestr=str;
    }

    @Override
    public void addSauce(String str) {
        saucestr=str;
    }
    public void showpatty()
    {
        System.out.println(pattystr+"  is added");
        
    }
     public void showcheese()
    {
        System.out.println(cheesestr+"  is added");
        
    }
      public void showsauce()
    {
        System.out.println(saucestr+"  is added");
        
    }
   
    
}
