/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package offline2;

/**
 *
 * @author DELL
 */
public class VendorMachine {
    private int taka;
    private int capacity=0;
      private int price;
    private SwitchPress state;
    public SwitchPress getState()
    {
        return state;
    }
    public void setState(SwitchPress state)
    {
        this.state=state;
    }
    public VendorMachine(SwitchPress state)
    {
        this.state=state;
    }
    public void setprice(int price)
    {
        System.out.println(price);
       this.price=price;
    }
     public void setcapacity(int capacity)
    {
      
       this.capacity=+capacity;
        //System.out.println(capacity);
    }
    public void pressButton()
    {
       // System.out.println("h");
        state.pressSwitch(this);
    }
    public void InsertCoin(int taka)
    {
        this.taka=taka;
       // System.out.println(taka);
        state.pressSwitch(this);
        
    }
    public int getcoin()
    {
        return taka;
    }
    public int getprice()
    {
        return price;
    }
    public int getcapacity()
    {
        return capacity;
    }

    
}
