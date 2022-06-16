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
public class insertcoin implements SwitchPress {
    public void pressSwitch(VendorMachine machine)
    {
        System.out.println("Coin inserted");
        if(machine.getcoin()<machine.getprice())
        {
            machine.setState(new NoDeliverCurrency());
        }
        if(machine.getcoin()>machine.getprice())
        {
            machine.setState(new DeliverChange());
        }
        if(machine.getcoin()==machine.getprice())
        {
            //System.out.println("here");
            machine.setState(new DeliverNochange());
        }
        if(machine.getcapacity()==0)
        {
            machine.setState(new NoDeliverInventory());
        }
        
        
    }
    
}
