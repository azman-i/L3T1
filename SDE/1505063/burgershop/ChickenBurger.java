
package burgershop;


 class ChickenBurger implements ItemInterface {
     private String pattystr;
      private String cheesestr; 
       private String saucestr;
    @Override 
    public void addPatty(String str)
    {
        //System.out.println("Chicken Patty added");
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
