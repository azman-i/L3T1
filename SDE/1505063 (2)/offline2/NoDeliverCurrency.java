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
public class NoDeliverCurrency implements SwitchPress {
    
    public void pressSwitch(VendorMachine machine)
    {
        System.out.println("No delivered because of insufficient currency");
    }
}
