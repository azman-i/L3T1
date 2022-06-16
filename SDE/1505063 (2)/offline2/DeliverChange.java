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
public class DeliverChange implements SwitchPress{
    @Override
    public void pressSwitch(VendorMachine machine)
    {
        System.out.println("Delivered and changed");
        int d=machine.getcapacity();
        machine.setcapacity(d--);
    }
}
